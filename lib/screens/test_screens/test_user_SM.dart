import 'dart:io';
import 'package:firebase_database/firebase_database.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:slahly/classes/models/client.dart';
import "package:slahly/classes/provider/user_data.dart";
import 'package:slahly/classes/models/car.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:slahly/main.dart';
import 'package:slahly/screens/roadsideassistance/searching_mechanic_provider_screen.dart';

class TestUserSM extends StatefulWidget {
  static const String routeName = "/testuserscreen";

  @override
  _State createState() => _State();
}

class _State extends State<TestUserSM> {
  @override
  String? _imageUrl;

  void initState() {
    super.initState();
    var ref = FirebaseStorage.instance
        .ref()
        .child("users")
        .child("profile_picture")
        .child(FirebaseAuth.instance.currentUser!.uid);
    ref.getDownloadURL().then((loc) => setState(() => _imageUrl = loc));
    setState(() {
      fetch();
    });
  }

  DatabaseReference user = dbRef.child("users");

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailyController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  File? _image;
  String? name;
  String? email;
  String? phone;
  File? url;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit profile"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: (_image != null) ? FileImage(_image!) : null,
          ),
          InkWell(
            onTap: chooseimage,
            child: Icon(
              Icons.image,
              size: 48,
            ),
          ),
          CircleAvatar(
            backgroundImage: NetworkImage("getImage()"),
          ),

          SizedBox(height: 20),
          // CircleAvatar(
          //   backgroundImage: NetworkImage(getImage()),
          // ),

          // CircleAvatar(
          //     child: _imageUrl == null
          //         ? Image.asset(
          //             'icons/default_profile_icon.png',
          //             height: 110.0,
          //           )
          //         : getImage()),
          SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                updateProfile(context);
              },
              child: Text("update profile")),
          ElevatedButton(
              onPressed: () {
                uploadimage();
              },
              child: Text("upload image")),
          ElevatedButton(
              onPressed: () {
                getImage();
              },
              child: Text("press")),
          ElevatedButton(
              onPressed: () {
                fetch();
              },
              child: Text("show")),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: "name"),
          ),
          TextField(
            controller: emailyController,
            decoration: const InputDecoration(hintText: 'Email'),
          ),
          TextField(
            controller: phoneController,
            decoration: const InputDecoration(hintText: 'phone'),
          ),
          TextField(
            controller: addressController,
            decoration: const InputDecoration(hintText: 'address'),
          ),
          Text(name ?? "wait"),
          Text(phone ?? "wait"),
          Text(email ?? "wait")
        ],
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
        }
      });
    });

    print(firebaseuser!.email);
    print(firebaseuser.displayName);
  }

  getImage() async {
    var ref = FirebaseStorage.instance
        .ref()
        .child("users")
        .child("profile_picture")
        .child(FirebaseAuth.instance.currentUser!.uid +
            "_" +
            basename(_image!.path));
    var location = await ref.getDownloadURL();
    var loc = location.toString();
    print("boooooo");
    print(location.toString());

    return loc;
  }

  updateProfile(BuildContext context) async {
    final firebaseuser = await FirebaseAuth.instance.currentUser;
    Map<String, dynamic> map = Map();

    map['name'] = nameController.text;
    map['address'] = addressController.text;
    map['phoneNumber'] = phoneController.text;
    map['email'] = emailyController.text;
    firebaseuser?.updateEmail(emailyController.text);
    firebaseuser?.updateDisplayName(nameController.text);

    // firebaseuser?.updatePhoneNumber(phoneController);

    await user
        .child("clients")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .update(map);
  }

  chooseimage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    print("filattoooo" + image!.path);
    setState(() {
      _image = File(image.path);
    });
    print(_image);
  }

  Future<String> uploadimage() async {
    // String filepath = basename(file.path);
    TaskSnapshot taskSnapshot = await FirebaseStorage.instance
        .ref()
        .child("users")
        .child("profile_picture")
        .child(FirebaseAuth.instance.currentUser!.uid +
            "_" +
            basename(_image!.path))
        .putFile(_image!);
    var url = await taskSnapshot.ref.getDownloadURL();
    // print("ahoo");
    // print(url.toString());

    return url;
  }
}

//TODO remove this page later
//It is just for testing purposes
class TestUserCAR extends ConsumerWidget {
  static const String routeName = "/testcarscreen";

  final TextEditingController carModelController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController plateController = TextEditingController();
  final TextEditingController chasisController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Client car = ref.watch(userProvider);
    final userNotifier = ref.watch(userProvider.notifier);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 50),
            TextField(
              controller: carModelController,
              decoration: const InputDecoration(hintText: 'carModel'),
            ),
            TextField(
              controller: yearController,
              decoration: const InputDecoration(hintText: 'year Controller'),
            ),
            TextField(
              controller: plateController,
              decoration: const InputDecoration(hintText: 'plate'),
            ),
            TextField(
              controller: chasisController,
              decoration: const InputDecoration(hintText: 'chassis'),
            ),
            TextField(
              controller: numberController,
              decoration: const InputDecoration(hintText: 'number'),
            ),

            ElevatedButton(
                onPressed: () {
                  userNotifier.assignCar(Car(
                      noPlate: plateController.text,
                      model: carModelController.text,
                      noChassis: chasisController.text,
                      id: numberController.text,
                      carAccess: CarAccess.owner));
                },
                child: const Text("add car")),
            ElevatedButton(
                onPressed: () {
                  userNotifier.removeCar(car.cars[0]);
                },
                child: const Text("removeeee")),
            const SizedBox(height: 50),
            Text(car.cars.toString()),
            ///////////////////////////////////////////////////////////////////
            // Text(user.name ?? "NON"), //ME
            // Text(user.phoneNumber ?? "NON"), //HESHAM
            //
            // ElevatedButton(
            //     onPressed: () => {userNotifier.setName("Sergi")},
            //     child: const Text("Change name to sergi")),

            // ElevatedButton(
            //     onPressed: () => {userNotifier.setPhoneNumber("Hesham")},
            //     child: const Text("Change phoneNumber to Hesham")),
          ],
        ),
      ),
    );
  }

  owner(ref) async {
    Client user = ref.watch(userProvider);

    DatabaseReference reference = dbRef.child("users");
    await reference
        .child("clients")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("cars")
        .set({"type": "user.cars."});
  }
}
////user profile
