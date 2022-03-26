import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slahly/screens/login_signup/registration.dart';
import 'package:slahly/widgets/login_signup/Birthday_Input.dart';



class TryScreen extends StatelessWidget {
  static final routeName = "/tryscreen";
   TryScreen({Key? key}) : super(key: key);
  String gender = "";
  //Client client=Client(name: username, email: emailobj, subscription: subscriptionlient);

  updateusername(String u) {
    gender=u;

  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        Center(
          child: RaisedButton(
            child: Text("press Here!!!"),
          onPressed: (){  context.go(Registration.routeName, extra: "email@gmail.com");},
      ),
        ),
        //DatePicker(hintText: 'Birthday', icon:Icons.date_range, fn:updateusername)
      ],

    );
  }
}
