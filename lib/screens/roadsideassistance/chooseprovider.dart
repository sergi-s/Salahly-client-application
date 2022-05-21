import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:slahly/abstract_classes/user.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/classes/provider/rsadata.dart';
import 'package:slahly/widgets/ChooseTile.dart';
import 'package:slahly/widgets/dialogues/all_rejected.dart';
import 'package:slahly/widgets/dialogues/none_found.dart';
import 'package:slahly/widgets/location/finalScreen.dart';

import '../../widgets/dialogues/confirm_cancellation.dart';

class ChooseProviderScreen extends ConsumerStatefulWidget {
  static const String routeName = "/chooseproviderscreen";

  ChooseProviderScreen({Key? key}) : super(key: key);

  @override
  _ChooseProviderScreenState createState() => _ChooseProviderScreenState();
}

class _ChooseProviderScreenState extends ConsumerState<ChooseProviderScreen> {
  String providerH = "";

  late StreamSubscription _myStream;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      check();
      getAcceptedTowProviders();
      activate3Min();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: (ref.watch(rsaProvider).towProvider != null)
            ? nextPageButton()
            : cancelButton(),
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
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                color: Color(0xFFd1d9e6),
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
                    const SizedBox(height: 10),
                    ListView.builder(
                      itemBuilder: (BuildContext context, index) {
                        return GestureDetector(
                          onTap: () async {
                            print("ACCEPTED PROVIDER");
                            if (ref.watch(rsaProvider).towProvider != null)
                              return;
                            ref.watch(rsaProvider.notifier).assignProvider(
                                ref
                                    .watch(rsaProvider)
                                    .acceptedNearbyProviders![index],
                                false);

                            context.push(RequestFinalScreen.routeName,
                                extra: true);
                          },
                          child: ChooseTile(
                            email: ref
                                .watch(rsaProvider)
                                .acceptedNearbyProviders![index]
                                .email
                                .toString(),
                            avatar: ref
                                .watch(rsaProvider)
                                .acceptedNearbyProviders![index]
                                .avatar
                                .toString(),
                            phone: ref
                                .watch(rsaProvider)
                                .acceptedNearbyProviders![index]
                                .phoneNumber
                                .toString(),
                            name: ref
                                .watch(rsaProvider)
                                .acceptedNearbyProviders![index]
                                .name
                                .toString(),
                            type: Type.provider,
                            isCenter: false,
                            estimatedTime: ref
                                .watch(rsaProvider)
                                .acceptedNearbyProviders![index]
                                .estimatedTime
                                .toString(),
                          ),
                        );
                      },
                      // itemCount: providers.length,
                      itemCount: ref
                          .watch(rsaProvider)
                          .acceptedNearbyProviders!
                          .length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(5),
                      scrollDirection: Axis.vertical,
                    ),
                  ],
                ),
              )),
        ));
  }

  bool checkOnce = false;

  void check() {
    if (checkOnce) return;
    checkOnce = true;
    print(">>Checking");
    // Future.delayed(Duration.zero, () async {
    if (ref.watch(rsaProvider).towProvider != null) {
      print(">>>>prov");
      // context.push(Arrival.routeName, extra: true);
      context.push(RequestFinalScreen.routeName);
      print("after push");
      // await _myStream.cancel();
    }
    // });
  }

  Widget cancelButton() {
    return ElevatedButton(
      onPressed: () => confirmCancellation(context, ref),
      child: const Icon(
        Icons.cancel_outlined,
      ),
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        primary: const Color(0xFF193566),
        padding: const EdgeInsets.all(10),
      ),
    );
  }

  Widget nextPageButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        primary: const Color(0xFF193566),
        padding: const EdgeInsets.all(10),
      ),
      onPressed: () {
        print("SADSAADASD");
        // context.push(RequestFinalScreen.routeName);
        // context.push(Profile.routeName);
        context.push(RequestFinalScreen.routeName);
      },
      child: const Icon(
        Icons.navigate_next_outlined,
      ),
    );
  }

  getAcceptedTowProviders() {
    DatabaseReference ttaRef = FirebaseDatabase.instance.ref().child("tta");

    print("IN STREAM FUNCTION ::");
    RSA rsa = ref.watch(rsaProvider);
    if (rsa.rsaID == null) return [];

    _myStream = ttaRef.child(rsa.rsaID!).onValue.listen((event) {
      print("TTA LISTENER");
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
          ref.watch(rsaProvider.notifier).atLeastOneProvider = true;
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
            // for (var towProvider
            //     in ref.watch(rsaProvider).newNearbyProviders!.keys) {
            //   print(
            //       "${towProvider} ====== ${dataSnapShotProvider.key}-> ${dataSnapShotProvider.key == towProvider}");
            //   print("PROV::do I already have him?");
            //   if (dataSnapShotProvider.key == towProvider) {
            //     print(
            //         "PROV::YESSSSSSSSSSSSS->${ref.watch(rsaProvider).newNearbyProviders![towProvider]!.name}");
            //     ref
            //         .watch(rsaProvider.notifier)
            //         .addAcceptedNearbyProvider(towProvider);
            //     // print(ref.watch(rsaProvider).);
            //   }
            // }
            ref
                .watch(rsaProvider.notifier)
                .addAcceptedNearbyProvider(dataSnapShotProvider.key.toString());
          }
          if (dataSnapShotProvider.value == "chosen") {}
        });
        if (flagAllRejected && flagFindYet) {
          allRejected(context, ref, "Providers");
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
                  const Text("Alert"),
                  SizedBox(width: MediaQuery.of(context).size.height * 0.1),
                  IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              ),
              content: const Text("Provider busy"),
            ));
  }

  void activate3Min() async {
    print("RSA: abl el 3 minutes");
    bool foundAny = await ref
        .watch(rsaProvider.notifier)
        .atLeastOne(needMechanic: false, needProvider: true);

    if (!foundAny) {
      !ref.watch(rsaProvider.notifier).atLeastOneProvider
          ? noneFound(context, who: false)
          : null;
    }

    print("RSA: after second 3 minutes");
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
