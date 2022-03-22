import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/classes/models/mechanic.dart';
import 'package:slahly/classes/models/towProvider.dart';
import 'package:slahly/main.dart';
import 'package:string_validator/string_validator.dart';


class NearbyLocations {
  // List<Mechanic> nearbyMechanics = [] ;
  // List<TowProvider> nearbyProviders = [];

  // NearbyLocations() {
  //   // FirebaseAuth.instance.signOut();
  //
  //   // _getUserLocation();
  // }

  static _addNearbyMechanics() async {
    _initializeGeoFireMechanic();
    CustomLocation loc_1 = CustomLocation(
        latitude: 31.207877,
        longitude: 29.918180,
        name: "1",
        // name: "mech 1",
        type: LocationType.mechanic);
    CustomLocation loc_2 = CustomLocation(
        latitude: 31.207545,
        longitude: 29.919915,
        name: "2",
        // name: "mech 2",
        type: LocationType.mechanic);
    var locs = [loc_1, loc_2];
    //31.207545, 29.919915
    for (CustomLocation lolo in locs) {
      await _addLocToDB(lolo);
    }
  }

  static _addNearbyProviders() async {
    _initializeGeoFireProvider();
    CustomLocation loc_3 = CustomLocation(
        latitude: 31.206866,
        longitude: 29.918298,
        name: "3",
        type: LocationType.provider);
    var locs = [loc_3];
    //31.207545, 29.919915
    for (CustomLocation lolo in locs) {
      await _addLocToDB(lolo);
    }
  }

  static _addLocToDB(CustomLocation lola) async {
    // await dbRef.child("available").child((lola.name).toString()).set({
    //
    // });
    return (await Geofire.setLocation(
        lola.name.toString(), lola.latitude, lola.longitude));
  }

  static _initializeGeoFireMechanic() {
    String pathToReference = "available/mechanics";
    // String pathToReference = "availableMechanics";
    pathToReference = dbRef.child(pathToReference).path;
    Geofire.initialize(pathToReference);
  }

  static _initializeGeoFireProvider() {
    String pathToReference = "available/providers";
    // String pathToReference = "availableProviders";
    pathToReference = dbRef.child(pathToReference).path;
    Geofire.initialize(pathToReference);
  }

  /*
g stt38c1c4v
0 31.206866
1 29.918298


stt38c1z01
31.207877
29.91818


stt38c5j0s
31.207545
29.919915




  */

  static Future _getMechanicData(String id) async {
    // FirebaseEmulatorScreen().readmsg();

    // dbRef.child("users").child(id).get().then((value) {
    //   print(value.value);
    //
    //   Mechanic me = Mechanic(name: value.value, email: "");
    // });

    DataSnapshot ds =
        await dbRef.child("users").child("mechanics").child(id).get();

    return Mechanic(
        id: id,
        name: (ds.child("name").value).toString(),
        email: (ds.child("email").value).toString(),
        rating: toDouble((ds.child("rating").value).toString()));
  }

  static _getProviderData(String id) async {
    // FirebaseEmulatorScreen().readmsg();
    DataSnapshot ds =
        await dbRef.child("users").child("providers").child(id).get();

    return TowProvider(
        id: id,
        name: (ds.child("name").value).toString(),
        email: (ds.child("email").value).toString(),
        rating: toDouble((ds.child("rating").value).toString()),
        isCenter: toBoolean((ds.child("isCenter").value).toString()),
        nationalID: (ds.child("nationalID").value).toString());
  }

  _getNearbyMechanicsSecondVersion(double lat,double long, double radius,List<Mechanic> nearbyMechanics) async {
    // Stream? st = Geofire.queryAtLocation(lat,long, radius);
    await _initializeGeoFireMechanic();
    StreamSubscription? nearbyMechanicSubscription =
    Geofire.queryAtLocation(lat,long, radius)?.listen((map) {
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']
        switch (callBack) {
          case Geofire.onKeyEntered:
            _getMechanicData(map["key"]).then((value) {
              nearbyMechanics.add(value);
              print("Added mechanic: "+value.name);
            });

            break;

          case Geofire.onKeyExited:
          // keysRetrieved.remove(map["key"]);
            for (var m in nearbyMechanics) {
              if(m.id == map["key"]){
                nearbyMechanics.remove(m);
                print("Added mechanic: "+m.name.toString());
              }
            }
            break;

          case Geofire.onKeyMoved:
          ///TODO to be tested
          // Update your key's location
          // for (var m in nearbyMechanics) {
          //   if(m.id == map["key"]){
          //     getMechanicData(map["key"]).then((value) {
          //       m = value;
          //     });
          //   }
          // }
            print("a7eh update");
            break;

          case Geofire.onGeoQueryReady:
          // All Intial Data is loaded
            print("sad");
            print(map["result"]);

            break;
        }
      }
    });

    // nearbyMechanicSubscription?.onDone(() {print("done");nearbyMechanicSubscription.cancel(); print("done");});
  }

  static stopListener() async {
    return await Geofire.stopListener();
  }

  static getNearbyMechanics(double lat,double long, double radius,List<Mechanic> nearbyMechanics) async {
    nearbyMechanics.clear();
    // String pathToReference = "available/mechanics";
    // pathToReference = FirebaseDatabase.instance.ref().child("available").child("mechanics").path;
    // Geofire.initialize(pathToReference);

    _initializeGeoFireMechanic();

    ///TODO insert user location
    Geofire.queryAtLocation(lat,long, radius)?.listen(
            (map) {
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']
        switch (callBack) {
          case Geofire.onKeyEntered:
            _getMechanicData(map["key"]).then((value) {
              nearbyMechanics.add(value);
              print("Added mechanic: "+value.name);
            });

            break;

          case Geofire.onKeyExited:
            // keysRetrieved.remove(map["key"]);
            for (var m in nearbyMechanics) {
              if(m.id == map["key"]){
                nearbyMechanics.remove(m);
                print("Added mechanic: "+m.name.toString());
              }
            }
            break;

          case Geofire.onKeyMoved:
            ///TODO to be tested
            // Update your key's location
            // for (var m in nearbyMechanics) {
            //   if(m.id == map["key"]){
            //     getMechanicData(map["key"]).then((value) {
            //       m = value;
            //     });
            //   }
            // }
            print("a7eh update");
            break;

          case Geofire.onGeoQueryReady:
            // All Intial Data is loaded
            print("sad");
            print(map["result"]);

            break;
        }
      }
    }
    );
  }
  static getNearbyProviders(double lat,double long, double radius,List<TowProvider> nearbyProviders) async {
    nearbyProviders.clear();
    // String pathToReference = "available/mechanics";
    // pathToReference = FirebaseDatabase.instance.ref().child("available").child("mechanics").path;
    // Geofire.initialize(pathToReference);

    _initializeGeoFireProvider();

    ///TODO insert user location
    Geofire.queryAtLocation(lat,long, radius)?.listen((map) {
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
          case Geofire.onKeyEntered:

            _getProviderData(map["key"]).then((value) {
              nearbyProviders.add(value);
              print("Added provider: "+value.name);
            });

            break;

          case Geofire.onKeyExited:
          // keysRetrieved.remove(map["key"]);
            for (var m in nearbyProviders) {
              if(m.id == map["key"]){
                nearbyProviders.remove(m);
                print("Removed provider: "+m.name.toString());
              }
            }
            print("a7ooooh");
            break;

          case Geofire.onKeyMoved:
          ///TODO to be tested
          // Update your key's location
          //   for (var m in nearbyProviders) {
          //     if(m.id == map["key"]){
          //       getProviderData(map["key"]).then((value) {
          //         m = value;
          //       });
          //     }
          //   }
            print("a7eh update");
            break;

          case Geofire.onGeoQueryReady:
          // All Intial Data is loaded
            print("sad");
            print(map["result"]);

            break;
        }
      }
    });
  }
  _getUserLocation() async {
    return await RSA.getUserLocation();
  }
}
