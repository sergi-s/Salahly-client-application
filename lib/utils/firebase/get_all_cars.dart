import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

import 'package:slahly/classes/models/car.dart';
import 'package:slahly/classes/provider/user_data.dart';
import 'package:slahly/main.dart';

allCars(ref) async {
  Color? pickerColor = new Color(0xff443a49);
  String? color;
  print("GET ALL CARS");
  DatabaseReference carsUsers = dbRef.child("users_cars");
  DatabaseReference cars = dbRef.child("cars");
  carsUsers
      .child(FirebaseAuth.instance.currentUser!.uid)
      .orderByValue()
      .equalTo("true")
      .once()
      .then((event) {
    final dataSnapshot = event.snapshot;
    print("carssss${dataSnapshot.value.toString()}");

    dataSnapshot.children.forEach((element) {
      print(element.key.toString());
      cars.child(element.key.toString()).once().then((value) {
        final carsSnapshot = value.snapshot;
        print(carsSnapshot.value.toString());
        // print(
        //     "colooooooooooooor ${carsSnapshot.child("color").value.toString()}");
        // color = carsSnapshot.child("color").value.toString();
        // color = color.toString().substring(6);
        // color = color.toString().substring(0, color.toString().length - 1);
        // print("ahooooooooooooooooooooooo${color}");
        CarAccess carAccess = CarAccess.sub;
        if (carsSnapshot.child("owner").value.toString() ==
            FirebaseAuth.instance.currentUser!.uid) {
          carAccess = CarAccess.owner;
        }
        Car newCar = Car(
            noPlate: carsSnapshot.child("plate").value.toString(),
            model: carsSnapshot.child("model").value.toString(),
            noChassis: carsSnapshot.key.toString(),
            // color: carsSnapshot.child("color").value.toString() as Color,
            carAccess: carAccess);
        print(newCar);
        ref.watch(userProvider.notifier).assignCar(newCar);

        print("all cars in SM${ref.watch(userProvider).cars},");
      });
    });
  });
}
