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
import '../../widgets/reminder/MyInputField.dart';

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
  String? title;
  updateTitle(title) {
    this.title;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      // body: Stack(
      //   children: [
      //     SizedBox.expand(
      //       child: Image.network(
      //         ref.watch(userProvider).avatar ?? "SAD",
      //         fit: BoxFit.fill,
      //       ),
      //     ),
      //     DraggableScrollableSheet(
      //         minChildSize: 0.1,
      //         initialChildSize: 0.22,
      //         maxChildSize: 0.7,
      //         builder: (context, scrollController) {
      //           return SingleChildScrollView(
      //             controller: scrollController,
      //             child: Container(
      //               constraints: BoxConstraints(
      //                   maxHeight: MediaQuery.of(context).size.height,
      //                   minHeight: MediaQuery.of(context).size.height),
      //               color: Color(0xFFd1d9e6),
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 mainAxisAlignment: MainAxisAlignment.start,
      //                 children: [
      //                   Container(
      //                     child: Padding(
      //                       padding: const EdgeInsets.all(10.0),
      //                       child: Row(
      //                         mainAxisAlignment: MainAxisAlignment.center,
      //                         children: [
      //                           SizedBox(
      //                             height: 100,
      //                             width: 100,
      //                             child: CircleAvatar(
      //                                 backgroundImage: NetworkImage(
      //                                     ref.watch(userProvider).avatar ??
      //                                         "SAD")),
      //                           ),
      //                           SizedBox(
      //                             width: 16,
      //                           ),
      //                           Expanded(
      //                               child: Column(
      //                             crossAxisAlignment: CrossAxisAlignment.start,
      //                             children: [
      //                               Text(
      //                                 "Mohamed Hesham",
      //                                 overflow: TextOverflow.fade,
      //                                 style: TextStyle(
      //                                     color: Colors.grey[800],
      //                                     fontFamily: "Roboto",
      //                                     fontSize: 25,
      //                                     fontWeight: FontWeight.w700),
      //                               ),
      //                               Text(
      //                                 "Hesham@gamil.com",
      //                                 style: TextStyle(
      //                                     color: Colors.grey[600],
      //                                     fontFamily: "Roboto",
      //                                     fontSize: 16,
      //                                     fontWeight: FontWeight.w400),
      //                               ),
      //                               ElevatedButton(
      //                                 onPressed: () {
      //                                   context.push(EditProfile.routeName);
      //                                 },
      //                                 child: Text("Update Profile"),
      //                               )
      //                             ],
      //                           )),
      //                           Icon(
      //                             Icons.sms,
      //                             color: Colors.blue,
      //                             size: 40,
      //                           )
      //                         ],
      //                       ),
      //                     ),
      //                   ),
      //                   Container(
      //                     padding: EdgeInsets.all(32),
      //                     color: Color(0xFF193566),
      //                     child: Row(
      //                       crossAxisAlignment: CrossAxisAlignment.center,
      //                       children: [
      //                         Text(
      //                           "User Information",
      //                           overflow: TextOverflow.fade,
      //                           style: TextStyle(
      //                               color: Colors.white,
      //                               fontFamily: "Roboto",
      //                               fontSize: 40,
      //                               fontWeight: FontWeight.w700),
      //                         ),
      //                         // Icon(
      //                         //   Icons.info,
      //                         //   size: 25,
      //                         //   color: Colors.white,
      //                         // )
      //                       ],
      //                     ),
      //                   ),
      //                   Center(
      //                     child: Container(
      //                       padding: EdgeInsets.all(32),
      //                       child: Column(children: [
      //                         Text(
      //                           "About Me",
      //                           overflow: TextOverflow.fade,
      //                           style: TextStyle(
      //                               color: Colors.grey[800],
      //                               fontFamily: "Roboto",
      //                               fontSize: 28,
      //                               fontWeight: FontWeight.w700),
      //                         ),
      //                         Row(children: [
      //                           Text(("Email  "),
      //                               overflow: TextOverflow.fade,
      //                               style: TextStyle(
      //                                   color: Color(0xFF193566),
      //                                   fontFamily: "Roboto",
      //                                   fontSize: 25,
      //                                   fontWeight: FontWeight.w700)),
      //                           Text(
      //                             (ref.watch(userProvider).email ?? "wait"),
      //                             overflow: TextOverflow.fade,
      //                             style: TextStyle(
      //                                 color: Colors.black,
      //                                 fontFamily: "Roboto",
      //                                 fontSize: 25,
      //                                 fontWeight: FontWeight.w700),
      //                           ),
      //                         ]),
      //                         Row(children: [
      //                           Text(("Address  "),
      //                               overflow: TextOverflow.fade,
      //                               style: TextStyle(
      //                                   color: Color(0xFF193566),
      //                                   fontFamily: "Roboto",
      //                                   fontSize: 25,
      //                                   fontWeight: FontWeight.w700)),
      //                           Text(
      //                             (ref.watch(userProvider).address ?? "wait"),
      //                             overflow: TextOverflow.fade,
      //                             style: TextStyle(
      //                                 color: Colors.black,
      //                                 fontFamily: "Roboto",
      //                                 fontSize: 25,
      //                                 fontWeight: FontWeight.w700),
      //                           ),
      //                         ]),
      //                         Row(children: [
      //                           Text(("Phone  "),
      //                               overflow: TextOverflow.fade,
      //                               style: TextStyle(
      //                                   color: Color(0xFF193566),
      //                                   fontFamily: "Roboto",
      //                                   fontSize: 25,
      //                                   fontWeight: FontWeight.w700)),
      //                           Text(
      //                             (ref.watch(userProvider).phoneNumber ??
      //                                 "wait"),
      //                             overflow: TextOverflow.fade,
      //                             style: TextStyle(
      //                                 color: Colors.black,
      //                                 fontFamily: "Roboto",
      //                                 fontSize: 25,
      //                                 fontWeight: FontWeight.w700),
      //                           ),
      //                         ]),
      //                       ]),
      //                     ),
      //                   ),
      //                   // BottomNavigationBar(items: [
      //                   //   BottomNavigationBarItem(
      //                   //
      //                   //     icon: Icon(Icons.home),
      //                   //     label: "home",
      //                   //   ),
      //                   //   BottomNavigationBarItem(
      //                   //     icon: Icon(Icons.home),
      //                   //     label: "home",
      //                   //   )
      //                   // ])
      //                 ],
      //               ),
      //             ),
      //           );
      //         })
      //   ],
      // ),

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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              // Center(child: Text(ref.watch(userProvider).email ?? "wait")),
              // Center(
              //     child: Text(ref.watch(userProvider).phoneNumber ?? "wait")),
              // SizedBox(
              //   height: 30,
              // ),
              // Text(
              //   "User Information",
              //   style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              // Center(
              //   child: Row(children: [
              //     Text("Phone : ",
              //         style:
              //             TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              //     Text(ref.watch(userProvider).phoneNumber ?? "wait",
              //         style:
              //             TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              //   ]),
              // ),
              // Row(children: [
              //   Text("email : ",
              //       style:
              //           TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              //   Text(ref.watch(userProvider).email ?? "wait",
              //       style:
              //           TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              // ]),
              // Row(children: [
              //   Text("address : ",
              //       style:
              //           TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              //   Text(ref.watch(userProvider).address ?? "wait",
              //       style:
              //           TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              // ]),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.end,
              //     children: [
              //       RaisedButton(
              //         onPressed: () {
              //           context.push(EditProfile.routeName);
              //         },
              //         color: Colors.green,
              //         padding: EdgeInsets.symmetric(horizontal: 50),
              //         shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(20)),
              //         child: Text(
              //           "update profile",
              //           style: TextStyle(
              //               fontSize: 14,
              //               letterSpacing: 2.2,
              //               color: Colors.white),
              //         ),
              //       ),

              //     ],
              //   ),
              // )
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 16),
              //   child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Row(
              //           children: [
              //             Text(
              //               "email",
              //               style: TextStyle(
              //                   fontSize: 16, color: Color(0xFF193566)),
              //             ),
              //             SizedBox(
              //               width: 7,
              //             ),
              //             Icon(
              //               Icons.email,
              //               color: Color(0xFF193566),
              //             )
              //           ],
              //         ),
              //         SizedBox(
              //           height: 4,
              //         ),
              //         Text(ref.watch(userProvider).email ?? "wait",
              //             style: TextStyle(
              //                 fontSize: 25, fontWeight: FontWeight.w500)),
              //         SizedBox(
              //           height: 20,
              //         ),
              //         Row(
              //           children: [
              //             Text(
              //               "Phone",
              //               style: TextStyle(
              //                   fontSize: 18, color: Color(0xFF193566)),
              //             ),
              //             SizedBox(
              //               width: 5,
              //             ),
              //             Icon(
              //               Icons.phone,
              //               color: Color(0xFF193566),
              //             )
              //           ],
              //         ),
              //         SizedBox(
              //           height: 4,
              //         ),
              //         Text(ref.watch(userProvider).phoneNumber ?? "wait",
              //             style: TextStyle(
              //                 fontSize: 25, fontWeight: FontWeight.w500)),
              //         SizedBox(
              //           height: 20,
              //         ),
              //         Row(
              //           children: [
              //             Text(
              //               "Address",
              //               style: TextStyle(
              //                   fontSize: 20, color: Color(0xFF193566)),
              //             ),
              //             Icon(
              //               Icons.map,
              //               color: Color(0xFF193566),
              //             )
              //           ],
              //         ),
              //         SizedBox(
              //           height: 4,
              //         ),
              //         Text(ref.watch(userProvider).address ?? "wait",
              //             style: TextStyle(
              //                 fontSize: 25, fontWeight: FontWeight.w500)),
              //         SizedBox(
              //           height: 10,
              //         ),
              //         Padding(
              //           padding: EdgeInsets.symmetric(
              //             vertical: MediaQuery.of(context).size.height * 0.2,
              //           ),
              //           child: Align(
              //             alignment: FractionalOffset.bottomRight,
              //             child: RaisedButton(
              //               onPressed: () {
              //                 context.push(EditProfile.routeName);
              //               },
              //               color: Color(0xFF193566),
              //               shape: RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(20)),
              //               child: Text(
              //                 "update profile",
              //                 style: TextStyle(
              //                     fontSize: 14,
              //                     letterSpacing: 2.2,
              //                     color: Colors.white),
              //               ),
              //             ),
              //           ),
              //         ),
              //       ]),
              // )
              // Padding(
              //   padding: EdgeInsets.all(25),
              //   child: Container(
              //       height: 52,
              //       padding: const EdgeInsets.only(left: 14),
              //       margin: const EdgeInsets.only(top: 8),
              //       decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(20),
              //           color: Colors.grey[100],
              //           boxShadow: [
              //             BoxShadow(
              //               color: Colors.blueGrey,
              //               blurRadius: 2.0,
              //               spreadRadius: 0.0,
              //               offset: Offset(3, 0),
              //             ),
              //           ]),
              //       child: TextField(
              //         autofocus: false,
              //         cursorColor: Colors.blue,
              //         // controller: controller,
              //         style: TextStyle(
              //           fontSize: 15,
              //           fontWeight: FontWeight.w400,
              //           color: Colors.grey[900],
              //         ),
              //
              //         decoration: InputDecoration(
              //             border: InputBorder.none,
              //             focusedBorder: InputBorder.none,
              //             enabledBorder: InputBorder.none,
              //             // errorBorder: InputBorder.none,
              //             disabledBorder: InputBorder.none,
              //             // contentPadding: EdgeInsets.symmetric(vertical: 15),
              //             filled: true,
              //             enabled: false,
              //             hintStyle: TextStyle(
              //               fontSize: 14,
              //               fontWeight: FontWeight.w400,
              //               color: Colors.grey[600],
              //             ),
              //             hintText: "Type in your text",
              //             fillColor: Colors.white70),
              //       )),
              // ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: screenSize.width * 0.8),
                      child: Text("name"),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.grey[500],
                          ),
                          border: OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: TextStyle(
                              color: Colors.black, fontFamily: "WorkSansLight"),
                          filled: true,
                          enabled: false,
                          label: Text(ref.watch(userProvider).name ?? "wait",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black)),
                          fillColor: Colors.white70,
                          hintText: ref.watch(userProvider).name ?? "wait"),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: screenSize.width * 0.8),
                      child: Text("Email"),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.grey[500],
                          ),
                          border: OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: TextStyle(
                              color: Colors.black, fontFamily: "WorkSansLight"),
                          filled: true,
                          enabled: false,
                          label: Text(ref.watch(userProvider).email ?? "wait",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black)),
                          fillColor: Colors.white70,
                          hintText: ref.watch(userProvider).email ?? "wait"),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: screenSize.width * 0.8),
                      child: Text("Address"),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.place,
                            color: Colors.grey[500],
                          ),
                          border: OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: TextStyle(
                              color: Colors.black, fontFamily: "WorkSansLight"),
                          filled: true,
                          enabled: false,
                          label: Text(ref.watch(userProvider).address ?? "wait",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black)),
                          fillColor: Colors.white70,
                          hintText: ref.watch(userProvider).name ?? "wait"),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: screenSize.width * 0.8),
                      child: Text("Phone"),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.phone,
                            color: Colors.grey[500],
                          ),
                          border: OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: TextStyle(
                              color: Colors.black, fontFamily: "WorkSansLight"),
                          filled: true,
                          enabled: false,
                          label: Text(
                              ref.watch(userProvider).phoneNumber ?? "wait",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black)),
                          fillColor: Colors.white70,
                          hintText: ref.watch(userProvider).name ?? "wait"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF193566),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            context.push(EditProfile.routeName);
                          },
                          child: Text("Edit profile")),
                    )
                  ],
                ),
              ),
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
