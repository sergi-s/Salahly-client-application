import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slahly/utils/firebase/get_mechanic_data.dart';
import 'package:slahly/utils/firebase/get_provider_data.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:slahly/classes/provider/app_data.dart';
import 'package:slahly/classes/provider/rsadata.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';

import 'package:slahly/screens/roadsideassistance/arrival.dart';
import "package:slahly/widgets/dropOff/TextFieldOnMap.dart";
import 'package:slahly/widgets/WSA/choose_sliders.dart';
import 'package:slahly/widgets/roadsideassistance/services_provider_card.dart';
import 'package:slahly/widgets/location/mapWidget.dart';
import 'package:slahly/widgets/dialogues/request_confirmation_dialogue.dart';
import 'package:slahly/widgets/dialogues/all_rejected.dart';
import 'package:slahly/widgets/dialogues/none_found.dart';
import 'package:slahly/widgets/dialogues/confirm_cancellation.dart';
import 'package:slahly/utils/constants.dart';

class WSAScreen extends ConsumerStatefulWidget {
  static const String routeName = "/WSAScreen";

  const WSAScreen({Key? key}) : super(key: key);

  @override
  _WSAScreenState createState() => _WSAScreenState();
}

class _WSAScreenState extends ConsumerState<WSAScreen> {
  GlobalKey<MapWidgetState> myMapWidgetState = GlobalKey();

  bool needProvider = false, needMechanic = true;
  bool gotMechanics = false;
  bool didRequest = false;

  late StreamSubscription _myStream;

  final PanelController _pcMechanic = PanelController();

  final PanelController _pcTowProvider = PanelController();

  final PanelController _pcSlider = PanelController();

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      ref.watch(salahlyClientProvider.notifier).getSavedData();
      final prefs = await SharedPreferences.getInstance();
      print("YARAB ${prefs.getBool("needProvider")}");
      print("didRequest${didRequest}");
      if (prefs.getBool("needProvider") ?? false) {
        setState(() {
          needProvider = true;
        });
      }

      if (ref.watch(salahlyClientProvider).requestType == RequestType.WSA) {
        // ref.watch(rsaProvider.notifier).searchNearbyMechanicsAndProviders();
        ref.watch(rsaProvider.notifier).assignRequestID(
            ref.watch(salahlyClientProvider).requestID.toString());
        print("there is a onging request");
        print("HELLO::${ref.watch(rsaProvider).rsaID}");
        setState(() {
          didRequest = true;

          if (ref.watch(rsaProvider).mechanic != null) {
            gotMechanics = true;
          }
        });
        if (prefs.getString("mechanic") != null) {
          ref.watch(rsaProvider.notifier).assignMechanic(
              await getMechanicData(prefs.getString("mechanic")!), false);
        }
        if (prefs.getString("towProvider") != null) {
          ref.watch(rsaProvider.notifier).assignProvider(
              await getProviderData(prefs.getString("towProvider")!), false);
        }

        if (didRequest) _pcSlider.open();
        getAcceptedMechanic();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // check();
    return Scaffold(
      body: Stack(
        children: [
          MapWidget(key: myMapWidgetState),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.43,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        blurRadius: 16,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7))
                  ]),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Text(("hi_there".tr()),
                        style: const TextStyle(fontSize: 12)),
                    Text(("where_to".tr()),
                        style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 20),
                    GestureDetector(
                      child: TextFieldOnMap(
                        isSelected: (!didRequest && needProvider),
                        textToDisplay: (needProvider
                            ? "your_current_location".tr()
                            : "goOnYourOwn".tr()),
                        iconToDisplay: Icon(
                          needProvider ? Icons.my_location : Icons.car_repair,
                          color: const Color(0xFF193566),
                        ),
                      ),
                      onTap: () {
                        myMapWidgetState.currentState?.locatePosition();
                      },
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      child: getMechanicWidget(),
                      onTap: () async {
                        if (ref.watch(rsaProvider).mechanic == null &&
                            didRequest) {
                          _pcMechanic.open();
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                        child: getProviderWidget(),
                        onTap: () {
                          print("The bool value::$needProvider");
                          if (!needProvider) return;
                          if (ref.watch(rsaProvider).towProvider == null) {
                            _pcTowProvider.open();
                          }
                        }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        didRequest
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: const Color(0xFF193566),
                                ),
                                child: const Text("Cancel").tr(),
                                onPressed: () {
                                  confirmCancellation(context, ref);
                                },
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: const Color(0xFF193566),
                                ),
                                child: const Text("confirm").tr(),
                                onPressed: () {
                                  if (ref
                                          .watch(salahlyClientProvider)
                                          .requestType !=
                                      null) {
                                    if (ref
                                            .watch(salahlyClientProvider)
                                            .requestType ==
                                        RequestType.WSA) {
                                      // _pcMechanic.open();
                                      _pcSlider.open();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            "There is another ongoing request"),
                                      ));
                                    }
                                    return;
                                  }
                                  requestConfirmationDialogue(context,
                                      titleChildren: [
                                        const Text("confirm").tr()
                                      ],
                                      content: Text("wsaConfirmation".tr() +
                                          "\n" +
                                          (needProvider
                                              ? ("withTowTruck".tr() +
                                                  "at".tr() +
                                                  " " +
                                                  myMapWidgetState
                                                      .currentState!
                                                      .currentCustomLoc
                                                      .address!)
                                              : "withNoTowTruck".tr())),
                                      actionChildren: [
                                        ElevatedButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          style: ElevatedButton.styleFrom(
                                            primary: const Color(0xFF193566),
                                          ),
                                          child: Text("Cancel".tr()),
                                        ),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: const Color(0xFF193566),
                                            ),
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              setState(() {
                                                didRequest = true;
                                              });
                                              await requestWSA();
                                              print(
                                                  "2=>WE FOUND ${ref.watch(rsaProvider).newNearbyProviders!.keys.length} Provider");
                                              print(
                                                  "2=>WE FOUND ${ref.watch(rsaProvider).newNearbyMechanics!.keys.length} Mechanics");
                                            },
                                            child: const Text("confirm").tr()),
                                      ]);
                                }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.85,
            right: 0,
            bottom: MediaQuery.of(context).size.height * 0.35,
            child: ElevatedButton(
              onPressed: () => myMapWidgetState.currentState?.locatePosition(),
              child: const Icon(
                Icons.location_on,
              ),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                primary: const Color(0xFF193566),
                padding: const EdgeInsets.all(10),
              ),
            ),
          ),
          ChooseMechanicSlider(
              pc: _pcMechanic,
              mechanics: ref.watch(rsaProvider).acceptedNearbyMechanics ?? []
              // pc: _pc, mechanics: mechanics,//static data for testing
              ),
          ChooseTowProviderSlider(
              pc: _pcTowProvider,
              towProviders: ref.watch(rsaProvider).acceptedNearbyProviders ?? []
              // pc: _pc, mechanics: mechanics,//static data for testing
              ),
          WSASlider(
            needTowProvider: needProvider,
            needMechanic: needMechanic,
            pc: _pcSlider,
          )
        ],
      ),
    );
  }

  //wait 3 minute
  void activate3Min() async {
    print("RSA: abl el 3 minutes");
    bool foundAny = await ref
        .watch(rsaProvider.notifier)
        .atLeastOne(needMechanic: true, needProvider: needProvider);

    if (!foundAny && ref.watch(rsaProvider).state != RSAStates.canceled) {
      !ref.watch(rsaProvider.notifier).atLeastOneProvider
          ? noneFound(context, who: false)
          : null;
      !ref.watch(rsaProvider.notifier).atLeastOneMechanic
          ? noneFound(context, who: true)
          : null;
    }
  }

  //request work shop assistance
  requestWSA() async {
    print("Requesting WSA::");
    RSANotifier rsaNotifier = ref.watch(rsaProvider.notifier);
    rsaNotifier.assignRequestTypeToWSA();
    rsaNotifier
        .assignUserLocation(myMapWidgetState.currentState!.currentCustomLoc);

    if (!gotMechanics) {
      await rsaNotifier.requestWSA();
      gotMechanics = true;
      await rsaNotifier.searchNearbyMechanicsAndProviders();
    }
    // _pcMechanic.open();
    _pcSlider.open();
    //salahlyClientProvider
    ref.watch(salahlyClientProvider.notifier).assignRequest(
        ref.watch(rsaProvider).requestType!, ref.watch(rsaProvider).rsaID!);
    getAcceptedMechanic();
    activate3Min();
  }

  getAcceptedMechanic() {
    print("IN STREAM FUNCTION ::");
    if (ref.watch(rsaProvider).rsaID == null) return [];
    print("WSA ID is ${ref.watch(rsaProvider).rsaID}");
    _myStream =
        wsaRef.child(ref.watch(rsaProvider).rsaID!).onValue.listen((event) {
      print("WSA LISTENER");
      print("${event.snapshot.value}");
      if (event.snapshot.value != null) {
        //TODO: add the constraints of rsa state if needed

        bool flagAllRejected = true;
        bool flagFindYet = false;

        DataSnapshot dataSnapshot = event.snapshot;
        dataSnapshot
            .child("mechanicsResponses")
            .children
            .forEach((dataSnapShotMechanic) {
          ref.watch(rsaProvider.notifier).atLeastOneMechanic = true;
          flagFindYet = true;
          if (dataSnapShotMechanic.value == "chosen") {
            flagAllRejected = false;
          }
          if (dataSnapShotMechanic.value == "pending") {
            flagAllRejected = false;
          }
          print("Stream::${dataSnapShotMechanic.value}");
          if (dataSnapShotMechanic.value == "accepted") {
            flagAllRejected = false;
            print(
                "inside if accepted and ${dataSnapShotMechanic.key} accepted");

            print(
                "AAAAAAAAAAAAAAAAAAAAA${ref.watch(rsaProvider).newNearbyMechanics}");
            // for (var mech in ref.watch(rsaProvider).newNearbyMechanics!.keys) {
            //   print(
            //       "${mech} ====== ${dataSnapShotMechanic.key}-> ${dataSnapShotMechanic.key == mech}");
            //   print("do I already have him?");
            //   if (dataSnapShotMechanic.key == mech) {
            //     print(
            //         "YESSSSSSSSSSSSS->${ref.watch(rsaProvider).newNearbyMechanics![mech]!.name}");
            //     ref.watch(rsaProvider.notifier).addAcceptedNearbyMechanic(mech);
            //     // print(ref.watch(rsaProvider).);
            //   }
            // }
            ref
                .watch(rsaProvider.notifier)
                .addAcceptedNearbyMechanic(dataSnapShotMechanic.key.toString());
          }
          if (dataSnapShotMechanic.value == "rejected") {
            if (ref.watch(rsaProvider).mechanic != null) {
              if (dataSnapShotMechanic.key ==
                  ref.watch(rsaProvider).mechanic!.id) {
                print("No--------------------------------");
                print("The assigned mechanic just rejected the request");
              }
            }
          }
          if (dataSnapShotMechanic.value == "chosen") {
            if (!needProvider) {
              _myStream.cancel();
            }
          }
        });

        if (flagAllRejected && flagFindYet) {
          allRejected(context, ref, "Mechanics");
        }

        flagAllRejected = true;
        flagFindYet = false;

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
          if (dataSnapShotProvider.value == "chosen") {
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
        });
        if (flagAllRejected && flagFindYet) {
          //TODO: Show a dialog box (ALL rejected Please request later)
          allRejected(context, ref, "Providers");
          print("All providers rejected");
        }
      }
    });
  }

// Get assigned Provider
  Widget getProviderWidget() {
    return (ref.watch(rsaProvider).towProvider != null
        ? mapTowProviderToWidget(ref.watch(rsaProvider).towProvider!)
        // ? Container(child: Text("Mech exits"))
        : TextFieldOnMap(
            textToDisplay:
                didRequest ? "choose_provider".tr() : "needTowTruck".tr(),
            imageIconToDisplay: const ImageIcon(
                AssetImage('assets/images/tow-truck 2.png'),
                color: Color(0xFF193566)),
            isSelected: didRequest ? needProvider : false,
            child: didRequest
                ? null
                : Switch(
                    value: needProvider,
                    onChanged: (value) async {
                      setState(() {
                        needProvider = !needProvider;
                      });

                      final prefs = await SharedPreferences.getInstance();
                      prefs.setBool("needProvider", needProvider);
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
          ));
  }

//Get assigned mechanic
  Widget getMechanicWidget() {
    return (ref.watch(rsaProvider).mechanic != null
        ? mapMechanicToWidget(ref.watch(rsaProvider).mechanic!)
        // ? Container(child: Text("Mech exits"))
        : TextFieldOnMap(
            isSelected: didRequest,
            textToDisplay: ("choose_mech").tr(),
            iconToDisplay: const Icon(
              Icons.search,
              color: Color(0xFF193566),
            ),
          ));
  }
}
