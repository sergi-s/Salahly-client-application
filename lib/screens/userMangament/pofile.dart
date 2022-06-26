import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:slahly/classes/firebase/firebase.dart';
import 'package:slahly/classes/provider/user_data.dart';
import 'package:slahly/main.dart';
import 'package:slahly/screens/userMangament/editProfile.dart';
import 'package:slahly/utils/firebase/get_user_data.dart';
import 'package:slahly/screens/login_signup/signupscreen.dart';

import '../../classes/provider/app_data.dart';
import '../../classes/provider/rsadata.dart';

class Profile extends ConsumerStatefulWidget {
  static const String routeName = "/profile";

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  @override
  void initState() {
    // fetch();
    // getUserData(ref);
    super.initState();
  }

  DatabaseReference user = dbRef.child("users");
  File? _image;
  String? phone, address, email, name, data;
  File? url;
  dynamic? path;
  String? title;

  updateTitle(title) {
    this.title;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final screenSize = MediaQuery.of(context).size;
    String pleaseHold = "${'pleaseHold'.tr()}...";

    return Scaffold(
      backgroundColor: const Color(0xFFd1d9e6),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xFF193566),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            context.pop();
          },
        ),
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(""),
          Text(
            "Profile".tr(),
            style: const TextStyle(
              fontSize: 22,
              letterSpacing: 1,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          Image.asset(
            'assets/images/logo white.png',
            fit: BoxFit.contain,
            height: 30,
          ),
        ]),
      ),
      body: CustomPaint(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView(
            children: [
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                child: Center(
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      border: Border.all(width: 4),
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.1),
                            offset: Offset(0, 10))
                      ],
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            ref.watch(userProvider).avatar ??
                                "https://via.placeholder.com/150")),
                  ),
                ),
                onTap: () {},
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  ref.watch(userProvider).name ?? pleaseHold,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 34,
                      color: Color(0xFF193566)),
                ),
              ),
              const SizedBox(height: 5),
              Card(
                elevation: 7,
                color: Color(0xFFd1d9e6),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(right: screenSize.width * 0.8),
                            child: const Text("Name").tr(),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.grey[500],
                                ),
                                border: const OutlineInputBorder(
                                  // width: 0.0 produces a thin "hairline" border
                                  // borderRadius:
                                  //     BorderRadius.all(Radius.circular(90.0)),
                                  borderSide: BorderSide.none,
                                ),
                                hintStyle: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: "WorkSansLight"),
                                filled: true,
                                enabled: false,
                                label: Text(
                                    ref.watch(userProvider).name ?? pleaseHold,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: Color(0xFF193566))),
                                fillColor: Colors.white70,
                                hintText:
                                    ref.watch(userProvider).name ?? pleaseHold),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(right: screenSize.width * 0.7),
                            child: const Text("email").tr(),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.grey[500],
                                ),
                                border: const OutlineInputBorder(
                                  // borderRadius:
                                  //     BorderRadius.all(Radius.circular(90.0)),
                                  borderSide: BorderSide.none,
                                ),
                                hintStyle: const TextStyle(
                                    color: Color(0xFF193566),
                                    fontFamily: "WorkSansLight"),
                                filled: true,
                                enabled: false,
                                label: Text(
                                    ref.watch(userProvider).email ?? pleaseHold,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: Color(0xFF193566))),
                                fillColor: Colors.white70,
                                hintText: ref.watch(userProvider).email ??
                                    pleaseHold),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(right: screenSize.width * 0.8),
                            child: const Text("Address").tr(),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.place,
                                  color: Colors.grey[500],
                                ),
                                border: const OutlineInputBorder(
                                  // width: 0.0 produces a thin "hairline" border
                                  // borderRadius:
                                  //     BorderRadius.all(Radius.circular(90.0)),
                                  borderSide: BorderSide.none,
                                ),
                                hintStyle: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: "WorkSansLight"),
                                filled: true,
                                enabled: false,
                                label: Text(
                                    ref.watch(userProvider).address ??
                                        pleaseHold,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: Color(0xFF193566))),
                                fillColor: Colors.white70,
                                hintText: ref.watch(userProvider).address ??
                                    pleaseHold),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(right: screenSize.width * 0.8),
                            child: const Text("Phone").tr(),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: Colors.grey[500],
                                ),
                                border: const OutlineInputBorder(
                                  // width: 0.0 produces a thin "hairline" border
                                  // borderRadius:
                                  //     BorderRadius.all(Radius.circular(90.0)),
                                  borderSide: BorderSide.none,
                                ),
                                hintStyle: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: "WorkSansLight"),
                                filled: true,
                                enabled: false,
                                label: Text(
                                    ref.watch(userProvider).phoneNumber ??
                                        pleaseHold,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: Color(0xFF193566))),
                                fillColor: Colors.white70,
                                hintText: ref.watch(userProvider).phoneNumber ??
                                    pleaseHold),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: 200,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: const Color(0xFF193566),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () {
                                  context.push(EditProfile.routeName);
                                },
                                child: const Text("editProfile").tr()),
                          ),
                          SizedBox(
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () async {
                                signOutConfirmation(context);
                              },
                              style: ElevatedButton.styleFrom(
                                primary: const Color(0xFF193566),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text("signOut").tr(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // painter: HeaderCurvedContainer(),
      ),
    );
  }

  void signOutConfirmation(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Container(
            alignment: Alignment.center,
            child: const Text("signOut").tr(),
          ),
          content: const Text("confirmSignOut").tr(),
          actions: [
            ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel").tr(),
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF193566),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                )),
            ElevatedButton(
                onPressed: () async {
                  ref.watch(rsaProvider.notifier).cancelRequest();
                  ref.watch(salahlyClientProvider.notifier).deAssignRequest();
                  FirebaseCustom().logout();
                  Navigator.pop(context);

                  context.go(LoginSignupScreen.routeName);
                },
                child: const Text("confirm").tr(),
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF193566),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ))
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
