import 'dart:async';

import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/classes/models/mechanic.dart';
import 'package:slahly/classes/models/towProvider.dart';
import 'package:slahly/classes/provider/rsadata.dart';
import 'package:slahly/main.dart';
import 'package:slahly/utils/firebase/get_mechanic_data.dart';
import 'package:slahly/utils/firebase/get_mechanic_provider.dart';
import 'package:slahly/utils/firebase/get_provider_data.dart';

class NearbyLocations {
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

  static _addNearbyMechanicsAndProviders() async {
    _initializeGeoFireOnAvailable();
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
    CustomLocation loc_3 = CustomLocation(
        latitude: 31.206866,
        longitude: 29.918298,
        name: "3",
        type: LocationType.provider);
    var locs = [loc_1,loc_2,loc_3];
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

  static _initializeGeoFireMechanic() async {
    String pathToReference = "available/mechanics";
    // String pathToReference = "availableMechanics";
    pathToReference = dbRef.child(pathToReference).path;
    await Geofire.initialize(pathToReference);
  }

  static _initializeGeoFireProvider() async {
    String pathToReference = "available/providers";
    // String pathToReference = "availableProviders";
    pathToReference = dbRef.child(pathToReference).path;
    await Geofire.initialize(pathToReference);
  }

  static _initializeGeoFireOnAvailable() async {
    String pathToReference = "available";
    // String pathToReference = "availableProviders";
    pathToReference = dbRef.child(pathToReference).path;
    await Geofire.initialize(pathToReference);
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

  static getNearbyMechanicsAndProviders(
      double lat, double long, double radius, Ref ref) async {
    List<TowProvider> nearbyProviders = [];
    List<Mechanic> nearbyMechanics = [];
    await _initializeGeoFireOnAvailable();

    final rsa = ref.watch(rsaProvider.notifier);

    ///TODO insert user location
    Geofire.queryAtLocation(lat, long, radius)?.listen((map) {
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']
        switch (callBack) {
          case Geofire.onKeyEntered:
            getMechanicOrProviderData(map["key"]).then((value) {
              value.loc = CustomLocation(latitude: map['latitude'], longitude: map['longitude']);
              if (value is Mechanic) {
                nearbyMechanics.add(value);
                rsa.assignNearbyMechanics(nearbyMechanics);
                print("Added mechanic: " + value.name!);
              } else if (value is TowProvider) {
                nearbyProviders.add(value);
                rsa.assignNearbyProviders(nearbyProviders);
                print("Added provider: " + value.name!);
              }else{
                print("Not mechanic and not provider");
              }
            });

            break;

          case Geofire.onKeyExited:
            // keysRetrieved.remove(map["key"]);
            for (var m in nearbyProviders) {
              if (m.id == map["key"]) {
                nearbyProviders.remove(m);
                rsa.assignNearbyProviders(nearbyProviders);
                print("Added provider: " + m.name.toString());
              }
            }
            for (var m in nearbyMechanics) {
              if (m.id == map["key"]) {
                nearbyMechanics.remove(m);
                rsa.assignNearbyMechanics(nearbyMechanics);
                print("Added provider: " + m.name.toString());
              }
            }
            break;

          case Geofire.onKeyMoved:

            ///TODO to be tested
            for (var m in nearbyProviders) {
              if (m.id == map["key"]) {
                nearbyProviders.remove(m);
                getMechanicOrProviderData(map["key"]).then((value) {
                  value.loc = CustomLocation(latitude: map['latitude'], longitude: map['longitude']);
                  nearbyProviders.add(value);
                  rsa.assignNearbyProviders(nearbyProviders);
                  print("Added provider: " + m.name.toString());
                });
              }
            }
            for (var m in nearbyMechanics) {
              if (m.id == map["key"]) {
                nearbyMechanics.remove(m);
                getMechanicOrProviderData(map["key"]).then((value) {
                  value.loc = CustomLocation(latitude: map['latitude'], longitude: map['longitude']);
                  nearbyMechanics.add(value);
                  rsa.assignNearbyMechanics(nearbyMechanics);
                  print("Added provider: " + m.name.toString());
                });
              }
            }
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

    // .onDone(() {print("FINISHED PROVIDERS");});
  }

  static _getNearbyMechanics(
      double lat, double long, double radius, Ref ref) async {
    List<Mechanic> nearbyMechanics = [];
    _initializeGeoFireMechanic();
    final rsa = ref.watch(rsaProvider.notifier);

    ///TODO insert user location
    Stream? stream = Geofire.queryAtLocation(lat, long, radius);
    return stream!.listen((map) {
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']
        switch (callBack) {
          case Geofire.onKeyEntered:
            getMechanicData(map["key"]).then((value) {
              nearbyMechanics.add(value);
              rsa.assignNearbyMechanics(nearbyMechanics);
              print("Added mechanic: " + value.name);
            });

            break;

          case Geofire.onKeyExited:
            // keysRetrieved.remove(map["key"]);
            for (var m in nearbyMechanics) {
              if (m.id == map["key"]) {
                nearbyMechanics.remove(m);
                rsa.assignNearbyMechanics(nearbyMechanics);
                print("Added mechanic: " + m.name.toString());
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
    // ref.watch(rsaProvider.notifier).addListener((state) {
    //   print("sad");
    //   if(state.state == RSAStates.canceled) {
    //     subscription.cancel();
    //     Geofire.stopListener();
    //   }
    //   print("sad");
    // });
    // nearbyMechanicSubscription?.onDone(() {print("done");nearbyMechanicSubscription.cancel(); print("done");});
  }

  static stopListener() async {
    return await Geofire.stopListener();
  }

  static _getNearbyProviders(
      double lat, double long, double radius, Ref ref) async {
    print("Get provider");
    List<TowProvider> nearbyProvider = [];
    await _initializeGeoFireProvider();

    final rsa = ref.watch(rsaProvider.notifier);

    ///TODO insert user location
    Geofire.queryAtLocation(lat, long, radius)?.listen((map) {
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']
        switch (callBack) {
          case Geofire.onKeyEntered:
            getProviderData(map["key"]).then((value) {
              nearbyProvider.add(value);
              rsa.assignNearbyProviders(nearbyProvider);
              print("Added provider: " + value.name);
            });

            break;

          case Geofire.onKeyExited:
            // keysRetrieved.remove(map["key"]);
            for (var m in nearbyProvider) {
              if (m.id == map["key"]) {
                nearbyProvider.remove(m);
                rsa.assignNearbyProviders(nearbyProvider);
                print("Added provider: " + m.name.toString());
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

    // .onDone(() {print("FINISHED PROVIDERS");});
  }
}
