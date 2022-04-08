import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:slahly/screens/allScreens.dart';
import 'package:slahly/screens/homepage.dart';
import 'package:slahly/screens/login_signup/signupscreen.dart';
import 'package:slahly/screens/test_screens/testscreen_foula.dart';

class CheckLogin extends StatelessWidget {
  const CheckLogin({Key? key}) : super(key: key);
  static const routeName = "/checklogin";
  @override
  Widget build(BuildContext context) {
    // FirebaseAuth.instance.signOut();
    if (FirebaseAuth.instance.currentUser == null) {
      context.go(LoginSignupScreen.routeName);
    } else {
      context.go(AllScreens.routeName);
    }
    return const Scaffold(body: Text("Checking logged in user error"));
  }
}
