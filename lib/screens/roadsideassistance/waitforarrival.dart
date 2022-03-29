import 'dart:convert';
import 'dart:html';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slahly/abstract_classes/user.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/classes/models/client.dart';
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/classes/models/mechanic.dart';
import 'package:slahly/classes/models/towProvider.dart';
import 'package:slahly/classes/provider/rsadata.dart';
import 'package:slahly/utils/location/getuserlocation.dart';
import "package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart";


Client user = Client(
    name: "aya",
    email: "aya.emai",
    subscription: SubscriptionTypes.silver,
    loc: CustomLocation(latitude: 55, longitude: 55));

DatabaseReference rsaRef = FirebaseDatabase.instance.ref().child("rsa");

class SearchingMechanicProvider extends ConsumerWidget {
  static const String routeName = "/searchingmechanicprovider";

  SearchingMechanicProvider({required this.userLocation});

  final CustomLocation userLocation;

  Mechanic choosenMech = Mechanic(
      name: "Mohamed",
      email: "mohamed@gmail.com",
      nationalID: "123",
      phoneNumber: "012",
      isCenter: true,
      type: Type.mechanic,
      loc: CustomLocation(latitude: 50, longitude: 50, address: "hello WOrld"),
      avatar:
          "https://imagesvc.meredithcorp.io/v3/mm/image?url=https%3A%2F%2Fstatic.onecms.io%2Fwp-content%2Fuploads%2Fsites%2F20%2F2021%2F03%2F29%2Fbrad-pitt.jpg");

  TowProvider choosenTowProvider = TowProvider(
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

  late RSA rsa;
  late Mechanic? mechanic;
  late TowProvider? provider;
  late String rsa_id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(rsaProvider.notifier).assignUserLocation(userLocation);

    //TODO get Logged in user
    ref.watch(rsaProvider.notifier).assignUser(user);

    //DONE: create RSA

    // requestRSA(ref);
    //DONE:how to get RSA_ID
    ref.watch(rsaProvider.notifier).requestRSA();

    return _getRsaDataStream(ref);
  }

//"-MyUNThvOQvuoy6HeOy-"
//       {latitude: 2, mechanic: 123, towProviderID: 456, state: RSA_state.waiting_for_mech_response, userID: 4, longitude: 1}
  Widget _getRsaDataStream(ref) {
    rsa = ref.watch(rsaProvider);

    rsaRef.child(rsa.rsaID!).onValue.listen((event) {
      //DONE replace with rsa_id

      if (event.snapshot.value != null) {
        //TODO update state(assign mech/prov)
        //TODO try the code by assigning a mech
        //Not working
        ref.watch(rsaProvider.notifier).assignMechanic(choosenMech, false);



        switch (event.snapshot.child("RSA_state").value) {
          case RSA.stateToString(RSAStates.providerConfirmed):

            break;

        }
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFffffff),
      body: Container(
        padding: const EdgeInsets.only(left: 40, right: 40),
        // child: _getRsaDataStream(ref),,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 0.5,
                      blurRadius: 16,
                      color: Colors.black54,
                      offset: Offset(0.7, 0.7))
                ],
              ),
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 18),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      getMechWidget(),
                      const SizedBox(height: 40),
                      getProvWidget()
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

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

  Widget getMechWidget() {
    return (rsa.mechanic != null
        ? mapMechtoWiget(rsa.mechanic!)
        : const HoldPlease(who: "Mechanic"));
  }

  Widget mapMechtoWiget(Mechanic mec) {
    return ServicesProviderCard(
      serviceProviderAddress: mec.address!,
      serviceProviderName: mec.name!,
      serviceProviderAvatar: mec.avatar!,
      serviceProviderType: mec.getUserType()!,
    );
  }

  Widget getProvWidget() {
    return (rsa.towProvider != null
        ? mapProvetoWiget(rsa.towProvider!)
        : const HoldPlease(who: "Tow Provider"));
  }

  Widget mapProvetoWiget(TowProvider prov) {
    return ServicesProviderCard(
      serviceProviderAddress: prov.address!,
      serviceProviderName: prov.name!,
      serviceProviderAvatar: prov.avatar!,
      serviceProviderType: prov.getUserType()!,
    );
  }
}

class HoldPlease extends StatelessWidget {
  const HoldPlease({
    Key? key,
    required this.who,
  }) : super(key: key);
  final String who;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text(
        "Please Hold",
        style: TextStyle(fontSize: 20),
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(),
          const SizedBox(
            width: 10,
          ),
          Text(
            "Searching For $who...",
            style: TextStyle(
              fontSize: 15,
            ),
          )
        ],
      ),
    ]);
  }
}

class ServicesProviderCard extends StatelessWidget {
  const ServicesProviderCard({
    Key? key,
    required this.serviceProviderType,
    required this.serviceProviderName,
    required this.serviceProviderAddress,
    required this.serviceProviderAvatar,
  }) : super(key: key);

  final String serviceProviderType,
      serviceProviderName,
      serviceProviderAddress,
      serviceProviderAvatar;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 6),
        Text(
          serviceProviderType,
          style: TextStyle(fontSize: 30),
        ),
        Row(
          children: [
            CircleAvatar(
              backgroundImage: Image.network(serviceProviderAvatar).image,
              radius: 25,
            ),
            SizedBox(
              width: 10,
            ),
            const Text(
              "Name:",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 25),
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              serviceProviderName,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            )
          ],
        ),
        Row(
          children: [
            const SizedBox(
              width: 50,
            ),
            const Text(
              "Location:",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              serviceProviderAddress,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
              overflow: TextOverflow.ellipsis,
            )
          ],
        )
      ],
    );
  }
}
