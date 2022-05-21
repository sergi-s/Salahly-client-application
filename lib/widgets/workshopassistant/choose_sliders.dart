import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:slahly/classes/models/mechanic.dart';
import 'package:slahly/classes/models/towProvider.dart';
import 'package:slahly/classes/provider/rsadata.dart';
import 'package:slahly/widgets/ChooseTile.dart';
import 'package:slahly/widgets/dialogues/confirm_cancellation.dart';
import 'package:slahly/widgets/location/finalScreen.dart';
import 'package:slahly/widgets/roadsideassistance/HoldPlease.dart';
import 'package:slahly/widgets/roadsideassistance/services_provider_card.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class WSASlider extends ConsumerStatefulWidget {
  bool needTowProvider, needMechanic;
  PanelController pc;

  WSASlider(
      {Key? key,
      required this.pc,
      required this.needTowProvider,
      required this.needMechanic})
      : super(key: key);

  @override
  ConsumerState<WSASlider> createState() => _WSASliderState();
}

class _WSASliderState extends ConsumerState<WSASlider> {
  List<Widget> tabs = [];
  bool requestDone = false;

  // List<Widget>
  tabsHeading() {
    tabs = [];
    if (widget.needMechanic) {
      tabs.add(const Tab(text: "Mechanic"));
    }
    if (widget.needTowProvider) {
      tabs.add(const Tab(text: "Tow Provider"));
    }
    print("TABSSS ${tabs.length}");
  }

  List<Widget> tabsContent(ScrollController sc) {
    List<Widget> tempList = [];
    if (widget.needMechanic) {
      tempList.add(
        Builder(builder: (context) {
          return Stack(alignment: Alignment.center, children: [
            ref.watch(rsaProvider).mechanic == null
                ? ref.watch(rsaProvider).acceptedNearbyMechanics!.isEmpty
                    // ? HoldPlease(who: "mechanic")
                    ? SearchingWidget(
                        who: "mechanic",
                        size: ref
                            .watch(rsaProvider)
                            .acceptedNearbyMechanics!
                            .length,
                      )
                    : ListView.separated(
                        itemCount: ref
                            .watch(rsaProvider)
                            .acceptedNearbyMechanics!
                            .length,
                        controller: sc,
                        itemBuilder: (BuildContext context, int index) {
                          return mechanicChooseTile(index);
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(height: 5);
                        },
                      )
                : mapMechanicToFullWidget(ref.watch(rsaProvider).mechanic!),
          ]);
        }),
      );
    }
    if (widget.needTowProvider) {
      tempList.add(Builder(builder: (context) {
        return Stack(alignment: Alignment.center, children: [
          ref.watch(rsaProvider).towProvider == null
              ? ref.watch(rsaProvider).acceptedNearbyProviders!.isEmpty
                  // ? HoldPlease(who: "provider")
                  ? SearchingWidget(
                      who: "provider",
                      size: ref
                          .watch(rsaProvider)
                          .acceptedNearbyProviders!
                          .length)
                  : ListView.separated(
                      itemCount: ref
                          .watch(rsaProvider)
                          .acceptedNearbyProviders!
                          .length,
                      controller: sc,
                      itemBuilder: (BuildContext context, int index) {
                        return towProviderChooseTile(index);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(height: 5);
                      },
                    )
              : mapTowProviderToFullWidget(ref.watch(rsaProvider).towProvider!)
        ]);
      }));
    }
    tabsHeading();
    return tempList;
  }

  @override
  Widget build(BuildContext context) {
    tabsHeading();
    check();
    return SlidingUpPanel(
      controller: widget.pc,
      panelSnapping: false,
      isDraggable: false,
      minHeight: 0,
      defaultPanelState: PanelState.CLOSED,
      panelBuilder: (sc) {
        return DefaultTabController(
          length: (widget.needTowProvider && widget.needMechanic) ? 2 : 1,
          child: Scaffold(
            backgroundColor: const Color(0xFFd1d9e6),
            appBar: AppBar(
              title: TabBar(
                tabs: tabs,
              ),
              // toolbarHeight: 21,
              // automaticallyImplyLeading: false,
              backgroundColor: const Color(0xFF193566),
            ),
            body: TabBarView(
              children: tabsContent(sc),
            ),
            floatingActionButton:
                requestDone ? nextPageButton() : cancelButton(),
          ),
        );
      },
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

  void check() async {
    print(">>Checking");
    // Future.delayed(Duration.zero, () async {
    print(ref.watch(rsaProvider).mechanic ?? "sad mafi4 assigned mechanic");
    print(widget.needTowProvider ? "need prov" : "no need prov");
    if (ref.watch(rsaProvider).mechanic != null) {
      if (widget.needTowProvider &&
          ref.watch(rsaProvider).towProvider != null) {
        print(">>>>prov+mech page");
        requestDone = true;
        // context.push(Arrival.routeName, extra: true);
      } else if (!widget.needTowProvider) {
        requestDone = true;
        print(">>>>mech page");
      }
    }
  }

  GestureDetector towProviderChooseTile(int index) {
    return GestureDetector(
      onTap: () {
        print(
            "${ref.watch(rsaProvider).acceptedNearbyProviders![index].name.toString()} is selected");
        //TODO assign mechanic
        ref.watch(rsaProvider.notifier).assignProvider(
            ref.watch(rsaProvider).acceptedNearbyProviders![index], false);
      },
      child: ChooseTile(
        estimatedTime: ref
            .watch(rsaProvider)
            .acceptedNearbyProviders![index]
            .estimatedTime
            .toString(),
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
        address: ref
            .watch(rsaProvider)
            .acceptedNearbyProviders![index]
            .address
            .toString(),
        type: ref.watch(rsaProvider).acceptedNearbyProviders![index].type!,
        isCenter:
        ref.watch(rsaProvider).acceptedNearbyProviders![index].isCenter,
        rating: ref.watch(rsaProvider).acceptedNearbyProviders![index].rating,
      ),
    );
  }

  GestureDetector mechanicChooseTile(int index) {
    return GestureDetector(
      onTap: () {
        print(
            "${ref.watch(rsaProvider).acceptedNearbyMechanics![index].name.toString()} is selected");
        //TODO assign mechanic
        ref.watch(rsaProvider.notifier).assignMechanic(
            ref.watch(rsaProvider).acceptedNearbyMechanics![index], false);
      },
      child: ChooseTile(
        email: ref
            .watch(rsaProvider)
            .acceptedNearbyMechanics![index]
            .email
            .toString(),
        avatar: ref
            .watch(rsaProvider)
            .acceptedNearbyMechanics![index]
            .avatar
            .toString(),
        phone: ref
            .watch(rsaProvider)
            .acceptedNearbyMechanics![index]
            .phoneNumber
            .toString(),
        name: ref
            .watch(rsaProvider)
            .acceptedNearbyMechanics![index]
            .name
            .toString(),
        type: ref.watch(rsaProvider).acceptedNearbyMechanics![index].type!,
        isCenter:
            ref.watch(rsaProvider).acceptedNearbyMechanics![index].isCenter,
        address: ref
            .watch(rsaProvider)
            .acceptedNearbyMechanics![index]
            .address
            .toString(),
        rating: ref.watch(rsaProvider).acceptedNearbyMechanics![index].rating,
      ),
    );
  }
}

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
        mechanics.isEmpty
            ? HoldPlease()
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
        towProviders.isEmpty
            ? HoldPlease()
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
                estimatedTime: towProviders[index].estimatedTime,
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
