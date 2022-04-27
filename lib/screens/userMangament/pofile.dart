import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:slahly/screens/userMangament/editProfile.dart';

import '../../classes/provider/user_data.dart';
import '../../main.dart';

class Profile extends ConsumerStatefulWidget {
  static const String routeName = "/profile";
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  void initState() {
    fetch();
    super.initState();
  }

  DatabaseReference user = dbRef.child("users");
  File? _image;
  String? phone, address, email, name, data;
  File? url;
  dynamic? path;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFd1d9e6),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xFF193566),
        title: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          // Image.asset(
          //   'assets/images/logo ta5arog white car.png',
          //   fit: BoxFit.contain,
          //   height: 32,
          // ),
        ]),
      ),
      body: CustomPaint(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView(
            children: [
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
                      // image: DecorationImage(
                      //     fit: BoxFit.cover, image: FileImage(_image!))),
                    ),
                    child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            ref.watch(userProvider).avatar ?? "SAD")),
                  ),
                ),
                onTap: () {},
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  ref.watch(userProvider).name ?? "wait",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              // Center(child: Text(ref.watch(userProvider).email ?? "wait")),
              // Center(
              //     child: Text(ref.watch(userProvider).phoneNumber ?? "wait")),
              SizedBox(
                height: 30,
              ),
              Text(
                "User Information",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Row(children: [
                  Text("Phone : ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                  Text(ref.watch(userProvider).phoneNumber ?? "wait",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                ]),
              ),
              Row(children: [
                Text("email : ",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                Text(ref.watch(userProvider).email ?? "wait",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              ]),
              Row(children: [
                Text("address : ",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                Text(ref.watch(userProvider).address ?? "wait",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              ]),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RaisedButton(
                      onPressed: () {
                        context.push(EditProfile.routeName);
                      },
                      color: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        "update profile",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        painter: HeaderCurvedContainer(),
      ),
    );
  }

  fetch() async {
    final firebaseuser = await FirebaseAuth.instance.currentUser;
    user
        .child("clients")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .once()
        .then((event) {
      final dataSnapshot = event.snapshot;
      print("read" + dataSnapshot.value.toString());
      var data = dataSnapshot.value as Map;
      setState(() {
        if (data != null) {
          email = data["email"];
          name = data["name"];
          phone = data["phoneNumber"];
          path = data["image"];
          address = data["address"];
          ref.watch(userProvider.notifier).assignEmail(email!);
          ref.watch(userProvider.notifier).assignName(name!);
          ref.watch(userProvider.notifier).assignPhoneNumber(phone!);
          ref.watch(userProvider.notifier).assignAvatar(path);
          ref.watch(userProvider.notifier).assignAddress(address!);
          print(ref.watch(userProvider).avatar);
        }
      });
    });
    print("here");
    print(path);
    print(firebaseuser!.email);
    print(firebaseuser.displayName);
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
