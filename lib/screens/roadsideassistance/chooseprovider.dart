import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/classes/models/towProvider.dart';
import 'package:slahly/abstract_classes/user.dart';
import 'package:easy_localization/easy_localization.dart';
import 'arrival.dart';

import 'package:slahly/widgets/ChooseTile.dart';

import '../../classes/provider/rsadata.dart';
import '../../main.dart';

class ChooseProviderScreen extends ConsumerWidget {
  static const routeName = "/chooseproviderscreen";
  String providerH = "";
  late StreamSubscription _myStream;
  List<TowProvider> providers = [
    TowProvider(
        nationalID: '123132',
        name: 'Ahmed tarek',
        phoneNumber: '01115612314',
        loc: CustomLocation(
            address:
                "Factorya, shar3 45 odam mtafy 12311321312312hasdhdashjss221",
            longitude: 11,
            latitude: 11),
        avatar: 'https://www.woolha.com/media/2020/03/eevee.png',
        email: 'email@yahoo.com',
        type: Type.provider),
  ];

  // _getStream(BuildContext context, ref) async {
  //   DatabaseReference ttaRef = FirebaseDatabase.instance.ref().child("tta");
  //   RSANotifier rsaNotifier = ref.watch(rsaProvider.notifier);
  //   RSA rsa = ref.watch(rsaProvider);
  //   ttaRef.child(rsa.rsaID!).onValue.listen((event) {
  //     print(rsa.rsaID);
  //     if (event.snapshot.value != null) {
  //       print("data  null");
  //       DataSnapshot dataSnapshot = event.snapshot;
  //       if (dataSnapshot.child("state").value.toString() ==
  //           RSA.stateToString(RSAStates.waitingForProviderResponse)) {
  //         dataSnapshot.child("providersResponses").children.forEach((prov) {
  //           if (prov.value == "accepted") {
  //             print("provider accepted");
  //             for (var provider in rsa.nearbyProviders!) {
  //               if (provider.id == prov.key) {
  //                 print("provider assigned");
  //                 print("provider accepted id::${provider.id}");
  //                 rsaNotifier.assignProvider(provider, false);
  //               }
  //             }
  //           } else if (prov.value == "rejected") {
  //             for (var provider in rsa.nearbyProviders!) {
  //               print(
  //                   "prev assigned tow provider${ref.watch(rsaProvider).towProvider?.name}");
  //               print("provider rejected${provider.id}");
  //               bool isSame = provider.id ==
  //                   (ref.watch(rsaProvider).towProvider != null
  //                       ? ref.watch(rsaProvider).towProvider!.id
  //                       : "sad");
  //               print(isSame);
  //               if (provider.id == prov.key && isSame) {
  //                 rsaNotifier.assignProvider(
  //                     TowProvider(name: null, email: null), false);
  //                 context.pop();
  //               }
  //             }
  //           }
  //         });
  //       }
  //     }
  //   });
  // }
  void chosenProvider(String id, ref) {
    final RSA rsa = ref.watch(rsaProvider);
    DatabaseReference tta = dbRef.child("tta");
    tta.child(rsa.rsaID!).child("providersResponses").child(id!).set("pending");
  }

  @override
  Widget build(BuildContext context, ref) {
    // _getStream(context, ref);
    getAcceptedMechanic(ref);
    final rsaNotifier = ref.watch(rsaProvider.notifier);
    final RSA rsa = ref.watch(rsaProvider);
    return Scaffold(
        backgroundColor: const Color(0xFFd1d9e6),
        appBar: AppBar(
          automaticallyImplyLeading: true,
          elevation: 0.0,
          backgroundColor: const Color(0xFF193566),
          title: Padding(
            padding: const EdgeInsets.only(right: 40),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [Text("choose_provider".tr())]),
          ),
        ),
        body: CustomPaint(
          child: Container(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: const Color(0xFFd1d9e6),
                ),
                child: Center(
                  // child: FloatingActionButton(
                  //   child: Icon(Icons.add),
                  //   onPressed: () {
                  //     showModalBottomSheet<void>(
                  //       context: context,
                  //       isScrollControlled: true,
                  //       enableDrag: true,
                  //       isDismissible: true,
                  //       builder: (BuildContext context) {
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      ListView.builder(
                        itemBuilder: (BuildContext, index) {
                          return GestureDetector(
                            onTap: () async {
                              providerH =
                                  rsa.nearbyProviders![index].id.toString();
                              print("heshaamamam" + providerH);
                              chosenProvider(
                                  rsa.nearbyProviders![index].id.toString(),
                                  ref);

                              // context.push(Arrival.routeName, extra: true);
                            },
                            child: ChooseTile(
                                email: rsa.acceptedNearbyProviders![index].email
                                    .toString(),
                                avatar: rsa
                                    .acceptedNearbyProviders![index].avatar
                                    .toString(),
                                phone: rsa
                                    .acceptedNearbyProviders![index].phoneNumber
                                    .toString(),
                                name: rsa.acceptedNearbyProviders![index].name
                                    .toString(),
                                type: Type.provider,
                                isCenter: false),
                          );
                        },
                        // itemCount: providers.length,
                        itemCount: rsa.acceptedNearbyProviders!.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(5),
                        scrollDirection: Axis.vertical,
                      ),
                    ],
                  ),
                )),
          ),
        ));
  }

  //
  // _getStream(BuildContext context, ref) async {
  //   DatabaseReference ttaRef = FirebaseDatabase.instance.ref().child("tta");
  //   RSANotifier rsaNotifier = ref.watch(rsaProvider.notifier);
  //   RSA rsa = ref.watch(rsaProvider);
  //   ttaRef.child(rsa.rsaID!).onValue.listen((event) {
  //     print(rsa.rsaID);
  //     if (event.snapshot.value != null) {
  //       print("data  null");
  //       DataSnapshot dataSnapshot = event.snapshot;
  //       if (dataSnapshot.child("state").value.toString() ==
  //           RSA.stateToString(RSAStates.waitingForProviderResponse)) {
  //         dataSnapshot.child("providersResponses").children.forEach((prov) {
  //           if (prov.value == "accepted") {
  //             print("provider accepted");
  //             for (var provider
  //                 in ref.watch(rsaProvider).newNearbyProviders!.keys) {
  //               if (provider == prov.key) {
  //                 print("provider assigned");
  //                 print("provider accepted id::${provider}");
  //                 rsaNotifier.assignProvider(
  //                     ref.watch(rsaProvider).newNearbyProviders[provider],
  //                     false);
  //               }
  //             }
  //           } else if (prov.value == "rejected") {
  //             print("rejectttttttt");
  //             for (var provider
  //                 in ref.watch(rsaProvider).newNearbyProviders!.keys) {
  //               print("prev assigned tow provider${providerH}");
  //               print("provider rejected${provider}");
  //               bool isSame = provider == providerH;
  //               print(isSame);
  //               if (provider == prov.key && isSame) {
  //                 rsaNotifier.assignProvider(
  //                     TowProvider(name: null, email: null), false);
  //                 providerH = "";
  //                 // print("dialoggg");
  //                 // customDialog(context);
  //                 // print("b3d dia");
  //                 context.pop();
  //               }
  //             }
  //           }
  //         });
  //       }
  //     }
  //   });
  // }
  getAcceptedMechanic(ref) {
    DatabaseReference ttaRef = FirebaseDatabase.instance.ref().child("tta");

    print("IN STREAM FUNCTION ::");
    RSA rsa = ref.watch(rsaProvider);
    if (rsa.rsaID == null) return [];

    _myStream = ttaRef.child(rsa.rsaID!).onValue.listen((event) {
      print("WSA LISTENER");
      print("${event.snapshot.value}");
      if (event.snapshot.value != null) {
        //TODO: add the constraints of rsa state if needed

        bool flagAllRejected = true;
        bool flagFindYet = false;

        DataSnapshot dataSnapshot = event.snapshot;

        dataSnapshot
            .child("providersResponses")
            .children
            .forEach((dataSnapShotProvider) {
          flagFindYet = true;
          print("PROV::333333333333");
          print("PROV::Stream::${dataSnapShotProvider.value}");
          if (dataSnapShotProvider.value == "pending") {
            flagAllRejected = false;
          }
          if (dataSnapShotProvider.value == "accepted") {
            flagAllRejected = false;
            print(
                "PROV::inside if accepted and ${dataSnapShotProvider.key} accepted");

            print(
                "PROV::AAAAAAAAAAAAAAAAAAAAA${ref.watch(rsaProvider).newNearbyProviders}");
            for (var towProvider
                in ref.watch(rsaProvider).newNearbyProviders!.keys) {
              print(
                  "${towProvider} ====== ${dataSnapShotProvider.key}-> ${dataSnapShotProvider.key == towProvider}");
              print("PROV::do I already have him?");
              if (dataSnapShotProvider.key == towProvider) {
                print(
                    "PROV::YESSSSSSSSSSSSS->${ref.watch(rsaProvider).newNearbyProviders![towProvider]!.name}");
                ref.watch(rsaProvider.notifier).addAcceptedNearbyProvider(
                    ref.watch(rsaProvider).newNearbyProviders![towProvider]!);
                // print(ref.watch(rsaProvider).);
              }
            }
          }
        });
        if (flagAllRejected && flagFindYet) {
          //TODO: Show a dialog box (ALL rejected Please request later)
          // allRejected(context, "Providers");
          print("All providers rejected");
        }
      }
    });
  }

  void customDialog(context) {
    print("nice");
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              title: Row(
                children: [
                  Text("Alert"),
                  SizedBox(width: MediaQuery.of(context).size.height * 0.1),
                  IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              ),
              content: Text("Provider busy"),
            ));
    print("nsssss");
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = const Color(0xFF193566);
    Path path = Path()
      ..relativeLineTo(0, 90)
      ..quadraticBezierTo(size.width / 2, 150, size.width, 90)
      ..relativeLineTo(0, -90)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
