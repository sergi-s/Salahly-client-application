import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slahly/screens/homepage.dart';
import 'package:slahly/screens/login_signup/registration.dart';
import 'package:slahly/widgets/login_signup/Rounded_Bottom.dart';
import 'package:slahly/widgets/login_signup/Rounded_password.dart';
import 'package:slahly/widgets/login_signup/roundedInput.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:slahly/utils/validation.dart';
import 'package:slahly/classes/firebase/firebase.dart';

class SignUpForm extends StatefulWidget {
  SignUpForm({
    Key? key,
    required this.defaultLogin,
  }) : super(key: key);

  final double defaultLogin;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  Validator validation = Validator();

  FirebaseCustom fb = FirebaseCustom();

  //late TextEditingController emailController = TextEditingController();
  String email = "";

  String password = "";

  String confirmPassword = "";

  updateEmail(String e) {
    email = e;
    print("ana ana ana moza" + email);
  }

  updatePassword(String pass) {
    password = pass;
  }

  updateConfirmPassword(String confPass) {
    confirmPassword = confPass;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: widget.defaultLogin,
      //color: Colors.blue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text(
          //   'Welcome Back',
          //   style:TextStyle(
          //     fontWeight: FontWeight.bold,
          //     fontSize: 24,
          //   ),
          // ),
          const SizedBox(height: 40),
          Image.asset('assets/images/logo ta5arog 2.png',width:300),
          //SvgPicture.assets('assets/images/icon.svg'),
          const SizedBox(height: 40),
          // RounedInput(
          //   icon: Icons.face,
          //   hint: 'username'.tr(),
          //   fn: updateUsername,
          // ),
          RounedInput(
            icon: Icons.email,
            hint: 'email'.tr(),
            fn: updateEmail,
          ),
          RounedPasswordInput(
            hint: 'password'.tr(),
            function: updatePassword,
          ),
          RounedPasswordInput(
            hint: 'confirm_password'.tr(),
            function: updateConfirmPassword,
          ),
          //RounedInput(icon: Icons.phone, hint: 'phone_number'.tr(), fn:updatePhonenumber,),
          // const SizedBox(height: 10),
          // RoundedButton(
          //   title: 'sign_up'.tr(),
          //   onPressedFunction: () async {
          //     if (!Validator.emailValidator(email)) {
          //       return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //           content: Text('Invalid_Email_Please_try_again'.tr())));
          //     }
          //     // if (!Validator.passValidator(password)) {
          //     //   return ScaffoldMessenger.of(context).showSnackBar(
          //     //       const SnackBar(
          //     //           content: Text('Invalid Password!! Please try again')));
          //     // }
          //     if (confirmPassword != password) {
          //       return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //           content:
          //               Text('Invalid_Confirmation_Please_try_again'.tr())));
          //     }
          //     bool check = await fb.signup(email, password);
          //     if (check) {
          //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //           content: Text('Account_is_Created_Sucessfully'.tr())));
          //     } else {
          //       return ScaffoldMessenger.of(context).showSnackBar(
          //           SnackBar(content: Text('Account_is_Already_Used'.tr())));
          //     }
          //     context.go(Registration.routeName, extra: email);
          //   },
          // ),
          SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            height: 40,
            child: RaisedButton(
              color: Colors.grey[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onPressed: ()async {
                if (!Validator.emailValidator(email)) {
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Invalid_Email_Please_try_again'.tr())));
                }
                // if (!Validator.passValidator(password)) {
                //   return ScaffoldMessenger.of(context).showSnackBar(
                //       const SnackBar(
                //           content: Text('Invalid Password!! Please try again')));
                // }
                if (confirmPassword != password) {
                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                      Text('Invalid_Confirmation_Please_try_again'.tr())));
                }
                bool check = await fb.signup(email, password);
                if (check) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Account_is_Created_Sucessfully'.tr())));
                } else {
                   ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Account_is_Already_Used'.tr())));
                }
                context.go(Registration.routeName, extra: email);
              },
              child: Text(
                "Sign Up".tr(),
                style: TextStyle(color: Color(0xFF193566)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
