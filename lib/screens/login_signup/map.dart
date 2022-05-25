import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/widgets/location/mapWidget.dart';

class Map_Registration extends StatefulWidget {
  const Map_Registration({Key? key}) : super(key: key);
  static const String routeName = '/map';
  static CustomLocation? location;

  @override
  State<Map_Registration> createState() => Map_RegistrationState();
}

class Map_RegistrationState extends State<Map_Registration> {
  GlobalKey<MapWidgetState> myMapWidgetState = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () async {
              await myMapWidgetState.currentState!.locatePosition();
              Map_Registration.location =
                  myMapWidgetState.currentState?.currentCustomLoc;
              print("${Map_Registration.location.toString()}cccccc");
            },
            style: ElevatedButton.styleFrom(
              primary: const Color(0xFF193566),
            ),
            child: Icon(Icons.location_on),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              primary: const Color(0xFF193566),
            ),
            child: const Text("Confirm").tr(),
          )
        ],
      ),
      body: Stack(
        children: [MapWidget(key: myMapWidgetState)],
      ),
    );
  }
}
