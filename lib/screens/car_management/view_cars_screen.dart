import '../../classes/provider/user_data.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../classes/models/car.dart';
import '../../classes/provider/user_data.dart';
import '../../main.dart';

class ViewCars extends StatelessWidget {
  static const routeName = "/viewcars";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ViewCards(),
    );
  }
}

class ViewCards extends ConsumerStatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends ConsumerState<ViewCards> {
  @override
  void initState() {
    allCars();
    super.initState();
  }

  List plate = [];
  List year = [];
  List model = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: model.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                leading: Text(
                    ref.watch(userProvider).cars[index].noChassis.toString()),
                trailing: Text(
                  model[index].toString(),
                  style: TextStyle(color: Colors.green, fontSize: 15),
                ),
                title: Text("List item $index"));
          }),
    );
  }

  allCars() async {
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
          setState(() {
            plate.add(carsSnapshot.child("plate").value.toString());
            model.add(carsSnapshot.child("model").value.toString());
            year.add(carsSnapshot.child("year").value.toString());

            print(plate);
            print(model);
            print(year);
          });
        });
      });
    });
  }
}
