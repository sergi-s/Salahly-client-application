import "package:flutter/material.dart";
import 'package:easy_localization/easy_localization.dart';

class SignUpScreen extends StatelessWidget {
  final routeName = "signupscreen";

  @override
  Widget build(BuildContext context) {
    context.locale = Locale('en');
    return Scaffold(
      body: Center(
        child: Stack(
          children: [ElevatedButton(onPressed: (){
            
          }, child: Text('presshere'.tr()),)],
        ),
      ),
    );
  }
}
