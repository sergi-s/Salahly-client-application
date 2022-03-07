import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:slahly/screens/loginscreen.dart';
import 'package:slahly/screens/signupscreen.dart';

void main() async {
  // FlavorConfig(
  //   name: "DEVELOPMENT",
  //   color: Colors.red,
  //   location: BannerLocation.bottomStart,
  //   variables: {
  //     "counter": 5,
  //   },
  // );
  // FlavorConfig(
  //   name: "PRODUCTION",
  //   color: Colors.red,
  //   location: BannerLocation.bottomStart,
  //   variables: {
  //     "counter": 6,
  //   },
  // );
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: Locale('en'),
        child: MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
          SignUpScreen().routeName:(context)=>SignUpScreen(),
        LoginScreen().routeName:(context)=>LoginScreen(),
      },
      initialRoute: SignUpScreen().routeName,
    );
  }
}
