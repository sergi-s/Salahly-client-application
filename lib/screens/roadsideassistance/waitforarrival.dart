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

  late Mechanic? mechanic;
  late TowProvider? provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    RSA rsa = ref.watch(rsaProvider);
    RSANotifier rsaNotifier = ref.watch(rsaProvider.notifier);

    // return Scaffold(
    //     body: SafeArea(
    //   child: Column(
    //     children: [getMechWidget(ref), getProvWidget(ref)],
    //   ),
    // ));
    return Scaffold(
        backgroundColor: const Color(0xFFffffff),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(left: 40, right: 40),
            // child: _getRsaDataStream(ref),,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getMechWidget(ref),
                  SizedBox(height: 20),
                  getProvWidget(ref)
                ]),
          ),
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

  Widget getMechWidget(ref) {
    RSA rsa = ref.watch(rsaProvider);
    return (rsa.mechanic != null
        ? mapMechtoWiget(rsa.mechanic!)
        : const HoldPlease(who: "Mechanic"));
    // : Text("mech w8"));
  }

  Widget mapMechtoWiget(Mechanic mec) {
    return ServicesProviderCard(
      serviceProviderEmail: mec.email!,
      serviceProviderName: mec.name!,
      serviceProviderIsCenter: mec.isCenter ?? false,
      serviceProviderType: mec.getUserType()!,
      serviceProviderPhoneNumber: mec.phoneNumber!,
    );
  }

  Widget getProvWidget(ref) {
    RSA rsa = ref.watch(rsaProvider);
    return (rsa.towProvider != null
        ? mapProvetoWiget(rsa.towProvider!)
        : const HoldPlease(who: "Tow Provider"));
    // : Text("prov w8"));
  }

  Widget mapProvetoWiget(TowProvider prov) {
    return ServicesProviderCard(
      serviceProviderEmail: prov.address!,
      serviceProviderName: prov.name!,
      serviceProviderPhoneNumber: prov.avatar!,
      serviceProviderType: prov.getUserType()!,
      serviceProviderIsCenter: prov.isCenter ?? false,
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
  ServicesProviderCard({
    Key? key,
    required this.serviceProviderType,
    required this.serviceProviderName,
    required this.serviceProviderEmail,
    required this.serviceProviderIsCenter,
    required this.serviceProviderPhoneNumber,
  }) : super(key: key);

  final String serviceProviderType,
      serviceProviderName,
      serviceProviderEmail,
      serviceProviderPhoneNumber;
  bool serviceProviderIsCenter;

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
              backgroundImage: serviceProviderIsCenter
                  ? Image.network(
                          "https://www.biography.com/.image/ar_1:1%2Cc_fill%2Ccs_srgb%2Cfl_progressive%2Cq_auto:good%2Cw_1200/MTY3MDUxMjkzMjI1OTIwMTcz/brad-pitt-attends-the-premiere-of-20th-century-foxs--square.jpg")
                      .image
                  : null,
              radius: 25,
            ),
            SizedBox(width: 10),
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
              "Email:",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              serviceProviderEmail,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
        Row(
          children: [
            const SizedBox(
              width: 50,
            ),
            const Text(
              "Phone:",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              serviceProviderPhoneNumber,
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
