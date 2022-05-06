import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:slahly/screens/allScreens.dart';
import 'package:slahly/screens/car_management/add_car_screen.dart';
import 'package:slahly/screens/car_management/view_cars_screen.dart';
import 'package:slahly/screens/history_management/view_history.dart';
import 'package:slahly/screens/homepage.dart';
import 'package:slahly/screens/login_signup/signupscreen.dart';
import 'package:slahly/screens/test_screens/testscreen_foula.dart';

class CheckLogin extends StatelessWidget {
  const CheckLogin({Key? key}) : super(key: key);
  static const routeName = "/checklogin";
  _checkLogin(BuildContext context) async {
    User? user = await FirebaseAuth.instance.currentUser;
    if (user == null) {
      context.go(LoginSignupScreen.routeName);
    } else {
      context.go(HomePage.routeName);
    }
  }
  @override
  Widget build(BuildContext context) {
    _checkLogin(context);
    return Scaffold(body: Text("Checking_logged_in_user_error".tr()));
  }
}
