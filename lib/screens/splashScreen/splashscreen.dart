import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:slahly/screens/login_signup/signupscreen.dart';

class SplashScreen extends StatefulWidget {
  static final routeName = "/splashcreen";
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
 @override
 void initState(){
   super.initState();
   _navigatetohome();
 }
 _navigatetohome()async{
   await Future.delayed(Duration(milliseconds:150),(){});
   // Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>SignUpScreen()));
   context.go(LoginSignupScreen.routeName);
   //TODO check already signed in
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Container(
          child: Image.asset('assets/images/logo1.png'),

        ),
      ),
    );
  }
}


