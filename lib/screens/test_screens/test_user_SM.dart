import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slahly/classes/models/client.dart';
import "package:slahly/classes/provider/user_data.dart";
import 'package:slahly/classes/models/car.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:slahly/screens/roadsideassistance/searching_mechanic_provider_screen.dart';

//TODO remove this page later
//It is just for testing purposes
class TestUserSM extends ConsumerWidget {
  static const String routeName = "/testuserscreen";

  final TextEditingController CarNameController = TextEditingController();
  final TextEditingController CarmodelContorller = TextEditingController();
  final TextEditingController ClientEmailContorller = TextEditingController();

  Future client_email(email) async {
    // firebase.auth().fetchProvidersForEmail(email)
    // DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('users');
    DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('users');
    // usersRef.once().then((DataSnapshot snapshot) {
    //   Map<dynamic, dynamic> values = snapshot.value;
    // })
    usersRef.child("3").get().then((value) {
      print("asd ${value.value}");
    });
    // Map<dynamic, dynamic> map = docSnapshot.value![email];
    // DatabaseReference child = usersRef.child(email).get();
    // DatabaseReference child = ref.child()
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Client user = ref.watch(userProvider);
    final userNotifier = ref.watch(userProvider.notifier);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 50),
            // TextField(
            //   controller: CarNameController,
            //   decoration: const InputDecoration(hintText: 'no plate'),
            // ),
            // const SizedBox(height: 50),
            // TextField(
            //   controller: CarmodelContorller,
            //   decoration: const InputDecoration(hintText: 'Carmodel'),
            // ),
            TextField(
              controller: ClientEmailContorller,
              decoration: const InputDecoration(hintText: 'Email'),
            ),
            ElevatedButton(
                onPressed: () {
                  client_email(ClientEmailContorller.text);
                },
                child: Text("get user email")),
            Text("email")
            // ElevatedButton(
            //     onPressed: () {
            //       userNotifier.addCar(Car(
            //           noPlate: CarNameController.text,
            //           model: CarmodelContorller.text));
            //     },
            //     child: const Text("add car")),
            // ElevatedButton(
            //     onPressed: () {
            //       userNotifier.removeCar(user.cars[0]);
            //     },
            //     child: const Text("removeeee")),
            // const SizedBox(height: 50),
            // Text(user.cars.toString()),
            // ///////////////////////////////////////////////////////////////////
            // Text(user.name ?? "NON"), //ME
            // Text(user.phoneNumber ?? "NON"), //HESHAM
            //
            // ElevatedButton(
            //     onPressed: () => {userNotifier.setName("Sergi")},
            //     child: const Text("Change name to sergi")),
            //
            // ElevatedButton(
            //     onPressed: () => {userNotifier.setPhoneNumber("Hesham")},
            //     child: const Text("Change phoneNumber to Hesham")),
          ],
        ),
      ),
    );
  }
}
