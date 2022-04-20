import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:slahly/widgets/location/mapWidget.dart';
import 'package:slahly/screens/roadsideassistance/searching_mechanic_provider_screen.dart';

class MyLocationScreen extends StatefulWidget {
  static const String routeName = "/locationComponent";

  @override
  _MyLocationScreenState createState() => _MyLocationScreenState();
}

class _MyLocationScreenState extends State<MyLocationScreen> {
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
                  customDialog(context);
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

  void customDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("confirm_location".tr()),
                  const ImageIcon(AssetImage('assets/images/tow-truck 2.png')),
                ],
              ),
              content: Text(
                  "are you sure you want to request roadside assistance at \n" +
                      myMapWidgetState.currentState!.currentCustomLoc.address!),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel".tr()),
                ),
                ElevatedButton(
                    onPressed: () {
                      print(myMapWidgetState.currentState!.currentCustomLoc);
                      context.go(SearchingMechanicProviderScreen.routeName,
                          extra:
                          myMapWidgetState.currentState!.currentCustomLoc);
                    },
                    child: Text("confirm_location".tr()))
              ],
            ));
  }
}
