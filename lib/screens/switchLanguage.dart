import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:slahly/widgets/login_signup/roundedInput.dart';
class SwitchLanguageScreen extends StatefulWidget {
static final routeName = "/switchlanguage";
  @override
  _SwitchLanguageScreenState createState() => _SwitchLanguageScreenState();
}

class _SwitchLanguageScreenState extends State<SwitchLanguageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Center(
              child: Container(
                  height :double.infinity,
                  child:Column(
                    children: [
                      ElevatedButton(onPressed: (){

                        setState(() {
                        context.setLocale(Locale("ar"));
                        });
                      }, child: Text("Switch to Arabic")),
                      ElevatedButton(onPressed: (){
                        context.setLocale(Locale("en"));
                        setState(() {

                        });

                      }, child: Text("Switch to English")),
                      RounedInput(icon: Icons.adb_outlined, hint: "dont_have_account".tr(), fn: (){})
                    ],
                  )
              )
          ),
        )
    );
  }
}


