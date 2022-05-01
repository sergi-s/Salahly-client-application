import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../../classes/provider/user_data.dart';
import '../../main.dart';

class EditProfile extends ConsumerStatefulWidget {
  static const String routeName = "/editprofile";
  @override
  _State createState() => _State();
}

class _State extends ConsumerState<EditProfile> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailyController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  DatabaseReference user = dbRef.child("users");
  File? _image;
  String? phone, address, email, name, data;
  File? url;
  dynamic? path;
  String? emaily;
  String? passwordy;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFd1d9e6),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Text(
                "Edit Profile",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Stack(
                  children: [
                    GestureDetector(
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
                          backgroundImage:
                              (_image != null) ? FileImage(_image!) : null,
                        ),
                      ),
                      onTap: () {
                        chooseImage();
                      },
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 4),
                              color: Colors.green),
                          child: GestureDetector(
                            onTap: () {
                              final snackBar =
                                  SnackBar(content: Text('Image uploaded'));

                              try {
                                uploadImage(context);
                                ScaffoldMessenger.of(context)
                                    .showMaterialBanner(MaterialBanner(
                                  content:
                                      const Text('Image updated Successfully'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentMaterialBanner();
                                        },
                                        child: const Text('Dismiss')),
                                  ],
                                ));
                                // ScaffoldMessenger.of(context)
                                //     .showSnackBar(snackBar);
                              } catch (e) {}
                            },
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                    labelText: "Name",
                    hintText: ref.watch(userProvider).name ?? "wait",
                    hintStyle: TextStyle(color: Colors.black, fontSize: 14),
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
              TextField(
                controller: emailyController,
                decoration: InputDecoration(
                    labelText: "Email",
                    hintStyle: TextStyle(color: Colors.black, fontSize: 14),
                    hintText: ref.watch(userProvider).email ?? "wait",
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                    labelText: "Password",
                    hintStyle: TextStyle(color: Colors.black, fontSize: 14),
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                    hintText: ref.watch(userProvider).phoneNumber ?? "wait",
                    labelText: "Phone",
                    hintStyle: TextStyle(color: Colors.black, fontSize: 14),
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                    hintText: ref.watch(userProvider).address ?? "wait",
                    labelText: "Address",
                    hintStyle: TextStyle(color: Colors.black, fontSize: 14),
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlineButton(
                    onPressed: () {
                      context.pop();
                    },
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    highlightElevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.black),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      updateProfile(context);
                      updateAuth();
                    },
                    color: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      "Save",
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  chooseImage() async {
    //open gallery to upload image
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    print("filattoooo" + image!.path);
    setState(() {
      _image = File(image.path);
    });
    print(_image);
  }

  updateAuth() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    emaily = firebaseUser?.email;
    // EmailAuthProvider.credential(email: emaily!, password: '');

    // emailyController.text.isNotEmpty
    //     ? firebaseUser?.updateEmail(emailyController.text)
    //     : null;
    //
    // nameController.text.isNotEmpty
    //     ? firebaseUser?.updateDisplayName(nameController.text)
    //     : null;
    print("b4");
    if (await firebaseUser != null) {
      firebaseUser?.updateEmail(emailyController.text);
      firebaseUser?.updateDisplayName(nameController.text);
      firebaseUser?.updatePassword(passwordController.text);
      // signed in
    } else {}

    print("updated");
  }

  updateProfile(BuildContext context) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    Map<String, dynamic> map = {};

    map['name'] = nameController.text.isEmpty
        ? ref.watch(userProvider).name
        : nameController.text;

    map['address'] = addressController.text.isEmpty
        ? ref.watch(userProvider).address
        : addressController.text;

    map['phoneNumber'] = phoneController.text.isEmpty
        ? ref.watch(userProvider).phoneNumber
        : phoneController.text;

    map['email'] = emailyController.text.isEmpty
        ? ref.watch(userProvider).email
        : emailyController.text;

    await user
        .child("clients")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .update(map);
    fetch();
  }

  Future<String> uploadImage(BuildContext context) async {
    final snackBar = SnackBar(content: Text('Are you talkin\' to me?'));

    // String filepath = basename(file.path);
    //add image into fireStorage
    // final storage = await FirebaseStorage.instance.ref()
    //   ..child("users").child("profile_picture").child(
    //       FirebaseAuth.instance.currentUser!.uid +
    //           "_" +
    //           basename(_image!.path));
    // print("storage");
    // dynamic store = await storage.root;
    // print(store.toString());
    TaskSnapshot taskSnapshot = await FirebaseStorage.instance
        .ref()
        .child("users")
        .child("profile_picture")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .putFile(_image!);
    // TaskSnapshot snapshot = await FirebaseStorage.instance
    //     .ref()
    //     .child("users")
    //     .child("profile_picture")
    //     .child(FirebaseAuth.instance.currentUser!.uid +
    //         "_" +
    //         basename(_image!.path))
    //     .writeToFile(_image!);

    //get image for current user from fireStorage
    dynamic url = await taskSnapshot.ref.getDownloadURL();

    ref.watch(userProvider.notifier).assignAvatar(url);

    //RTDB
    user
        .child("clients")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .update({'image': url});
    print("reading");
    print(url.toString());
    // print("ahoo");
    // print(url.toString());

    return url;
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
        }
      });
    });
    print("here");
    print(path);
    print(firebaseuser!.email);
    print(firebaseuser.displayName);
  }
}
