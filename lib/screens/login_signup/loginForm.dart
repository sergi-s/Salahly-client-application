import 'package:flutter/material.dart';
import 'package:slahly/screens/car_management/add_car_screen.dart';
import 'package:slahly/screens/homepage.dart';
import 'package:slahly/screens/test_screens/test_user_SM.dart';
import 'package:slahly/screens/test_screens/testscreen_foula.dart';
import 'package:slahly/screens/userMangament/choose_car.dart';
import 'package:slahly/screens/userMangament/editProfile.dart';
import 'package:slahly/screens/userMangament/manageSubowner.dart';
import 'package:slahly/screens/userMangament/pofile.dart';
import 'package:slahly/screens/userMangament/transferOwner.dart';
import 'package:slahly/widgets/login_signup/Rounded_Bottom.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slahly/widgets/login_signup/Rounded_password.dart';
import 'package:slahly/widgets/login_signup/roundedInput.dart';
import 'package:slahly/classes/firebase/firebase.dart';

class LoginForm extends StatelessWidget {
  LoginForm({
    Key? key,
    required this.size,
    required this.defaultLogin,
  }) : super(key: key);

  final Size size;
  final double defaultLogin;
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
      width: size.width,
      height: defaultLogin,
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
            ),
          ),
          const SizedBox(height: 40),
          Image.asset(
            'assets/images/logo ta5arog coloredsalahli.png',
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
          const SizedBox(height: 10),
          RoundedButton(
            title: 'login'.tr(),
            onPressedFunction: () async {
              // if (!Validator.emailValidator(email)) {
              //   return ScaffoldMessenger.of(context).showSnackBar(
              //       const SnackBar(
              //           content: Text('Invalid Email!! Please try again')));
              // }
              // if (!Validator.passValidator(password)) {
              //   return ScaffoldMessenger.of(context).showSnackBar(
              //       const SnackBar(
              //           content: Text('Invalid Password!! Please try again')));
              // }
              // bool check = await fb.login(email, password);
              bool check = await fb.login("sergi@sergi.sergi", "123456");
              if (check) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Login_successful'.tr())));
                const SnackBar(content: Text('Login successful'));
                // context.go(TestUserCAR.routeName);
                context.go(AddCars.routeName);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Account_invalid_please_try_again'.tr())));
              }
            },
          )
        ],
      ),
    );
  }
}
//TODO: set user state management
