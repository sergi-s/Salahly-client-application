import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:slahly/MyApp.dart';
import 'package:slahly/classes/firebase/firebase.dart';

DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("user");

void main() async {
  FlavorConfig(
    name: "DEVELOPMENT",
    color: Colors.red,
    location: BannerLocation.bottomStart,
    variables: {
      "maps_api": 5,
    },
  );
  await FlavorConfig(
    name: "foula",
    color: Colors.greenAccent,
    // location: BannerLocation.bottomStart,
    variables: {
      "maps_api": "AIzaSyCuDZsh0WAgOreWhre_G2PlPJ61yLfGVc4"
      //await envVars['GOOGLE_MAPS_API']
      // "maps_api": await DotEnv().env['GOOGLE_MAPS_API'],
    },
  );
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  //await FirebaseCustom().connectToEmulator();
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child:
      // LocationComponent()
      MyApp(),
    ),
  );
}
