import "package:flutter/material.dart";
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:slahly/screens/loginscreen.dart';

class SignUpScreen extends StatelessWidget {
  static final routeName = "/signupscreen";

  @override
  Widget build(BuildContext context) {
    context.locale = Locale('en');
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Container(
              width: 500,height: 200,color: Colors.deepOrange,
              child: ElevatedButton(onPressed: (){
                context.go(LoginScreen.routeName);
              },child: Text("Press me"),),
            )
            // Form(
            //   child: Column(
            //     children: [
            //       TextFormField(
            //         validator: (String) {
            //           //nullable string
            //           //email validation
            //         },
            //       ),
            //       TextFormField(
            //         validator: (String) {
            //           //nullable string
            //           //password validation
            //         },
            //       ),
            //     ],
            //   ),
            // ),
            // ElevatedButton(
            //   onPressed: () {},
            //   child: Text('presshere'.tr()),
            // ),
          ],
        ),
      ),
    );
  }
}
