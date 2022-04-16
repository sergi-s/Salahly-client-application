import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slahly/screens/WSA/WSA_screen.dart';
import 'package:slahly/screens/myLocation/mylocationscreen.dart';
import 'package:slahly/screens/roadsideassistance/choosemechanic.dart';
import 'package:slahly/screens/roadsideassistance/searching_mechanic_provider_screen.dart';
import 'package:slahly/screens/splashScreen/splashscreen.dart';
import 'package:slahly/screens/switchLanguage.dart';
import 'package:slahly/screens/test_screens/test_user_SM.dart';
import 'package:slahly/screens/test_screens/testscreen_foula.dart';
import 'package:slahly/screens/userMangament/manageSubowner.dart';

import 'dropOff_screens/dropOff_location_screen.dart';

class AllScreens extends StatelessWidget {
  static const routeName = "/allscreens";

  Widget btn(String screen, BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          context.push(screen);
        },
        child: Text(screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
          child: Container(
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  btn(MyLocationScreen.routeName, context),
                  btn(ChooseMechanicScreen.routeName, context),
                  btn(WSAScreen.routeName, context),
                  btn(TestScreen_nearbymechanics_and_create_rsa.routeName, context),
                  btn(SwitchLanguageScreen.routeName, context),
                  btn(SearchingMechanicProviderScreen.routeName, context),
                  btn(ManageSubowner.routeName, context),
                  btn(DropOffLocationScreen.routeName, context)
                ],
              ))),
    ));
  }
}
