import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/classes/models/mechanic.dart';
import 'package:slahly/classes/models/towProvider.dart';

import '../../../main.dart';

class RSA {
  RSA_state state = RSA_state.created;
  late CustomLocation location; // lazm yt2sm le long w lat
  late String RSA_id;
  late String userID;
  late TowProvider towProvider;
  late Mechanic mechanic;
  late DateTime estimatedTime;
  late List<Mechanic> nearbyMechanics; // not included in FB
  late List<TowProvider> nearbyProviders; // not included in FB

  bool requestNearbyMechanics(){
    //uses location get nearby mechs
    nearbyMechanics = [];
    return false;
  }

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
      print('Location permissions are permanently denied, we cannot request permissions.');
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return true;
  }

  Future<CustomLocation> getUserLocation() async {
    _checkLocationPermission().onError((error, stackTrace)  {
      print(error);
      return null;
    });
    print("sad");
    Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return CustomLocation(longitude: pos.longitude,latitude: pos.latitude);
    print("sad");
  }

  bool requestNearbyProviders(){
    //uses location get nearby mechs
    nearbyProviders = [];
    return false;
  }

  bool chooseMechanic(Mechanic mech) {
    //momken nbdlha b firebase ID aw ayan kan
    mechanic = mech;

    return false;
  }

  bool chooseProvider(TowProvider provider) {
    //momken nbdlha b firebase ID aw ayan kan
    towProvider = provider;

    return false;
  }

  Future<bool> createRSA(loc,uId) async {
    _RSA(location: loc, userID: uId);

    dbRef.child("RSA").set({
      'date': 'sergi',
      'text': 'kokoko'
    });
    // http
    // var url = Uri.parse(fbcfurl+"helloWorld");
    // var response = await http.get(url);
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
    return (RSA_id != null);
  }
  // the constructor private so you should use the createRSA function
  _RSA({required location,required userID}) async {
   // create RSA in firebase
    String rsaId = "";
    if(rsaId != null){

      RSA_id = rsaId;
    }else{
      throw Exception("Could not create RSA");
    }

   // return RSA_id
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
