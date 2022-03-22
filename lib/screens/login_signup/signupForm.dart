import 'package:flutter/material.dart';
import 'package:slahly/classes/models/client.dart';
import 'package:slahly/screens/myLocation/getLocationComponent.dart';
import 'package:slahly/widgets/login_signup/Rounded_Bottom.dart';
import 'package:slahly/widgets/login_signup/Rounded_password.dart';
import 'package:slahly/widgets/login_signup/roundedInput.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:slahly/utils/validation.dart';
import 'package:slahly/classes/firebase/firebase.dart';
class SignUpForm extends StatelessWidget {
  SignUpForm({
    Key? key,
    required this.defaultlogin,
  }) : super(key: key);

  final double defaultlogin;
  Validator validation =Validator();
  FirebaseCustom fb=FirebaseCustom();

  //late TextEditingController emailController = TextEditingController();
  String email = "";
  String password = "";
  String confirmpassword = "";

  updateEmail(String e) {
    email = e;
    print("ana ana ana moza" + email);
  }

  updatepassword(String pass) {
    password = pass;
  }

  updateconfirmpassword(String confpass) {
    confirmpassword = confpass;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: defaultlogin,
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
          SizedBox(height: 40),
          Image.asset('assets/images/logo ta5arog 2.png'),
          //SvgPicture.assets('assets/images/icon.svg'),
          SizedBox(height: 40),
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
            hint: 'password'.tr(),function: updatepassword,
          ),
          RounedPasswordInput(
            hint: 'confirm_password'.tr(), function:updateconfirmpassword,
          ),
          //RounedInput(icon: Icons.phone, hint: 'phone_number'.tr(), fn:updatePhonenumber,),
          SizedBox(height: 10),
          RoundedButton(
            title: 'sign_up'.tr(),
            onPressedFunction: ()async{
              if(!Validator.emailValidator(email)){
                return  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid Email!! Please try again')));
              }
              if(!Validator.passValidator(password)){
                return  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid Password!! Please try again')));
              }
              if (confirmpassword!=password){
                return  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid Confirmation!! Please try again')));
              }
            bool check =await fb.signup(email, password);
              if(check){
                return ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Account is Created Sucessfully ')));
              }else return ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Account is Already Used!!')));
            },
          ),
        ],
      ),
    );
  }
}
