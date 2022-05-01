import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:slahly/classes/models/car.dart';
import 'package:slahly/classes/provider/user_data.dart';
import 'package:slahly/main.dart';

allCars(ref) async {
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
        print(carsSnapshot.child("year").value.toString());

        // Car car = new Car(
        //     noPlate: carsSnapshot.child("plate").value.toString(),
        //     model: carsSnapshot.child("model").value.toString(),
        //     noChassis: carsSnapshot.key.toString());
        // ref.watch(userProvider.notifier).assignCar(car);
        // setState(() {
        // plate.add(carsSnapshot.child("plate").value.toString());
        // model.add(carsSnapshot.child("model").value.toString());
        // year.add(carsSnapshot.child("year").value.toString());

        CarAccess carAccess = CarAccess.sub;
        if (carsSnapshot.child("owner").value.toString() ==
            FirebaseAuth.instance.currentUser!.uid) {
          carAccess = CarAccess.owner;
        }
        Car newCar = Car(
            noPlate: carsSnapshot.child("plate").value.toString(),
            model: carsSnapshot.child("model").value.toString(),
            noChassis: carsSnapshot.key.toString(),
            carAccess: carAccess);
        print(newCar);
        ref.watch(userProvider.notifier).assignCar(newCar);

        // print(plate);
        // print(model);
        // print(year);
        print("all cars in SM${ref.watch(userProvider).cars},");
        // });
      });
    });
  });
}
