import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:slahly/classes/provider/app_data.dart';
import 'package:slahly/classes/provider/rsadata.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/screens/userMangament/select.dart';
import "package:slahly/widgets/dropOff/TextFieldOnMap.dart";
import 'package:slahly/widgets/WSA/choose_sliders.dart';
import 'package:slahly/widgets/roadsideassistance/services_provider_card.dart';
import 'package:slahly/widgets/location/mapWidget.dart';
import 'package:slahly/widgets/dialogues/request_confirmation_dialogue.dart';
import 'package:slahly/widgets/dialogues/all_rejected.dart';
import 'package:slahly/utils/constants.dart';
import 'package:slahly/widgets/dialogues/none_found.dart';

class WSAScreen extends ConsumerStatefulWidget {
  static const String routeName = "/WSAScreen";

  const WSAScreen({Key? key}) : super(key: key);

  @override
  _WSAScreenState createState() => _WSAScreenState();
}

class _WSAScreenState extends ConsumerState<WSAScreen> {
  GlobalKey<MapWidgetState> myMapWidgetState = GlobalKey();

  bool needProvider = false, needMechanic = false;
  bool gotMechanics = false;
  bool didRequest = false;

  late StreamSubscription _myStream;

  final PanelController _pcMechanic = PanelController();

  final PanelController _pcTowProvider = PanelController();

  @override
  Widget build(BuildContext context) {
    check();
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
                        isSelected: !didRequest,
                        textToDisplay: ("your_current_location".tr()),
                        iconToDisplay: const Icon(
                          Icons.my_location,
                          color: Colors.blue,
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
                    Align(
                      alignment: Alignment.center,
                      child: didRequest
                          ? null
                          : ElevatedButton(
                              child: const Text("confirm").tr(),
                              onPressed: () {
                                if (ref.watch(salahlyClientProvider).requestType != RequestType.NONE) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text("There is another onging request"),
                                  ));
                                  return ;
                                }
                                requestConfirmationDialogue(context,
                                    titleChildren: [const Text("confirm").tr()],
                                    content: Text("wsaConfirmation".tr() +
                                        "\n" +
                                        (needProvider
                                            ? ("withTowTruck".tr() +
                                                "at".tr() +
                                                " " +
                                                myMapWidgetState.currentState!
                                                    .currentCustomLoc.address!)
                                            : "withNoTowTruck".tr())),
                                    actionChildren: [
                                      ElevatedButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("Cancel".tr()),
                                      ),
                                      ElevatedButton(
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
        ],
      ),
    );
  }

  //wait 3 minute
  void activate3Min() async {
    print("WSA: abl el 3 minutes");
    bool tempProviders =
        await ref.watch(rsaProvider.notifier).atLeastOne(false);
    if (!tempProviders && !ref.watch(rsaProvider.notifier).atLeastOneProvider) {
      noneFound(context, who: false);
    }

    print("WSA after first 3 minutes");
    bool tempMechanic = await ref.watch(rsaProvider.notifier).atLeastOne(true);
    if (!tempMechanic && !ref.watch(rsaProvider.notifier).atLeastOneMechanic) {
      noneFound(context, who: true);
    }

    print("after second 3 minutes");
  }

  //request work shop assistance
  requestWSA() async {
    needMechanic = true;
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
    _pcMechanic.open();
    //salahlyClientProvider
    ref.watch(salahlyClientProvider.notifier).assignRequest(
        ref.watch(rsaProvider).requestType!, ref.watch(rsaProvider).rsaID!);
    getAcceptedMechanic();
    activate3Min();
  }

  getAcceptedMechanic() {
    print("IN STREAM FUNCTION ::");
    RSA rsa = ref.watch(rsaProvider);
    if (rsa.rsaID == null) return [];

    _myStream = wsaRef.child(rsa.rsaID!).onValue.listen((event) {
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
          flagFindYet = true;
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
            for (var mech in ref.watch(rsaProvider).newNearbyMechanics!.keys) {
              print(
                  "${mech} ====== ${dataSnapShotMechanic.key}-> ${dataSnapShotMechanic.key == mech}");
              print("do I already have him?");
              if (dataSnapShotMechanic.key == mech) {
                print(
                    "YESSSSSSSSSSSSS->${ref.watch(rsaProvider).newNearbyMechanics![mech]!.name}");
                ref.watch(rsaProvider.notifier).addAcceptedNearbyMechanic(
                    ref.watch(rsaProvider).newNearbyMechanics![mech]!);
                // print(ref.watch(rsaProvider).);
              }
            }
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
        });

        if (flagAllRejected && flagFindYet) {
          //TODO: Show a dialog box (ALL rejected Please request later)
          print("ALL MECHANIC REJECTED MECHANIC ");
          allRejected(context, "Mechanics");
        }

        flagAllRejected = true;
        flagFindYet = false;

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
          allRejected(context, "Providers");
          print("All providers rejected");
        }
      }
    });
  }

  bool finished = false;

  void check() async {
    print(">>Checking");
    // Future.delayed(Duration.zero, () async {
    print(ref.watch(rsaProvider).mechanic ?? "sad mafi4 assigned mechanic");
    print(needProvider ? "need prov" : "no need prov");
    if (!finished && ref.watch(rsaProvider).mechanic != null) {
      if (needProvider && ref.watch(rsaProvider).towProvider != null) {
        print(">>>>prov+mech page");
        await _myStream.cancel();
        context.push(Select.routeName, extra: true);
        finished = true;
      } else if (!needProvider) {
        print(">>>>mech page");
        // Future.delayed(Duration.zero, () async {
        await _myStream.cancel();
        context.push(Select.routeName, extra: false);
        finished = true;
        // });
      }
    }
    // });
  }

// Get assigned Provider
  Widget getProviderWidget() {
    return (ref.watch(rsaProvider).towProvider != null
        ? mapTowProviderToWidget(ref.watch(rsaProvider).towProvider!)
        // ? Container(child: Text("Mech exits"))
        : TextFieldOnMap(
            textToDisplay:
                didRequest ? "choose_provider".tr() : "needTowTruck".tr(),
            imageIconToDisplay:
                const ImageIcon(AssetImage('assets/images/tow-truck 2.png')),
            isSelected: didRequest ? needProvider : false,
            child: didRequest
                ? null
                : Switch(
                    value: needProvider,
                    onChanged: (value) {
                      setState(() => needProvider = !needProvider);
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
              color: Colors.blue,
            ),
          ));
  }
}
