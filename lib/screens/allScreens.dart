import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slahly/screens/workshop_assistance//workshop_assistance_screen.dart';
import 'package:slahly/screens/roadsideassistance/roadside_assistance_map.dart';
import 'package:slahly/screens/roadsideassistance/choosemechanic.dart';
import 'package:slahly/screens/roadsideassistance/searching_mechanic_provider_screen.dart';
import 'package:slahly/screens/splashScreen/splashscreen.dart';
import 'package:slahly/screens/switchLanguage.dart';
import 'package:slahly/screens/test_screens/test_user_SM.dart';
import 'package:slahly/screens/test_screens/testscreen_foula.dart';
import 'package:slahly/screens/userMangament/view_cars_to_manage_subowners.dart';
import 'package:slahly/screens/userMangament/manageSubowner.dart';
import 'roadsideassistance/arrival.dart';

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
                  btn(RoadSideAssistanceScreen.routeName, context),
                  btn(TestScreen_.routeName, context),
                  btn(ChooseMechanicScreen.routeName, context),
                  btn(Arrival.routeName, context),
                  btn(TestUserSM.routeName, context),
                  btn(WSAScreen.routeName, context),
                  btn(TestScreen_nearbymechanics_and_create_rsa.routeName,
                      context),
                  btn(SwitchLanguageScreen.routeName, context),
                  btn(SearchingMechanicProviderScreen.routeName, context),
                  btn(ManageSubowner.routeName, context),
                  btn(DropOffLocationScreen.routeName, context)
                ],
              ))),
    ));
  }
}
