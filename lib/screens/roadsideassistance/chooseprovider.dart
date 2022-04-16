import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/classes/models/towProvider.dart';
import 'package:slahly/abstract_classes/user.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:slahly/screens/roadsideassistance/searching_mechanic_provider_screen.dart';
import 'package:slahly/screens/userMangament/select.dart';

import 'package:slahly/widgets/ChooseTile.dart';

import '../../classes/provider/rsadata.dart';
import '../../main.dart';

class ChooseProviderScreen extends ConsumerWidget {
  static const routeName = "/chooseproviderscreen";

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
  _getStream(BuildContext context, ref) async {
    DatabaseReference ttaRef = FirebaseDatabase.instance.ref().child("tta");
    RSANotifier rsaNotifier = ref.watch(rsaProvider.notifier);
    RSA rsa = ref.watch(rsaProvider);
    ttaRef.child(rsa.rsaID!).onValue.listen((event) {
      print(rsa.rsaID);
      if (event.snapshot.value != null) {
        print("data  null");
        DataSnapshot dataSnapshot = event.snapshot;
        if (dataSnapshot.child("state").value.toString() ==
            RSA.stateToString(RSAStates.waitingForProviderResponse)) {
          dataSnapshot.child("providersResponses").children.forEach((prov) {
            if (prov.value == "accepted") {
              print("provider accepted");
              for (var provider in rsa.nearbyProviders!) {
                if (provider.id == prov.key) {
                  print("provider assigned");
                  rsaNotifier.assignProvider(provider, false);
                }
              }
            } else if (prov.value == "rejected") {
              for (var provider in rsa.nearbyProviders!) {
                if (provider.id == prov.key) {
                  print("msh 7ro7");
                  // rsaNotifier.assignProvider(
                  //     TowProvider(name: null, email: null), false);

                  while (navigatorKey.currentContext != null) {
                    navigatorKey.currentContext?.pop();
                  }
                  navigatorKey.currentState
                      ?.pushNamed(ChooseProviderScreen.routeName);

                  print("msh 7tegy");
                }
              }
            }
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context, ref) {
    final rsaNotifier = ref.watch(rsaProvider.notifier);
    final RSA rsa = ref.watch(rsaProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        title: Center(
          child: Text(("choose_provider".tr()),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black)),
        ),
      ),
      body: Center(
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              enableDrag: true,
              isDismissible: true,
              builder: (BuildContext context) {
                return Column(
                  children: [
                    SizedBox(height: 10),
                    ListView.builder(
                      itemBuilder: (BuildContext, index) {
                        return GestureDetector(
                          onTap: () async {
                            await rsaNotifier.requestTta();
                            print("hide");
                            print(rsa.rsaID);

                            _getStream(context, ref);

                            context.go(Select.routeName, extra: true);
                          },
                          child: ChooseTile(
                              email:
                                  rsa.nearbyProviders![index].email.toString(),
                              avatar:
                                  rsa.nearbyProviders![index].avatar.toString(),
                              phone: rsa.nearbyProviders![index].phoneNumber
                                  .toString(),
                              name: rsa.nearbyProviders![index].name.toString(),
                              address: "",
                              type: Type.provider,
                              isCenter: false),
                        );
                      },
                      itemCount: providers.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.all(5),
                      scrollDirection: Axis.vertical,
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
