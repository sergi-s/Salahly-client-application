import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:slahly/classes/provider/app_data.dart';
import 'package:slahly/classes/provider/rsadata.dart';
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';

import 'package:slahly/widgets/roadsideassistance/HoldPlease.dart';
import 'package:slahly/widgets/roadsideassistance/services_provider_card.dart';
import 'package:slahly/widgets/dialogues/confirm_cancellation.dart';
import 'package:slahly/widgets/dialogues/all_rejected.dart';
import 'package:slahly/widgets/dialogues/none_found.dart';

import '../../utils/firebase/get_mechanic_data.dart';
import '../../utils/firebase/get_provider_data.dart';
import 'arrival.dart';

class SearchingMechanicProviderScreen extends ConsumerStatefulWidget {
  static const String routeName = "/searchingmechanicprovider";

  SearchingMechanicProviderScreen({Key? key, this.userLocation})
      : super(key: key);

  CustomLocation? userLocation;

  @override
  _SearchingMechanicProviderScreenState createState() =>
      _SearchingMechanicProviderScreenState();
}

class _SearchingMechanicProviderScreenState
    extends ConsumerState<SearchingMechanicProviderScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      final prefs = await SharedPreferences.getInstance();
      if (ref.watch(salahlyClientProvider).requestType == RequestType.RSA) {
        ref.watch(rsaProvider.notifier).assignRequestID(
            ref.watch(salahlyClientProvider).requestID.toString());
        print("there is a onging request");
        print("HELLO::${ref.watch(rsaProvider).rsaID}");

        if (prefs.getString("mechanic") != null) {
          ref.watch(rsaProvider.notifier).assignMechanic(
              await getMechanicData(prefs.getString("mechanic")!), false);
        }
        if (prefs.getString("towProvider") != null) {
          ref.watch(rsaProvider.notifier).assignProvider(
              await getProviderData(prefs.getString("towProvider")!), false);
        }
        _getRsaDataStream();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFd1d9e6),
      body: SafeArea(
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.black),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 6),
                Text(("rsa_placed".tr()), style: const TextStyle(fontSize: 22)),
                const SizedBox(height: 12),
                Text(("help_on_way".tr()),
                    style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 20),
                getMechanicWidget(),
                const SizedBox(height: 15),
                getProvWidget(),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    confirmCancellation(context, ref);
                  },
                  child: Text("Cancel".tr()),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF193566),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void check() {
    if ((ref.watch(rsaProvider).mechanic != null) &&
        (ref.watch(rsaProvider).towProvider != null)) {
      context.push(Arrival.routeName, extra: true);
    }
  }

  //Helper Function/Widgets
  Widget getMechanicWidget() {
    return (ref.watch(rsaProvider).mechanic != null
        ? mapMechanicToWidget(ref.watch(rsaProvider).mechanic!)
        //NOTE: un-comment if you want to see selected mechanics
        // return (chosenMechanic != null
        //     ? mapMechanicToWidget(chosenMechanic)
        : HoldPlease(who: "mechanic"));
  }

  Widget getProvWidget() {
    return (ref.watch(rsaProvider).towProvider != null
        ? mapTowProviderToWidget(ref.watch(rsaProvider).towProvider!)
        //NOTE: un-comment if you want to see selected provider
        // return (chosenTowProvider != null
        //     ? mapProviderToWidget(chosenTowProvider)
        : HoldPlease(who: "provider"));
  }

  //Stream
  _getRsaDataStream() async {
    DatabaseReference rsaRef = FirebaseDatabase.instance.ref().child("rsa");
    RSANotifier rsaNotifier = ref.watch(rsaProvider.notifier);
    RSA rsa = ref.watch(rsaProvider);

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

          bool flagAllRejected = true;
          bool flagFindYet = false;
          dataSnapshot.child("mechanicsResponses").children.forEach((mechanic) {
            ref.watch(rsaProvider.notifier).atLeastOneMechanic = true;
            flagFindYet = true;
            if (mechanic.value == "pending") {
              flagAllRejected = false;
            }
            if (mechanic.value == "accepted") {
              flagAllRejected = false;
              print("Someone is accepted");
              if (ref
                  .watch(rsaProvider)
                  .newNearbyMechanics!
                  .containsKey(mechanic.key)) {
                ref.watch(rsaProvider.notifier).assignMechanic(
                    ref.watch(rsaProvider).newNearbyMechanics![mechanic.key]!,
                    false);
              } else {
                getMechanicData(mechanic.key!).then((value) {
                  ref.watch(rsaProvider.notifier).assignMechanic(value, false);
                });
              }
              // for (var mech
              //     in ref.watch(rsaProvider).newNearbyMechanics!.keys) {
              //   print("l2it 7ad");
              //   if (mech == mechanic.key) {
              //     print("this is the mechanic${mechanic.key}");
              //     rsaNotifier.assignMechanic(
              //         ref.watch(rsaProvider).newNearbyMechanics![mech]!, false);
              //     rsaNotifier.assignState(RSAStates.waitingForProviderResponse);
              //     print(rsa.mechanic!.name.toString());
              //     print("mech got assigned");
              //   }
              //   print("end of mech loop");
              // }
            }
            if (mechanic.value == "rejected") {
              if (ref.watch(rsaProvider).mechanic != null) {
                if (mechanic.key == ref.watch(rsaProvider).mechanic!.id) {
                  print("No--------------------------------");
                  print("The assigned mechanic just rejected the request");
                }
              }
            }
          });
          if (flagAllRejected && flagFindYet) {
            //TODO: Show a dialog box (ALL rejected Please request later)
            print("ALL MECHANIC REJECTED MECHANIC ");
            allRejected(context, ref, "Mechanics");
          }
        }

        if (dataSnapshot.child("state").value.toString() ==
                RSA.stateToString(RSAStates.waitingForProviderResponse) &&
            (ref.watch(rsaProvider).mechanic != null)) {
          print(
              "waiting for prov is activated and there is a mech that accepted");

          bool flagAllRejected = true;
          bool flagFindYet = false;

          dataSnapshot.child("providersResponses").children.forEach((prov) {
            ref.watch(rsaProvider.notifier).atLeastOneProvider = true;
            flagFindYet = true;
            print("PROV $prov:\t ${prov.value} ${prov.key}");
            if (prov.value == "pending") {
              flagAllRejected = false;
            }
            if (prov.value == "accepted") {
              flagAllRejected = false;
              print("Someone is accepted");
              print(rsa.newNearbyProviders);
              print("Someone is accepted2");
              // for (var provider
              //     in ref.watch(rsaProvider).newNearbyProviders!.keys) {
              //   print("l2it 7ad");
              //   if (provider == prov.key) {
              //     print("this is the provider${prov.key}");
              //     rsaNotifier.assignProvider(
              //         ref.watch(rsaProvider).newNearbyProviders![provider]!,
              //         false);
              //     print("prov got assigned");
              //   }
              //   print("end of prov loop");
              // }
              if (ref
                  .watch(rsaProvider)
                  .newNearbyProviders!
                  .containsKey(prov.key)) {
                ref.watch(rsaProvider.notifier).assignProvider(
                    ref.watch(rsaProvider).newNearbyProviders![prov.key]!,
                    false);
              } else {
                getProviderData(prov.key!).then((value) {
                  ref.watch(rsaProvider.notifier).assignProvider(value, false);
                });
              }
            }
          });

          if (flagAllRejected && flagFindYet) {
            //TODO: Show a dialog box (ALL rejected Please request later)
            allRejected(context, ref, "Providers");
            print("All providers rejected");
          }
        }
      }
      check();
    });
  }

  void activate3Min() async {
    print("RSA: abl el 3 minutes");
    bool foundAny = await ref
        .watch(rsaProvider.notifier)
        .atLeastOne(needMechanic: true, needProvider: true);

    if (!foundAny) {
      !ref.watch(rsaProvider.notifier).atLeastOneProvider
          ? noneFound(context, who: false)
          : null;
      !ref.watch(rsaProvider.notifier).atLeastOneMechanic
          ? noneFound(context, who: true)
          : null;
    }
  }

  requestRSA() async {
    print("Requesting RSA::");
    RSANotifier rsaNotifier = ref.watch(rsaProvider.notifier);
    rsaNotifier.assignRequestTypeToRSA();

    await rsaNotifier.requestRSA();
    await rsaNotifier.searchNearbyMechanicsAndProviders();
    ref.watch(salahlyClientProvider.notifier).assignRequest(
        ref.watch(rsaProvider).requestType!, ref.watch(rsaProvider).rsaID!);
    _getRsaDataStream();
    activate3Min();
  }
}
