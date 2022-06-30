import "package:flutter/material.dart";
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:slahly/screens/login_signup/signupForm.dart';
import 'loginForm.dart';

class LoginSignupScreen extends StatefulWidget {
  static const routeName = "/signupscreen";

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen>
    with SingleTickerProviderStateMixin {
  bool isLogin = true;
  late Animation<double> containerSize;
  Duration animationDuration = const Duration(milliseconds: 900);
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    animationController =
        AnimationController(vsync: this, duration: animationDuration);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double viewInsert = MediaQuery.of(context).viewInsets.bottom;
    double defaultRegistration = size.height - (size.height * 0.1);
    double defaultLogin = size.height - (size.height * 0.1);
    containerSize = Tween<double>(
            begin: size.height * 0.1, end: defaultRegistration)
        .animate(
            CurvedAnimation(parent: animationController, curve: Curves.linear));
    return Scaffold(
        backgroundColor: const Color(0xFFd1d9e6),
        body: Stack(
          children: [
            //cancel button
            AnimatedOpacity(
              opacity: isLogin ? 0.0 : 1.0,
              duration: animationDuration,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: size.width,
                  height: size.height * 0.1,
                  alignment: Alignment.bottomCenter,
                  child: IconButton(
                    //color: Colors.black,
                    icon: const Icon(Icons.close),
                    onPressed: isLogin
                        ? null
                        : () {
                            animationController.reverse();
                            setState(() {
                              isLogin = !isLogin;
                            });
                          },
                  ),
                ),
              ),
            ),
            //login form
            AnimatedOpacity(
              opacity: isLogin ? 1.0 : 0.0,
              duration: animationDuration * 2,
              child: Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: LoginForm(size: size, defaultLogin: defaultLogin),
                ),
              ),
            ),

            // handling
            AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                if (viewInsert == 0 && isLogin) {
                  return buildRegisterContainer();
                } else if (!isLogin) {
                  return buildRegisterContainer();
                }
                return Container();
              },
            ),
            // Registration
            AnimatedOpacity(
              opacity: isLogin ? 0.0 : 1.0,
              duration: animationDuration * 1.8,
              child: Visibility(
                visible: !isLogin,
                child: Align(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: SignUpForm(defaultLogin: defaultLogin),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget buildRegisterContainer() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: containerSize.value,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(100),
              topRight: Radius.circular(100),
            ),
            color: Color(0xFF193566),
          ),
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: !isLogin
                ? null
                : () {
                    animationController.forward();
                    setState(() {
                      isLogin = !isLogin;
                    });
                  },
            child: isLogin
                ? Text(
                    "dont_have_account".tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
