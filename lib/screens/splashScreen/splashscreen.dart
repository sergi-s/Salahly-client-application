import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:slahly/screens/allScreens.dart';
import 'package:slahly/screens/login_signup/signupscreen.dart';

class SplashScreen extends StatefulWidget {
  //ThemeData(),
  static final routeName = "/splashcreen";
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>with TickerProviderStateMixin {

  @override
 void initState(){
   super.initState();
   _navigatetohome();
 }

 late final AnimationController _logoController = AnimationController(
   duration: const Duration(seconds: 8),
   vsync: this,
 )..forward();
//second image
  late final AnimationController _carController = AnimationController(
    duration: const Duration(seconds:2),
    vsync: this,
  )..forward();
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(1.5, 0.0),
  ).animate(CurvedAnimation(
    parent: _logoController,
    curve: Curves.elasticIn,
  ));

//

 @override
 void dispose() {
   _logoController.dispose();
   _carController.dispose();
   super.dispose();
 }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double height =size.height;
    const double smallLogo = 5;
    const double bigLogo =480;
    //second image

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size biggest = constraints.biggest;

        return Container(
          alignment: Alignment.center,
          // height: double.infinity,
           width: double.infinity,
          color: Color( 0xFF193566),
          child: Stack(
            //alignment: Alignment.center,
            children: <Widget>[
              PositionedTransition(
                rect: RelativeRectTween(
                  begin: RelativeRect.fromSize(
                      const Rect.fromLTWH(0,0 , smallLogo, smallLogo),
                      biggest),
                  //Rect.fromLTWH(120, 100, smallLogo, smallLogo), biggest),
                  end: RelativeRect.fromSize(
                      Rect.fromLTWH(biggest.width-bigLogo,0,bigLogo, bigLogo),biggest),
                ).animate(CurvedAnimation(
                  parent: _logoController,

                  curve: Curves.bounceIn,
                )),

                child:  Center(

                  child: Padding(//50,0
                      padding: const EdgeInsetsDirectional.fromSTEB(90, 0, 0,0),
                      child:Image.asset('assets/images/logo ta5arog white salahli.png')),

                ),
              ),
              //second image
              //
        SlideTransition(
        position: _offsetAnimation,
        child:  Padding(//300,40
        padding: EdgeInsets.symmetric(vertical: 300,horizontal:70),
        child:Image.asset('assets/images/logo ta5arog white car.png',width:100,),
        ),
        ),
            ],
          ),
        );
      },
    );




  }


 _navigatetohome()async{
   await Future.delayed(Duration(seconds:9),(){});
   // Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>SignUpScreen()));
   context.go(AllScreens.routeName);
   //TODO check already signed in
 }
}


//Scaffold(
//       backgroundColor: Color(0xFF193566),
//       body: Center(
//         child: Container(
//           child: Image.asset('assets/images/logo ta5arog 2.png'),
//
//         ),
//       ),
//     );
//   }
//  // Color palette :
//  // #ffffff white
//  // 0xFFd1d9e6 grey
//  // 0xFF97a7c3 color between blue and grey
//  // 0xFF193566 dark blue