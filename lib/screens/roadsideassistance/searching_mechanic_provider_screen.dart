import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slahly/abstract_classes/user.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/classes/models/client.dart';
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/classes/models/mechanic.dart';
import 'package:slahly/classes/models/towProvider.dart';
import 'package:slahly/classes/provider/rsadata.dart';
import 'package:go_router/go_router.dart';

import 'package:slahly/widgets/roadsideassistance/HoldPlease.dart';
import 'package:slahly/widgets/roadsideassistance/services_provider_card.dart';

Client user = Client(
    name: "aya",
    email: "aya@email.com",
    subscription: SubscriptionTypes.silver,
    loc: CustomLocation(latitude: 55, longitude: 55));

DatabaseReference rsaRef = FirebaseDatabase.instance.ref().child("rsa");

class SearchingMechanicProviderScreen extends ConsumerWidget {
  static const String routeName = "/searchingmechanicprovider";

  SearchingMechanicProviderScreen({Key? key, required this.userLocation})
      : super(key: key);

  final CustomLocation userLocation;

//TODO static data to be removed

  final Mechanic chosenMechanic = Mechanic(
      name: "Mohamed",
      email: "mohamed@gmail.com",
      nationalID: "123",
      phoneNumber: "012",
      isCenter: true,
      type: Type.mechanic,
      loc: CustomLocation(latitude: 50, longitude: 50, address: "hello WOrld"),
      avatar:
          "https://imagesvc.meredithcorp.io/v3/mm/image?url=https%3A%2F%2Fstatic.onecms.io%2Fwp-content%2Fuploads%2Fsites%2F20%2F2021%2F03%2F29%2Fbrad-pitt.jpg");

  final TowProvider chosenTowProvider = TowProvider(
      name: "Sergi",
      email: "sergi@email.net",
      nationalID: "123",
      phoneNumber: "012",
      type: Type.provider,
      isCenter: false,
      loc: CustomLocation(
          latitude: 50, longitude: 50, address: "Khaled ebn el walid"),
      avatar:
          "https://imagesvc.meredithcorp.io/v3/mm/image?url=https%3A%2F%2Fstatic.onecms.io%2Fwp-content%2Fuploads%2Fsites%2F20%2F2021%2F03%2F29%2Fbrad-pitt.jpg");

  late Mechanic? mechanic;
  late TowProvider? provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    RSANotifier rsaNotifier = ref.watch(rsaProvider.notifier);
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
                getMechanicWidget(ref),
                const SizedBox(height: 15),
                getProvWidget(ref),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    rsaNotifier.assignState(RSAStates.canceled);
                    // context.pop();
                    // Navigator.pop(context);
                    confirmCancellation(context, ref);
                  },
                  child: Text("Cancel".tr()),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF193566),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void confirmCancellation(context, ref) {
    RSANotifier rsaNotifier = ref.watch(rsaProvider.notifier);

    RSA rsa = ref.watch(rsaProvider);
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("are_you_sure".tr()),
              content: Text("confirm_cancellation".tr()),
              actions: <Widget>[
                ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel".tr())),
                ElevatedButton(
                    onPressed: () async {
                      //Cancel RSA request
                      //From State Management and Firebase
                      rsaNotifier.assignState(RSAStates.canceled);
                      await rsaRef.child(rsa.rsaID!).update(
                          {"state": RSA.stateToString(RSAStates.canceled)});
                      context.pop();
                    },
                    child: Text("confirm".tr()))
              ],
            ));
  }

//"-MyUNThvOQvuoy6HeOy-"
//       {latitude: 2, mechanic: 123, towProviderID: 456, state: RSA_state.waiting_for_mech_response, userID: 4, longitude: 1}

  // Future requestRSA(ref) async {
  //   rsa = ref.watch(rsaProvider);
  //
  //   DatabaseReference newRSA = dbRef.child("rsa").push();
  //
  //   await newRSA.set({
  //     "userID": rsa.user!.id,
  //     "latitude": rsa.location!.latitude,
  //     "longitude": rsa.location!.longitude,
  //     "towProviderID": "waiting",
  //     "mechanic": "waiting",
  //     "state": RSAStates.waitingForMechanicResponse.toString()
  //   });
  //   rsa_id = newRSA.key!;
  //   return newRSA.key;
  // }

  //Helper Function

  Widget getMechanicWidget(ref) {
    RSA rsa = ref.watch(rsaProvider);
    return (rsa.mechanic != null
        ? mapMechanicToWidget(rsa.mechanic!)
        //NOTE: un-comment if you want to see selected mechanics
        // return (chosenMechanic != null
        //     ? mapMechanicToWidget(chosenMechanic)
        : const HoldPlease(who: "mechanic"));
  }

  Widget mapMechanicToWidget(Mechanic mec) {
    return ServicesProviderCard(
      serviceProviderEmail: mec.email,
      serviceProviderName: mec.name,
      serviceProviderIsCenter: mec.isCenter,
      serviceProviderType: mec.getUserType(),
      serviceProviderPhoneNumber: mec.phoneNumber,
      serviceProviderRating: mec.rating,
      serviceProviderAddress: mec.address,
    );
  }

  Widget getProvWidget(ref) {
    RSA rsa = ref.watch(rsaProvider);

    return (rsa.towProvider != null
        ? mapProviderToWidget(rsa.towProvider!)
        //NOTE: un-comment if you want to see selected provider
        // return (chosenTowProvider != null
        //     ? mapProviderToWidget(chosenTowProvider)
        : const HoldPlease(who: "provider"));
  }

  Widget mapProviderToWidget(TowProvider prov) {
    return ServicesProviderCard(
      serviceProviderEmail: prov.email,
      serviceProviderName: prov.name,
      serviceProviderIsCenter: prov.isCenter,
      serviceProviderType: prov.getUserType(),
      serviceProviderPhoneNumber: prov.phoneNumber,
      serviceProviderRating: prov.rating,
      serviceProviderAddress: prov.address,
    );
  }
}
