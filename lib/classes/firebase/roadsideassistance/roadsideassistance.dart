import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:slahly/classes/firebase/nearbylocations.dart';
import 'package:slahly/classes/models/client.dart';
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/classes/models/mechanic.dart';
import 'package:slahly/classes/models/towProvider.dart';
import 'package:slahly/main.dart';
import "package:http/http.dart" as http;

import '../../../utils/constants.dart';

class RSA {
  RSA_state state = RSA_state.created;
  late CustomLocation _location; // lazm yt2sm le long w lat
  late String RSA_id;
  late Client _user;
  late TowProvider _towProvider;
  late Mechanic _mechanic;
  late DateTime _estimatedTime;
  late List<Mechanic> nearbyMechanics; // not included in FB
  late List<TowProvider> nearbyProviders; // not included in FB

  setLocation(CustomLocation ll) {
    _location = ll;
  }

  static Future _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      print("Location services are disabled.");
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        print('Location permissions are denied');
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      print(
          'Location permissions are permanently denied, we cannot request permissions.');
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return true;
  }

  static Future<CustomLocation> getUserLocation() async {
    _checkLocationPermission().onError((error, stackTrace) {
      print(error);
      return null;
    });
    print("sad");
    Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return CustomLocation(longitude: pos.longitude, latitude: pos.latitude);
  }

  requestNearbyProviders() async {
    //uses location get nearby mechs
    nearbyProviders = [];
    await NearbyLocations.getNearbyProviders(
        _location.latitude,
        _location.longitude,
        // user.getSubscriptionRange()!.toDouble(),
        100,
        nearbyProviders);
  }

  requestNearbyMechanics() async {
    //uses location get nearby mechs
    nearbyMechanics = [];

    await NearbyLocations.getNearbyMechanics(
        _location.latitude,
        _location.longitude,
        // user.getSubscriptionRange()!.toDouble(),
        100,
        nearbyMechanics);
  }

  setMechanic(Mechanic mech, bool stopListener) {
    //momken nbdlha b firebase ID aw ayan kan
    _mechanic = mech;
    if (stopListener) NearbyLocations.stopListener();
  }

  setProvider(TowProvider provider, bool stopListener) {
    //momken nbdlha b firebase ID aw ayan kan
    _towProvider = provider;
    if (stopListener) NearbyLocations.stopListener();
  }

  Future requestRSA() async {
    //testing purpose
    _user = Client(
        email: 'momo',
        name: "sd",
        id: "3",
        subscription: SubscriptionTypes.silver);

    DatabaseReference newRSA = dbRef.child("rsa").push();
    if (newRSA != null) {
      await newRSA.set({
        "userID": _user.id,
        "latitude": _location.latitude,
        "longitude": _location.longitude,
        "towProviderID": _towProvider.id,
        "mechanic": _mechanic.id,
        "state": RSA_state.waiting_for_mech_response.toString()
      });
      state = RSA_state.waiting_for_mech_response;
      RSA_id = newRSA.key.toString();
      return true;
    }
    return false;
  }

  static Future<dynamic> getRequest(String url) async {
    http.Response response = await http.get(Uri.parse(url));
    try {
      if (response.statusCode == 200) {
        String jsonData = response.body;
        var decodeData = jsonDecode(jsonData);
        return decodeData;
      } else {
        return "failed";
      }
    } catch (e) {
      return "failed";
    }
  }

  static Future<String> searchCoordinateAddress(double long, double lat) async {
    late String placeAddress;
    String geoURL =
        "https://open.mapquestapi.com/geocoding/v1/reverse?key=$geoCodingKey&includeRoadMetadata=true&includeNearestIntersection=true&location=${lat},${long}";

    var response = await getRequest(geoURL);

    if (response != "failed") {
      placeAddress =
          "${response["results"][0]["locations"][0]["street"]}, ${response["results"][0]["locations"][0]["adminArea3"]}, ${response["results"][0]["locations"][0]["adminArea1"]}";
    }
    return placeAddress;
  }
}

enum RSA_state {
  canceled,
  created,
  user_choosing_mech,
  user_choosing_prov,
  waiting_for_arrival,
  confirmed_arrival,
  done,
  searching_for_nearby_mech,
  searching_for_nearby_prov,
  waiting_for_mech_response,
  waiting_for_prov_response
}
