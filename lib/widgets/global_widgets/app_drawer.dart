import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:go_router/go_router.dart';
import 'package:slahly/screens/car_management/view_cars_screen.dart';
import 'package:slahly/screens/history_management/ongoing_requests.dart';
import 'package:slahly/screens/history_management/view_history.dart';
import 'package:slahly/screens/homepage.dart';
import 'package:slahly/screens/reminder/reminderScreen.dart';
import 'package:slahly/screens/switchLanguage.dart';
import 'package:slahly/screens/userMangament/view_cars_to_manage_subowners.dart';
import 'package:slahly/screens/userMangament/transferOwner.dart';

import 'package:slahly/screens/test_screens/testscreen_foula.dart';

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
          title: Text("Test APP state"),
          onTap: () {
            Navigator.pop(context);
            context.push(TestScreen_nearbymechanics_and_create_rsa.routeName);
          },
        ),
        ListTile(
          title: Text(
            'home'.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ).tr(),
          onTap: () {
            Navigator.pop(context);
            // context.push(Profile.routeName);
            context.push(HomePage.routeName);
          },
        ),
        Container(
          color: Colors.grey[200],
          child: ListTile(
            title: const Text(
              "Car",
              style: TextStyle(color: Colors.grey),
            ).tr(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: const Text('myCars').tr(),
                onTap: () {
                  Navigator.pop(context);
                  context.push(ViewCars.routeName);
                },
              ),
              // ListTile(
              //   title: Text(
              //     "add_car_screen".tr(),
              //     style: const TextStyle(fontWeight: FontWeight.bold),
              //   ),
              //   onTap: () {
              //     Navigator.pop(context);
              //     context.push(AddCar.routeName);
              //   },
              // ),
              ListTile(
                title: const Text('Manage_Ownership').tr(),
                onTap: () {
                  Navigator.pop(context);
                  context.push(Manage_Subowners.routeName);
                },
              ),
              ListTile(
                title: const Text('transfer_ownership').tr(),
                onTap: () {
                  Navigator.pop(context);
                  context.push(TransferOwner.routeName);
                },
              ),
            ],
          ),
        ),

        Container(
          color: Colors.grey[200],
          child: ListTile(
            title: const Text(
              "requests",
              style: TextStyle(color: Colors.grey),
            ).tr(),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: const Text('history').tr(),
                onTap: () {
                  Navigator.pop(context);
                  context.push(ViewHistory.routeName);
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
        ),

        ListTile(
          title: const Text('reminder').tr(),
          onTap: () {
            Navigator.pop(context);
            context.push(ReminderScreen.routeName);
          },
        ),
        ListTile(
          title: const Text('settings').tr(),
          onTap: () {
            Navigator.pop(context);
            context.push(SwitchLanguageScreen.routeName);
          },
        ),
      ],
    ),
  );
}

//TODO: logical bug
// if the user pushed same page twice the back button will get him to same page
