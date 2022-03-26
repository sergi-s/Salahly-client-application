import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:slahly/routes.dart';
import 'package:easy_localization/easy_localization.dart';

class MyApp extends StatelessWidget {
  final _router = Routing().router;



  @override
  Widget build(BuildContext context) {
    context.setLocale(Locale("en"));
    // FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    // firebaseCloudMessaging_Listeners(_firebaseMessaging);



    return MaterialApp.router(
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}