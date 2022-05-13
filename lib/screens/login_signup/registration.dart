import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slahly/classes/firebase/firebase.dart';
import 'package:slahly/classes/models/client.dart';
import 'package:slahly/utils/validation.dart';
import 'package:slahly/widgets/login_signup/Registration_TextField.dart';
import 'package:slahly/widgets/login_signup/Rounded_Bottom.dart';

import '../homepage.dart';

class Registration extends StatelessWidget {
  static const routeName = "/registrationscreen";

  Registration({
    Key? key,
    required this.emailObj,
  }) : super(key: key);
  final String emailObj;
  Validator validation = Validator();
  FirebaseCustom fb = FirebaseCustom();

  //late TextEditingController emailController = TextEditingController();
  String username = "";
  String phoneNumber = "";
  String address = "";
  String age = "";

  // String gender = "";

  updateUserName(String u) {
    username = u;
  }

  updatePhoneNumber(String pn) {
    phoneNumber = pn;
  }

  updateAddress(String adr) {
    address = adr;
  }

  // updateage(String age) {
  //   this.age=age;
  // }
  // updategender(String g) {
  //  gender=g;
  // }
  registerOnPress(BuildContext context) async {
    // if (!Validator.usernameValidator(username)) {
    //   return ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //           content: Text('Invalid username!! Please try again')));
    // }
    // if (!Validator.phoneValidator(phonenumber)) {
    //   return ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //           content: Text('Invalid phonenumber!! Please try again')));
    // }
    // if (!Validator.ageValidator(age)) {
    //   return ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //           content:
    //           Text('Invalid age!! Please try again')));
    // }
    Client client = Client(
        name: username,
        email: emailObj,
        address: address,
        phoneNumber: phoneNumber,
        subscription: SubscriptionTypes.silver);

    bool check = await fb.registration(client);
    if (check) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Sucessfully'.tr())));
      context.go(HomePage.routeName);
    } else {
      return ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed_to_Register'.tr())));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFd1d9e6),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xFF193566),
        title: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Image.asset(
            'assets/images/logo ta5arog white car.png',
            fit: BoxFit.contain,
            height: 32,
          ),
        ]),
      ),
      body: Stack(children: [
        CustomPaint(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          painter: HeaderCurvedContainer(),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Registration".tr(),
                style: const TextStyle(
                  fontSize: 30,
                  letterSpacing: 1.5,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SingleChildScrollView(
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 150),
              height: MediaQuery.of(context).size.height * 0.55,
              width: MediaQuery.of(context).size.width,
              // decoration: BoxDecoration(
              //     color: Color(0xFFd1d9e6),
              //   borderRadius: BorderRadius.circular(30), //border corner radius
              //   boxShadow:[
              //     BoxShadow(
              //       color: Colors.grey.withOpacity(0.5), //color of shadow
              //       spreadRadius: 5, //spread radius
              //       blurRadius: 7, // blur radius
              //       //offset: Offset(0, 2), // changes position of shadow
              //
              //     ),
              //
              //   ],
              // ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SizedBox(height:180),
                    Registration_Input(
                      hintText: 'Username'.tr(),
                      icon: Icons.face,
                      fn: updateUserName,
                    ),
                    Registration_Input(
                        hintText: 'phone_number'.tr(),
                        icon: Icons.phone,
                        fn: updatePhoneNumber),
                    Registration_Input(
                      hintText: 'Address'.tr(),
                      icon: Icons.location_on,
                      fn: updateAddress,
                    ),
                    //Registration_Input(hintText: 'Age', icon: Icons.date_range,fn:updateage),
                    //DatePicker(hintText: "Birthdate", icon:Icons.date_range, fn: updateage),
                    // Registration_Input(hintText: 'Gender', icon: Icons.transgender,fn: updategender,),
                    const SizedBox(height: 10),
                    RoundedButton(
                      title: "Register".tr(),
                      onPressedFunction: () async {
                        registerOnPress(context);
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = const Color(0xFF193566);
    Path path = Path()
      ..relativeLineTo(0, 90)
      ..quadraticBezierTo(size.width / 2, 150, size.width, 90)
      ..relativeLineTo(0, -90)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
