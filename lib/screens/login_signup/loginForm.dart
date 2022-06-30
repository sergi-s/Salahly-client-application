import 'package:flutter/material.dart';
import 'package:slahly/screens/homepage.dart';
import 'package:slahly/widgets/login_signup/Rounded_Bottom.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slahly/widgets/login_signup/Rounded_password.dart';
import 'package:slahly/widgets/login_signup/roundedInput.dart';
import 'package:slahly/classes/firebase/firebase.dart';

import 'package:slahly/utils/validation.dart';

class LoginForm extends StatefulWidget {
  LoginForm({
    Key? key,
    required this.size,
    required this.defaultLogin,
  }) : super(key: key);

  final Size size;
  final double defaultLogin;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String email = "";

  String password = "";

  FirebaseCustom fb = FirebaseCustom();

  updateEmail(String e) {
    email = e;
  }

  updatePassword(String pass) {
    password = pass;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size.width,
      height: widget.defaultLogin,
      //color: Color(0xFFd1d9e6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "welcome_back".tr(),
            // style: TextStyle(
            //               fontWeight: FontWeight.bold,
            //               fontSize: 24,
            //
            style: GoogleFonts.raleway(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Color(0xFF193566)),
          ),
          const SizedBox(height: 40),
          Image.asset(
            'assets/images/logodark.png',
            width: 300,
          ),
          //SvgPicture.assets('assets/images/icon.svg'),
          const SizedBox(height: 40),

          RounedInput(
            icon: Icons.email,
            hint: 'email'.tr(),
            fn: updateEmail,
          ),
          RounedPasswordInput(hint: 'password'.tr(), function: updatePassword),
          // const SizedBox(height: 10),
          // RoundedButton(
          //   title: 'login'.tr(),
          //   onPressedFunction: () async {
          //     if (!Validator.emailValidator(email)) {
          //       return ScaffoldMessenger.of(context).showSnackBar(
          //           const SnackBar(
          //               content: Text('Invalid Email!! Please try again')));
          //     }
          //     // if (!Validator.passValidator(password)) {
          //     //   return ScaffoldMessenger.of(context).showSnackBar(
          //     //       const SnackBar(
          //     //           content: Text('Invalid Password!! Please try again')));
          //     // }
          //     bool check = await fb.login(email, password);
          //     // bool check = await fb.login("mohamed@h.moh", "123456");
          //     // bool check = await fb.login("sergi@client.sergi", "1234567");
          //     if (check) {
          //       ScaffoldMessenger.of(context).showSnackBar(
          //           SnackBar(content: Text('Login_successful'.tr())));
          //       const SnackBar(content: Text('Login successful'));
          //       // context.go(TestUserCAR.routeName);
          //       context.go(HomePage.routeName);
          //     } else {
          //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //           content: Text('Account_invalid_please_try_again'.tr())));
          //     }
          //   },
          // ),
          SizedBox(height: 40),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            height: 40,
            child: RaisedButton(
              color: Color(0xFF193566),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onPressed: () async {
                if (!Validator.emailValidator(email)) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Invalid Email!! Please try again')));
                } else if (!Validator.passValidator(password)) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Invalid Password!! Please try again')));
                }

                // if (!Validator.passValidator(password)) {
                //   return ScaffoldMessenger.of(context).showSnackBar(
                //       const SnackBar(
                //           content: Text('Invalid Password!! Please try again')));
                // }
                bool check = await fb.login(email, password);
                // bool check = await fb.login("mohamed@h.moh", "123456");
                // bool check = await fb.login("sergi@client.sergi", "1234567");
                if (check) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Login_successful'.tr())));
                  const SnackBar(content: Text('Login successful'));
                  // context.go(TestUserCAR.routeName);
                  context.go(HomePage.routeName);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Account_invalid_please_try_again'.tr())));
                }
              },
              child: Text(
                "Login".tr(),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
//TODO: set user state management
