import 'package:slahly/screens/signupscreen.dart';
import 'package:flutter/material.dart';
class splashscreen extends StatefulWidget {
  static final routeName = "/splashcreen";
  const splashscreen({Key? key}) : super(key: key);

  @override
  _splashscreenState createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {
 @override
 void initState(){
   super.initState();
   _navigatetohome();
 }
 _navigatetohome()async{
   await Future.delayed(Duration(milliseconds:50),(){});
   Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>SignUpScreen()));
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


