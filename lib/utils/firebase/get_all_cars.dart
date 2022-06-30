import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/classes/models/car.dart';
import 'package:slahly/classes/provider/user_data.dart';
import 'package:slahly/main.dart';
import 'package:slahly/utils/constants.dart';

allCars(ref) async {
  ref.watch(userProvider.notifier).clearCars();
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

    for (var element in dataSnapshot.children) {
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
        Color temp;
        String tempColorStr = carsSnapshot.child("color").value.toString();
        if (tempColorStr.contains("(")) {
          tempColorStr = tempColorStr.substring(
              tempColorStr.indexOf("(") + 1, tempColorStr.indexOf(")"));
        }
        temp = Color(int.parse(tempColorStr));
        Car newCar = Car(
            noPlate: carsSnapshot.child("plate").value.toString(),
            model: carsSnapshot.child("model").value.toString(),
            noChassis: carsSnapshot.key.toString(),
            color: temp,
            carAccess: carAccess);
        print(newCar);
        ref.watch(userProvider.notifier).assignCar(newCar);

        print("all cars in SM${ref.watch(userProvider).cars},");
      });
    }
  });
}

Future<bool> isCarInConflict(String carNoChassis) async {
  DataSnapshot conflictSnapShot = await conflictRef.child(carNoChassis).get();
  print("saadasdasdasd${conflictSnapShot.value.toString()}");
  if (conflictSnapShot.value != null) {
    return true;
  }
  return false;
}

Future<bool> doesExistInRequest(String carNoChassis) async {
  print("Will check if this car is already in use ${carNoChassis}");
  return await getCarRequests(rsaRef, carNoChassis) &&
      await getCarRequests(ttaRef, carNoChassis) &&
      await getCarRequests(wsaRef, carNoChassis);
}

Future<bool> getCarRequests(
    DatabaseReference local, String carNoChassis) async {
  bool isCarAvailable = true;
  String tempStr = (local == wsaRef)
      ? "WSA"
      : (local == rsaRef)
          ? "rsa"
          : "tta";
  print("Will try ${carNoChassis} $tempStr");
  await local
      .orderByChild("carID")
      .equalTo(carNoChassis)
      .once()
      .then((event) async {
    DataSnapshot rsaDataSnapShot = event.snapshot;

    for (var element in rsaDataSnapShot.children) {
      RSAStates rsaState =
          RSA.stringToState(element.child("state").value.toString());
      print(rsaState);
      print(element.child("state").value.toString());
      if (rsaState != RSAStates.cancelled && rsaState != RSAStates.done) {
        print(
            "We found this car ${carNoChassis} in request state ${rsaState} == ${element.child("state").value.toString()} id:${element.key.toString()}");
        isCarAvailable = false;
      }
    }
  });
  print("The returen value is $isCarAvailable");
  return isCarAvailable;
}
