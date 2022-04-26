import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slahly/classes/models/towProvider.dart';
import 'package:slahly/classes/provider/rsadata.dart';
import 'package:slahly/widgets/roadsideassistance/HoldPlease.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:slahly/classes/models/mechanic.dart';

import 'package:slahly/widgets/ChooseTile.dart';

class ChooseMechanicSlider extends ConsumerWidget {
  ChooseMechanicSlider({Key? key, required this.pc, required this.mechanics})
      : super(key: key);

  PanelController pc;
  List<Mechanic> mechanics;

  @override
  Widget build(BuildContext context, ref) {
    return SlidingUpPanel(
      controller: pc,
      // color: Color(0xFFd1d9e6),
      // backdropEnabled: true,
      panelSnapping: true,
      minHeight: 0,
      // borderRadius: const BorderRadius.vertical(
      //   top: Radius.circular(50),
      // ),
      defaultPanelState: PanelState.CLOSED,
      panelBuilder: (ScrollController sc) =>
          Stack(alignment: Alignment.center, children: [
        (ref.watch(rsaProvider).acceptedNearbyMechanics!.isEmpty)
            ? HoldPlease()
            : const Text(""),
        mechanics.isEmpty
            ? SearchingWidget(
              size: ref.watch(rsaProvider).newNearbyMechanics!.keys.length,
              who: "mechanicAndWaitingForResponse".tr(),
            )
            : Padding(
                padding: const EdgeInsets.only(left: 160.0, top: 10),
                child: SizedBox(
                  //first container
                  height: 20,
                  width: 60,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5, top: 5),
                    child: ElevatedButton(
                      onPressed: () {
                        print("hello");
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        padding: const EdgeInsets.all(10),
                      ),
                      child: null,
                    ),
                  ),
                ),
              ),
        ListView.separated(
          itemCount: mechanics.length,
          controller: sc,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                print("${mechanics[index].name.toString()} is selected");
                //TODO assign mechanic
                ref
                    .watch(rsaProvider.notifier)
                    .assignMechanic(mechanics[index], false);
                pc.close();
              },
              child: ChooseTile(
                email: mechanics[index].email.toString(),
                avatar: mechanics[index].avatar.toString(),
                phone: mechanics[index].phoneNumber.toString(),
                name: mechanics[index].name.toString(),
                type: mechanics[index].type!,
                isCenter: mechanics[index].isCenter,
                address: mechanics[index].address.toString(),
                rating: mechanics[index].rating,
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(height: 5);
          },
        )
      ]),
      collapsed: Container(),
    );
  }
}

class ChooseTowProviderSlider extends ConsumerWidget {
  ChooseTowProviderSlider(
      {Key? key, required this.pc, required this.towProviders})
      : super(key: key);

  PanelController pc;
  List<TowProvider> towProviders;

  @override
  Widget build(BuildContext context, ref) {
    return SlidingUpPanel(
      controller: pc,
      panelSnapping: true,
      minHeight: 0,
      defaultPanelState: PanelState.CLOSED,
      panelBuilder: (ScrollController sc) =>
          Stack(alignment: Alignment.center, children: [
        (ref.watch(rsaProvider).acceptedNearbyProviders!.isEmpty)
            ? HoldPlease()
            : const Text(""),
        towProviders.isEmpty
            ? SearchingWidget(
              size: ref.watch(rsaProvider).newNearbyProviders!.keys.length,
              who: "providerAndWaitingForResponse".tr(),
            )
            : Padding(
                padding: const EdgeInsets.only(left: 160.0, top: 10),
                child: SizedBox(
                  //first container
                  height: 20,
                  width: 60,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5, top: 5),
                    child: RaisedButton(
                        color: Colors.white,
                        onPressed: () {
                          print("hello");
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                  ),
                ),
              ),
        ListView.separated(
          itemCount: towProviders.length,
          controller: sc,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                print("${towProviders[index].name.toString()} is selected");
                //TODO assign mechanic
                ref
                    .watch(rsaProvider.notifier)
                    .assignProvider(towProviders[index], false);
                pc.close();
              },
              child: ChooseTile(
                email: towProviders[index].email.toString(),
                avatar: towProviders[index].avatar.toString(),
                phone: towProviders[index].phoneNumber.toString(),
                name: towProviders[index].name.toString(),
                address: towProviders[index].address.toString(),
                type: towProviders[index].type!,
                isCenter: towProviders[index].isCenter,
                rating: towProviders[index].rating,
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(height: 5);
          },
        )
      ]),
      collapsed: Container(),
    );
  }
}

class SearchingWidget extends StatelessWidget {
  SearchingWidget({Key? key, this.who, this.size}) : super(key: key);

  String? who;
  int? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      alignment: Alignment.center,
      color: const Color(0xFFd1d9e6),
      child: Text(
        "weFound".tr() + " $size, " + who!,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}
