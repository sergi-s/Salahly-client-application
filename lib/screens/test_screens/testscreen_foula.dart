import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localstore/localstore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slahly/classes/firebase/nearbylocations.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/classes/models/mechanic.dart';
import 'package:slahly/classes/models/towProvider.dart';
import 'package:slahly/classes/provider/app_data.dart';
import 'package:slahly/classes/provider/rsadata.dart';
import 'package:slahly/main.dart';
import 'package:slahly/screens/roadsideassistance/rsaconfirmationScreen.dart';
import 'package:slahly/screens/roadsideassistance/searching_mechanic_provider_screen.dart';

import '../login_signup/signupscreen.dart';

final valueProvider = Provider<int>((ref) {
  return 364;
});

final counterStateProvider = StateProvider<int>((ref) {
  return 0;
});

class TestScreen_ extends ConsumerWidget {
  static final routeName = "/testscreen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(),
      ),
    );
  }
}

class TestScreen_nearbymechanics_and_create_rsa extends ConsumerWidget {
  static final routeName = "/testscreen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          ElevatedButton(
              onPressed: () async {
                final _db = Localstore.instance;
                final id = Localstore.instance.collection('test').doc().id;
                final now = DateTime.now();
                _db
                    .collection('test')
                    .doc(id)
                    .set({'title': 'Todo t_itle', 'done': false});
                final data = await _db.collection('test').get();
                print(data);
              },
              child: const Text("test DB localStore")),
          ElevatedButton(
              onPressed: () async {
                ref.watch(salahlyClientProvider.notifier).getSavedData();
                final prefs = await SharedPreferences.getInstance();

                print("${ref.watch(salahlyClientProvider).requestType}\n"
                    "${ref.watch(salahlyClientProvider).requestID}\n"
                    "${ref.watch(salahlyClientProvider).appState}\n"
                    "provider: ${prefs.getString("towProvider")}\n"
                    "mechanic: ${prefs.getString("mechanic")}");

                print("sad");
              },
              child: const Text("See App state")),
          ElevatedButton(
            onPressed: () {
              ref.watch(rsaProvider.notifier).cancelRequest();
              ref.watch(salahlyClientProvider.notifier).deAssignRequest();
            },
            child: Text("cancel request"),
          ),
          ElevatedButton(
              onPressed: () {
                ref.watch(rsaProvider.notifier).cancelRequest();
                ref.watch(salahlyClientProvider.notifier).deAssignRequest();
              },
              child: const Text("Clear RSA")),
          ElevatedButton(
            onPressed: () async {
              FirebaseAuth.instance.signOut();
              context.go(LoginSignupScreen.routeName);
            },
            child: Text("SignOut"),
          ),
          ElevatedButton(
              onPressed: () async {
                //
                // FirebaseAuth.instance.signOut();
                //
                // FirebaseMessaging.onMessage.listen((RemoteMessage event) {
                //   print("message recieved");
                //   print(event.notification!.body);
                //   showSimpleNotification(
                //       Text("Received a notification, rsaID: " +
                //           event.notification!.body.toString()),
                //       background: Colors.green);
                // });
                // FirebaseMessaging.onMessageOpenedApp.listen((message) {
                //   print('Message clicked!');
                // });

                ref.watch(rsaProvider.notifier).assignUserLocation(
                    CustomLocation(latitude: 31.206972, longitude: 29.919028));
              },
              child: Text("Set location")),
          ElevatedButton(
            onPressed: () async {
              ref
                  .watch(rsaProvider.notifier)
                  .searchNearbyMechanicsAndProviders();
            },
            child: Text("Get mechanics and providers"),
          ),
          ElevatedButton(
              onPressed: () async {
                await NearbyLocations.stopListener();
                // await NearbyLocations.realSTOP();
                print("Listener stopped el mafrod");
                // ref.watch(rsaProvider.notifier).assignState(RSAStates.canceled);
              },
              child: Text("stop listener")),
          ElevatedButton(
            onPressed: () async {
              print("oba");
              if (await ref.watch(rsaProvider.notifier).requestRSA()) {
                String rsa = ref.watch(rsaProvider).rsaID!;
                print("Yaaaay got id " + rsa);
                await _getRsaDataStream(ref);
                print("back too onPress");
              } else {
                print("NOOOO DIDNT WORK");
              }
            },
            child: Text("Request RSA AND Open Stream"),
          ),
          ElevatedButton(
            onPressed: () async {
              RSANotifier rsaNotifier = ref.watch(rsaProvider.notifier);
              RSA rsa = ref.watch(rsaProvider);
              RSAStates toggle;
              if (rsa.state == RSAStates.waitingForProviderResponse) {
                toggle = RSAStates.waitingForMechanicResponse;
              } else {
                toggle = RSAStates.waitingForProviderResponse;
              }
              rsaNotifier.assignState(toggle);

              DatabaseReference rsaRef =
                  FirebaseDatabase.instance.ref().child("rsa");
              print(rsa.rsaID!);
              rsaRef
                  .child(rsa.rsaID!)
                  .update({"state": RSA.stateToString(toggle)}).then((value) {
                rsaRef
                    .child(rsa.rsaID!)
                    .get()
                    .then((value) => print("toggle B:${value.value}"));
              }).catchError((onError) {
                print("error");
              });
            },
            child: Text("TOGGOLE RSA State"),
          ),
          ElevatedButton(
            onPressed: () async {
              context.push(SearchingMechanicProviderScreen.routeName);
            },
            child: Text("Searching Screen"),
          ),
        ],
      )),
    );
  }

  _getRsaDataStream(ref) async {
    DatabaseReference rsaRef = FirebaseDatabase.instance.ref().child("rsa");
    RSANotifier rsaNotifier = ref.watch(rsaProvider.notifier);
    RSA rsa = ref.watch(rsaProvider);

    // await rsaNotifier.requestRSA();

    rsaRef.child(rsa.rsaID!).onValue.listen((event) {
      print("LISTENER");
      print("${event.snapshot.value}");
      if (event.snapshot.value != null) {
        print("data not null");
        DataSnapshot dataSnapshot = event.snapshot;

        print(dataSnapshot.child("state").value.toString() ==
                RSA.stateToString(RSAStates.waitingForMechanicResponse)
            ? "Mech will activate"
            : "Prov will activate");

        if (dataSnapshot.child("state").value.toString() ==
            RSA.stateToString(RSAStates.waitingForMechanicResponse)) {
          print("waiting for Mech is activated");

          dataSnapshot.child("mechanicsResponses").children.forEach((mechanic) {
            print("MECH $mechanic:\t ${mechanic.value} ${mechanic.key}");
            if (mechanic.value == "accepted") {
              print("Someone is accepted");
              for (var mech in rsa.nearbyMechanics!) {
                print("l2it 7ad");
                if (mech.id == mechanic.key) {
                  print("this is the mechanic${mechanic.key}");
                  rsaNotifier.assignMechanic(mech, false);
                  print(rsa.mechanic!.name.toString());
                  print("mech got assigned");
                }
                print("end of mech loop");
              }
            }
          });
        }

        if (dataSnapshot.child("state").value.toString() ==
            RSA.stateToString(RSAStates.waitingForProviderResponse)) {
          print("waiting for prov is activated");

          dataSnapshot.child("providersResponses").children.forEach((prov) {
            print("PROV $prov:\t ${prov.value} ${prov.key}");
            if (prov.value == "accepted") {
              print("Someone is accepted");
              for (var provider in rsa.nearbyProviders!) {
                print("l2it 7ad");
                if (provider.id == prov.key) {
                  print("this is the provider${prov.key}");
                  rsaNotifier.assignProvider(provider, false);
                  print("prov got assigned");
                }
                print("end of prov loop");
              }
            }
          });

          // for (var provkey in currentProvs.keys) {
          //   print(currentProvs[provkey]);
          //   if (currentProvs[provkey] == "accepted") {
          //     print("Someone is accepted");
          //     for (var prov in rsa.nearbyProviders!) {
          //       print("l2it 7ad");
          //       if (prov.id == provkey) {
          //         print("this is the provider${provkey}");
          //         rsaNotifier.assignProvider(prov, false);
          //         print("prov got assigned");
          //       }
          //       print("end of prov loop");
          //     }
          //     print("end of 7atot");
          //
          //     rsaNotifier.assignState(RSAStates.providerConfirmed);
          //     print("prov got stated changed");
          //   }
          // }
        }
      }

      print(rsa.mechanic.toString());
    });

    return Center();
  }
}

class TestScreenSM_nearbymechanics extends ConsumerWidget {
  static final routeName = "/testscreen";
  late List<Mechanic> mechanics;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    RSA rsa = ref.watch(rsaProvider);
    RSANotifier notifier = ref.watch(rsaProvider.notifier);

    List<Mechanic> mechanics = rsa.nearbyMechanics ?? []; // GETTER
    // ref.listen(rsaProvider, (previous,RSA next) {
    //   print("a7eeeh");
    //   // print(next.nearbyMechanics.toString());
    //   print("a7eeeh");
    //  // rsa =  ref.refresh(rsaProvider.notifier);
    //   // mechanics = rsa.getNearbyMechanics();
    // });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        title: Center(
          child: Text("Choose mechanic",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black)),
        ),
        // title: Image.asset(
        //   'assets/images/logo1.png',
        //   alignment: Alignment.center,
        //   height: 200,
        //   width: 200,
        // ),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  notifier.assignUserLocation(CustomLocation(
                      latitude: 31.206972, longitude: 29.919028));
                  // rsa.searchNearbyMechanicsSecond(ref); not working
                  // notifier.searchNearbyMechanics(); REMOVED DUE TO UPDATE BUT IT SHOULD BE WORKING
                  // notifier.searchNearbyMechanicsThird(ref.read(rsaProvider.notifier).assignNearbyMechanics); working
                },
                child: Text("Search nearby mechanics")),
            // Container(
            //     decoration: BoxDecoration(
            //   image: DecorationImage(
            //       image: AssetImage('assets/images/logo ta5arog 2.png'),
            //       alignment: Alignment.topCenter),
            // )),
            SizedBox(height: 40),
            // Text(
            //   "Choose mechanic",
            //   style: TextStyle(
            //     fontWeight: FontWeight.bold,
            //     fontSize: 24,
            //   ),
            // ),
            SizedBox(height: 10),
            ListView.builder(
              itemBuilder: (BuildContext, index) {
                return MechanicTile(
                    mechanics[index].email.toString(),
                    mechanics[index].avatar.toString(),
                    mechanics[index].phoneNumber.toString(),
                    mechanics[index].name.toString(),
                    mechanics[index].isCenter!);
              },
              itemCount: mechanics.length,
              shrinkWrap: true,
              padding: EdgeInsets.all(5),
              scrollDirection: Axis.vertical,
            ),
          ],
        ),
      ),
    );
  }
}

class MechanicTile extends StatelessWidget {
  String email;
  String avatar;
  String phone;
  String name;
  bool isCenter;

  MechanicTile(this.email, this.avatar, this.phone, this.name, this.isCenter);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      child: Card(
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(15.0),
        // ),
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(
                  avatar,
                ),
                radius: 25,
              ),
              title: Text(
                name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              subtitle: Container(
                child: Column(children: [
                  Row(
                    children: [
                      Text(
                        phone,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Icon(
                        (isCenter) ? Icons.favorite : null,
                        color: Colors.pink,
                        size: 24.0,
                        semanticLabel:
                            'Text to announce in accessibility modes',
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        // padding: const EdgeInsets.symmetric(
                        //     horizontal: 83.0),
                        child: Text(
                          'Rating : 4.8',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),

                      // mechanics[index].isCenter? : null ,
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 100.0,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text('Confirm'),
                          style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(), primary: Colors.blueGrey),
                        ),
                      )
                    ],
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TestScreenFBNotification extends ConsumerWidget {
  TestScreenFBNotification({Key? key}) : super(key: key);
  static final routeName = "/testscreen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    FirebaseMessaging.instance.getToken().then((value) => print(value));
    // print("TOKEN IS: $token");
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);

      // showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return AlertDialog(
      //         title: Text("Notification"),
      //         content: Text(event.notification!.body!),
      //         actions: [
      //           TextButton(
      //             child: Text("Ok"),
      //             onPressed: () {
      //               Navigator.of(context).pop();
      //             },
      //           )
      //         ],
      //       );
      //     });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });

    StreamSubscription<DatabaseEvent> rsaListener = dbRef
        .child("rsa")
        .child("-MyUNThvOQvuoy6HeOy-")
        .onChildChanged
        .listen((event) {
      print("USER ID CHANGED, NOW IT IS: " +
          event.snapshot.child("userID").value.toString());
    });

    // final value = ref.watch(valueProvider);
    final rsa = ref.read(rsaProvider.notifier);
    return Scaffold(
      // floatingActionButton: FloatingActionButton(onPressed: (){
      //
      // },),
      // body: Center(child: Text("Value: $value")),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                rsa.assignMechanic(
                    Mechanic(
                      name: "Mechanic",
                      email: "Mecha@mech.m",
                      rating: 3.4,
                      isCenter: false,
                    ),
                    false);
                rsa.assignProvider(
                    TowProvider(
                      name: "Mechanic",
                      email: "Mecha@mech.m",
                      rating: 3.4,
                      isCenter: false,
                    ),
                    false);
              },
              child: Text("Assign data")),
          ElevatedButton(
              onPressed: () {
                context.go(RSAConfirmationScreen.routeName);
              },
              child: Text("go to confirmation screen ")),
        ],
      ),
    );
  }
}

class TestScreenWithoutConsumer extends StatelessWidget {
  const TestScreenWithoutConsumer({Key? key}) : super(key: key);
  static final routeName = "/testscreenwoconsumer";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer(
          builder: (_, ref, __) {
            final value = ref.watch(valueProvider);
            return Text("Value: $value");
          },
        ),
      ),
    );
  }
}
