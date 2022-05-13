import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:go_router/go_router.dart';
import 'package:slahly/screens/car_management/addCars.dart';
import 'package:slahly/screens/history_management/ongoing_requests.dart';
import 'package:slahly/screens/history_management/view_history.dart';
import 'package:slahly/screens/homepage.dart';
import 'package:slahly/screens/reminder/reminderScreen.dart';
import 'package:slahly/screens/switchLanguage.dart';
import 'package:slahly/screens/userMangament/choose_car.dart';
import 'package:slahly/screens/userMangament/manageSubowner.dart';
import 'package:slahly/screens/userMangament/transferOwner.dart';

import '../../screens/car_management/view_cars_screen.dart';
import '../../screens/userMangament/addSubowner.dart';

Widget salahlyDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/wavy shape copy.png'),
                  alignment: Alignment.topCenter,
                  fit: BoxFit.fill),
              color: Colors.transparent),
          child: Text(''),
        ),
        // ListTile(
        //   title: Text('Test Sergi'),
        //   onTap: () {
        //     context.push(TestSergi.routeName);
        //   },
        // ),
        ListTile(
          title: Text(
            'home'.tr(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ).tr(),
          onTap: () {
            Navigator.pop(context);
            // context.push(Profile.routeName);
            context.push(HomePage.routeName);
          },
        ),
        ListTile(
          title: const Text('myCars').tr(),
          onTap: () {
            Navigator.pop(context);
            context.push(ViewCars.routeName);
          },
        ),
        ListTile(
          title: const Text('Manage Sub Owners').tr(),
          onTap: () {
            Navigator.pop(context);
            context.push(Choose_car.routeName);
          },
        ),
        // ListTile(
        //   title: const Text('Add sub owners').tr(),
        //   onTap: () {
        //     Navigator.pop(context);
        //     context.push(AddSubowner.routeName);
        //   },
        // ),
        ListTile(
          title: Text(
            "add_car_screen".tr(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.pop(context);
            context.push(Addcar.routeName);
          },
        ),
        ListTile(
          title: const Text('transfer_ownership').tr(),
          onTap: () {
            Navigator.pop(context);
            context.push(TransferOwner.routeName);
          },
        ),
        // ListTile(
        //   title: const Text('updateProfile').tr(),
        //   onTap: () {
        //     Navigator.pop(context);
        //     context.push(EditProfile.routeName);
        //   },
        // ),

        ListTile(
          title: const Text('reminder').tr(),
          onTap: () {
            Navigator.pop(context);
            context.push(ReminderScreen.routeName);
          },
        ),
        ListTile(
          title: const Text('history').tr(),
          onTap: () {
            Navigator.pop(context);
            context.push(ViewHistory.routeName);
          },
        ),
        // ListTile(
        //   title: Text("Test APP state"),
        //   onTap: () {
        //     Navigator.pop(context);
        //     context.push(TestScreen_nearbymechanics_and_create_rsa.routeName);
        //   },
        // ),
        ListTile(
          title: const Text('settings').tr(),
          onTap: () {
            Navigator.pop(context);
            context.push(SwitchLanguageScreen.routeName);
          },
        ),
        ListTile(
          title: const Text('viewOngoing').tr(),
          onTap: () {
            Navigator.pop(context);
            context.push(OngoingRequests.routeName);
          },
        ),
      ],
    ),
  );
}

//TODO: logical bug
// if the user pushed same page twice the back button will get him to same page
