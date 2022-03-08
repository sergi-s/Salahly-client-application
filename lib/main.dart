import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:slahly/MyApp.dart';

void main() async {
  print("Hello world");

  // FlavorConfig(
  //   name: "DEVELOPMENT",
  //   color: Colors.red,
  //   location: BannerLocation.bottomStart,
  //   variables: {
  //     "counter": 5,
  //     "database" : "localhost"
  //   },
  // );
  // FlavorConfig(
  //   name: "PRODUCTION",
  //   color: Colors.red,
  //   location: BannerLocation.bottomStart,
  //   variables: {
  //     "counter": 6,
  //     "database": "192.44.233.2/3306"
  //   },
  // );
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: Locale('en'),
        child: MyApp()),
  );
}
