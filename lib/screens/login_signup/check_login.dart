import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:slahly/screens/homepage.dart';
import 'package:slahly/screens/login_signup/signupscreen.dart';

class CheckLogin extends ConsumerWidget {
  const CheckLogin({Key? key}) : super(key: key);
  static const routeName = "/checklogin";

  _checkLogin(BuildContext context, ref) async {
    User? user = await FirebaseAuth.instance.currentUser;
    if (user == null) {
      context.go(LoginSignupScreen.routeName);
    } else {
      context.go(HomePage.routeName);
    }
  }

  @override
  Widget build(BuildContext context, ref) {
    _checkLogin(context, ref);
    return Scaffold(body: Text("Checking_logged_in_user_error".tr()));
  }
}
