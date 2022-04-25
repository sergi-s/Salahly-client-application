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
  final TextEditingController getuserController = TextEditingController();
  final TextEditingController caridController = TextEditingController();

  String? email = "7amda@gmail.com";
  String? subid;
  DatabaseReference user = dbRef.child("users");

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Client car = ref.watch(userProvider);
    final userNotifier = ref.watch(userProvider.notifier);
    String? email;
    String? subid;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                    owner(ref);
                  },
                  child: const Text("add car")),
              TextField(
                controller: getuserController,
                decoration: const InputDecoration(hintText: ' subowner email'),
              ),
              TextField(
                controller: caridController,
                decoration: const InputDecoration(hintText: 'Enter car id'),
              ),

              ElevatedButton(
                  onPressed: () {
                    getuser();
                  },
                  child: const Text("add subowner")),
              ElevatedButton(
                  onPressed: () {
                    getsubowner();
                  },
                  child: const Text("getsub")),

              ElevatedButton(
                  onPressed: () {
                    // userNotifier.removeCar(car.cars[0]);
                    delete();
                  },
                  child: const Text("removeeee")),
              const SizedBox(height: 50),
              // Text(car.cars.toString()),
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
      ),
    );
  }

  // Future<Map?> getuser() async {
  //   DatabaseReference users = await dbRef
  //       .child("users")
  //       .child("clients")
  //       .equalTo(getuserController)
  //       .once()
  //       .then((event) {
  //     final dataSnapshot = event.snapshot;
  //     print("read" + dataSnapshot.value.toString());
  //
  //     var data = dataSnapshot.value as Map;
  //     if (data != null) {}
  //     return;
  //   });

  getsubowner() async {
    DatabaseReference cars = await dbRef.child("cars");
    cars.child(caridController.text).child("subowners").once().then((event) {
      final dataSnapshot = event.snapshot;
      print("read" + dataSnapshot.value.toString());
    });
  }

  getuser() async {
    //final firebaseuser = await FirebaseAuth.instance.currentUser;
    // var method = await FirebaseAuth.instance
    //     .fetchSignInMethodsForEmail(getuserController.text);
    // var ids = await FirebaseAuth.instance.;
    // if (method.isNotEmpty) {
    //   print(ids.toString());
    // }
    // print("ahooo");
    // print(method);
    // method.contains(element)
    user
        .child("clients")
        .orderByChild("email")
        .equalTo(getuserController.text)
        .once()
        .then((event) {
      final dataSnapshot = event.snapshot;
      print("read" + dataSnapshot.value.toString());
      var x = dataSnapshot.value.toString();
      x.trim();
      var y = x.split(":");
      String z = y[0];
      String f = z.replaceAll("{", "");
      print(f);

      var data = dataSnapshot.value as Map;

      if (data != null) {
        email = data[f]["email"];
        subid = f;
      }
      print(subid);

      print(email);
    });
    String carid = "-N0W8Ye-5UazFU3odpgr";
    DatabaseReference cars = await dbRef
        .child("cars")
        .child(caridController.text)
        .child("subowners")
        .push();

    await cars.set({
      "subowner": {"id": subid}
    });
  }

  delete() async {
    String carid = "-N0WRuJWVguAPHUklZuE";
    DatabaseReference cars =
        await dbRef.child("cars").child(caridController.text);
    cars.remove();
  }

  owner(ref) async {
    Client car = ref.watch(userProvider);
    // final firebaseuser = await FirebaseAuth.instance.currentUser;
    DatabaseReference cars = await dbRef.child("cars").push();
    // String? key = dbRef.child("cars").push().key;
    String? key = cars.key;
    // String? key1 = cars.orderByChild("path").equalTo(value)
    // Map<String, dynamic> map = Map();
    // map['model'] = carModelController.text;
    // map['plate'] = plateController.text;
    // map['chasis'] = chasisController.text;
    // map['year'] = yearController.text;
    // Map<String, dynamic> map1 = Map();

    await cars.set({
      "model": carModelController.text,
      "plate": plateController.text,
      "year": yearController.text,
      "owner": FirebaseAuth.instance.currentUser!.uid
    });

    // await cars.set({
    //   "model": carModelController.text,
    //   "plate": plateController.text,
    //   "year": yearController.text,
    //   "owner": {
    //     "uid": FirebaseAuth.instance.currentUser!.uid,
    //     "type": "owner",
    //   }
    // });
    // cars.set(<String, Object>{
    //   "id": FirebaseAuth.instance.currentUser!.uid,
    //   "type": "owner",
    // });
    //   map1['type'] = "owner";
    //   DatabaseReference cars_user = await dbRef
    //       .child("cars_users")
    //       .child(FirebaseAuth.instance.currentUser!.uid)
    //       .child("$key");
    //   await cars_user.set(map1);
    // }
  }
}
////user profile
