import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/classes/models/mechanic.dart';
import 'package:slahly/classes/models/towProvider.dart';
import 'package:slahly/classes/provider/rsadata.dart';
import 'package:go_router/go_router.dart';
import 'package:slahly/screens/roadsideassistance/rsaconfirmationScreen.dart';


final valueProvider = Provider<int>((ref) {
  return 364;
});

final counterStateProvider = StateProvider<int>((ref) {
  return 0;
});

class TestScreenSM_nearbymechanics extends ConsumerWidget {
  static final routeName = "/testscreen";
  late List<Mechanic> mechanics;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    RSA rsa = ref.watch(rsaProvider);
    RSANotifier notifier = ref.watch(rsaProvider.notifier);

    List<Mechanic> mechanics = rsa.nearbyMechanics?? []; // GETTER
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
          child: Text(
              "Choose mechanic",
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
                  notifier.assignUserLocation(CustomLocation(latitude: 31.206972, longitude: 29.919028));
                  // rsa.searchNearbyMechanicsSecond(ref); not working
                  notifier.searchNearbyMechanics();
                  // notifier.searchNearbyMechanicsThird(ref.read(rsaProvider.notifier).assignNearbyMechanics); working
                }, child: Text("Search nearby mechanics")),
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

class TestScreenRSASMTest extends ConsumerWidget {
  TestScreenRSASMTest({Key? key}) : super(key: key);
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
