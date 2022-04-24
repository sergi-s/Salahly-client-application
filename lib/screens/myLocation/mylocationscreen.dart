import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:slahly/widgets/location/mapWidget.dart';
import 'package:slahly/screens/roadsideassistance/searching_mechanic_provider_screen.dart';

import 'package:slahly/widgets/dialogues/request_confirmation_dialogue.dart';

import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';

import 'package:slahly/classes/provider/app_data.dart';

class MyLocationScreen extends ConsumerStatefulWidget {
  static const String routeName = "/locationComponent";

  @override
  _MyLocationScreenState createState() => _MyLocationScreenState();
}

class _MyLocationScreenState extends ConsumerState<MyLocationScreen> {
  GlobalKey<MapWidgetState> myMapWidgetState = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  myMapWidgetState.currentState?.locatePosition();
                },
                child: Text('my_location'.tr())),
            const SizedBox(width: 4),
            ElevatedButton(
                onPressed: () {
                  if (ref.watch(salahlyClientProvider).requestType !=
                      RequestType.NONE) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("There is another onging request"),
                    ));
                    return;
                  }
                  requestConfirmationDialogue(
                    context,
                    titleChildren: [
                      Text("confirm_location".tr()),
                      const ImageIcon(
                          AssetImage('assets/images/tow-truck 2.png')),
                    ],
                    content: Text("rsaConfirmation".tr() +
                        "\n" +
                        myMapWidgetState
                            .currentState!.currentCustomLoc.address!),
                    actionChildren: <Widget>[
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancel".tr()),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            print(myMapWidgetState
                                .currentState!.currentCustomLoc);
                            context.push(
                                SearchingMechanicProviderScreen.routeName,
                                extra: myMapWidgetState
                                    .currentState!.currentCustomLoc);
                          },
                          child: Text("confirm_location".tr()))
                    ],
                  );
                  // showSimpleNotification(
                  //     Text("CurrentCustom lat: " +
                  //         myMapWidgetState
                  //             .currentState!.currentCustomLoc.latitude
                  //             .toString() +
                  //         "  long:  " +
                  //         myMapWidgetState
                  //             .currentState!.currentCustomLoc.longitude
                  //             .toString()),
                  //     background: Colors.green);
                  // context.go(SearchingMechanicProvider.routeName,
                  //     extra: currentCustomLoc);
                },
                child: Text("confirm_location".tr())),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Stack(
          children: [
            MapWidget(key: myMapWidgetState),
          ],
        ));
  }
}
