import "package:flutter/material.dart";
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:slahly/components/Rouned-Input.dart';
import 'package:slahly/components/Rounded_password.dart';
import 'package:slahly/screens/loginscreen.dart';
import 'package:slahly/widgets/getLocationComponent.dart';

import '../components/Rounded_Bottom.dart';

class SignUpScreen extends StatefulWidget {
  static final routeName = "/signupscreen";

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with SingleTickerProviderStateMixin {
  bool isLogin=true;
  late Animation<double> ContainerSize;
  Duration animationDuration = Duration(milliseconds:200);
  late AnimationController animationController;
  @override
  void initState(){
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    animationController=AnimationController(vsync: this,duration: animationDuration);

  }
  @override
  void dispose(){
    animationController.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    double viewinsert =MediaQuery.of(context).viewInsets.bottom;
    double defaultregstration=size.height-(size.height*0.1);
    double defaultlogin=size.height-(size.height*0.1);
    ContainerSize=Tween<double>(begin:size.height*0.1,end: defaultregstration).animate(  CurvedAnimation(parent: animationController, curve: Curves.linear));
    return Scaffold(

      body:Stack(
        children: [
          //cancel buttom
          AnimatedOpacity(
            opacity: isLogin? 0.0 : 1.0,
            duration: animationDuration,
            child: Align(
              alignment: Alignment.topCenter,
            child: Container(
              width: size.width,
              height: size.height*0.1,
              alignment: Alignment.bottomCenter,
              child: IconButton(
                //color: Colors.black,
                icon: Icon(Icons.close),
                onPressed: isLogin? null:(){
                  animationController.reverse();
                  setState(() {
                    isLogin=!isLogin;
                  });
                },
              ),
            ),
            ),
          ),
          //login form
          AnimatedOpacity(
            opacity: isLogin? 1.0:0.0,
            duration: animationDuration*4,
            child: Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Container(
                  width:size.width,
                  height: defaultlogin,
                  //color: Colors.blue,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome Back',
                        style:TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(height: 40),
                      Image.asset('assets/images/logo ta5arog 2.png'),
                      //SvgPicture.assets('assets/images/icon.svg'),
                      SizedBox(height: 40),
                      RounedInput(icon:Icons.email,hint:'username'),
                      RounedPasswordInput(hint: 'password',),
                      SizedBox(height: 10),
                      RoundedButtom(title: 'Login')
                    ],
                  ),
                ),
              ),
            ),
          ),

          //Registration
          AnimatedBuilder(
            animation: animationController,
            builder: (context,child){
              if(viewinsert ==0 && isLogin){
                return buildRegisterContainer();
              }else if(!isLogin){
                return buildRegisterContainer();
              }
              return Container();
            },

            ),
          AnimatedOpacity(
            opacity: isLogin? 0.0 : 1.0,
            duration: animationDuration*5,
            child: Visibility(
              visible: !isLogin,
              child: Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
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
                        RounedInput(icon:Icons.face,hint:'username'),
                        RounedInput(icon:Icons.email,hint:'Email'),
                        RounedPasswordInput(hint: 'password',),
                        RounedPasswordInput(hint: 'Confirm password',),
                        RounedInput(icon:Icons.phone,hint:'Phone'),
                        SizedBox(height: 10),
                        RoundedButtom(title: 'SignUp')
                      ],
                    ),
                  ),
                ),
              ),
          ),
          ),
        ],
      )

    );
  }
  Widget buildRegisterContainer(){
    return  Align(
      alignment: Alignment.bottomCenter,
      child: SingleChildScrollView(
      child: Container(
        width: double.infinity,
        height: ContainerSize.value,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(100),
            topRight: Radius.circular(100),
          ),
          color:Colors.blue[800],
        ),
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: !isLogin? null:(){
            animationController.forward();
            setState(() {
              isLogin=!isLogin;
            });
          },
          child:isLogin? Text(
            "Dont have an account? Signup",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ):null,

        ),
      ),
      ),
    );
  }
}









