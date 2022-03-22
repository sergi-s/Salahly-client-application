import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:slahly/classes/firebase/nearbylocations.dart';
import 'package:slahly/classes/models/client.dart';
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/classes/models/mechanic.dart';
import 'package:slahly/classes/models/towProvider.dart';
import 'package:slahly/main.dart';

class RSA {

  RSA_state state = RSA_state.created;
  CustomLocation? location; // lazm yt2sm le long w lat
  String? rsaID;
  String? problemDescription;
  Client? user;
  TowProvider? towProvider;
  Mechanic? mechanic;
  DateTime? estimatedTime;
  List<Mechanic>? nearbyMechanics; // not included in FB
  List<TowProvider>? nearbyProviders; // not included in FB

  _setProblemDescription(String description) {
    problemDescription = description;
  }

  RSA({
    Mechanic? mechanic,
    TowProvider? towProvider,
    RSA_state? state,
    String? problemDescription,
    List<Mechanic>? nearbyMechanics,
    List<TowProvider>? nearbyProviders,
    CustomLocation? location,
    String? rsaID,
    Client? user,
  }) {
    this.mechanic = mechanic ?? this.mechanic;
    this.towProvider = towProvider ?? this.towProvider;
    this.state = state ?? this.state;
    this.problemDescription = problemDescription ?? problemDescription;
    this.nearbyMechanics = nearbyMechanics ?? this.nearbyMechanics;
    this.nearbyProviders = nearbyProviders ?? this.nearbyProviders;
    this.location = location ?? this.location;
    this.rsaID = rsaID ?? this.rsaID;
    this.user = user ?? this.user;
  }

  RSA copyWith({
    Mechanic? mechanic,
    TowProvider? provider,
    RSA_state? state,
    String? problemDescription,
    List<Mechanic>? nearbyMechanics,
    List<TowProvider>? nearbyProviders,
    CustomLocation? location,
    String? rsaID,
    Client? user,
  }) =>
      RSA(
          mechanic:mechanic ?? this.mechanic,
          towProvider : provider ?? this.towProvider,
          state : state ?? this.state,
          problemDescription : problemDescription ?? this.problemDescription,
          nearbyMechanics : nearbyMechanics ?? this.nearbyMechanics,
          nearbyProviders : nearbyProviders ?? this.nearbyProviders,
          location : location ?? this.location,
          rsaID : rsaID ?? this.rsaID,
          user : user ?? this.user,
      );

  String getProblemDescription() => problemDescription!;

  Mechanic getMechanic() => mechanic!;

  TowProvider getProvider() => towProvider!;

  Future _checkLocationPermission() async {
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

  Future<CustomLocation> getUserLocation() async {
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
        location!.latitude,
        location!.longitude,
        // user.getSubscriptionRange()!.toDouble(),
        100,
        nearbyProviders!);
  }

  requestNearbyMechanics() async {
    //uses location get nearby mechs
    nearbyMechanics = [];

    await NearbyLocations.getNearbyMechanics(
        location!.latitude,
        location!.longitude,
        // user.getSubscriptionRange()!.toDouble(),
        100,
        nearbyMechanics!);
  }

  _setMechanic(Mechanic mech, bool stopListener) {
    //momken nbdlha b firebase ID aw ayan kan
    mechanic = mech;
    if (stopListener) {
      NearbyLocations.stopListener();
    }
  }

  _setProvider(TowProvider provider, bool stopListener) {
    //momken nbdlha b firebase ID aw ayan kan
    towProvider = provider;
    if (stopListener) {
      NearbyLocations.stopListener();
    }
  }

  Future requestRSA() async {
    //testing purpose
    user = Client(
        email: 'momo',
        name: "sd",
        id: "3",
        subscription: SubscriptionTypes.silver);

    ///TODO MAKE THIS FROM USER DATA

    DatabaseReference newRSA = dbRef.child("rsa").push();
    await newRSA.set({
      "userID": user!.id,
      "latitude": location!.latitude,
      "longitude": location!.longitude,
      "towProviderID": towProvider!.id,
      "mechanic": mechanic!.id,
      "state": RSA_state.waiting_for_mech_response.toString()
    });
    state = RSA_state.waiting_for_mech_response;
    rsaID = newRSA.key.toString();
    return true;
    return false;
  }
}

enum RSA_state {
  canceled,
  created,
  // user_choosing_mech,
  // user_choosing_prov,
  waiting_for_arrival,
  confirmed_arrival,
  done,
  searching_for_nearby_mech,
  searching_for_nearby_prov,
  waiting_for_mech_response,
  waiting_for_prov_response,
  requesting_rsa,
  failed_to_request_rsa
}
