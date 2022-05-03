import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:go_router/go_router.dart';

import 'package:slahly/screens/history_management/view_history.dart';
import 'package:slahly/screens/reminder/reminderScreen.dart';
import 'package:slahly/screens/switchLanguage.dart';
import 'package:slahly/screens/test_screens/test_user_SM.dart';
import 'package:slahly/screens/userMangament/editProfile.dart';
import 'package:slahly/screens/test_screens/testscreen_foula.dart';
import 'package:slahly/screens/userMangament/pofile.dart';

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
        ListTile(
          title: const Text(
            'home',
            style: TextStyle(fontWeight: FontWeight.bold),
          ).tr(),
          onTap: () {
            Navigator.pop(context);
            context.push(Profile.routeName);
          },
        ),
        ListTile(
          title: const Text(
            "Test Car Screen",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.pop(context);
            context.push(TestUserCAR.routeName);
          },
        ),
        ListTile(
          title: const Text('updateProfile').tr(),
          onTap: () {
            Navigator.pop(context);
            context.push(EditProfile.routeName);
          },
        ),
        ListTile(
          title: const Text("Mange Reminders").tr(),
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
        ListTile(
          title: const Text('reminder').tr(),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text("Test APP state"),
          onTap: () {
            Navigator.pop(context);
            context.push(TestScreen_nearbymechanics_and_create_rsa.routeName);
          },
        ),
        ListTile(
          title: Text('settings'.tr()),
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
