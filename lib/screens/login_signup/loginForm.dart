import 'package:flutter/material.dart';
import 'package:slahly/screens/myLocation/getLocationComponent.dart';
import 'package:slahly/widgets/login_signup/Rounded_Bottom.dart';
import 'package:slahly/widgets/login_signup/Rounded_password.dart';
import 'package:slahly/widgets/login_signup/Rouned-Input.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
    required this.size,
    required this.defaultlogin,
  }) : super(key: key);

  final Size size;
  final double defaultlogin;

  @override
  Widget build(BuildContext context) {
    return  Container(
          width: size.width,
          height: defaultlogin,
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
              SizedBox(height: 40),
              Image.asset('assets/images/logo ta5arog coloredsalahli.png',width:300,),
              //SvgPicture.assets('assets/images/icon.svg'),
              SizedBox(height: 40),
              RounedInput(icon: Icons.email, hint: 'username'.tr()),
              RounedPasswordInput(
                hint: 'password'.tr(),
              ),
              SizedBox(height: 10),
              RoundedButton(
                title: 'login'.tr(),
                onPressedFunction: (){
                },
              )
            ],
          ),
        );

  }
}
