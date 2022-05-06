import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:slahly/classes/models/car.dart';

import '../../classes/provider/user_data.dart';
import 'package:slahly/classes/models/client.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:slahly/utils/firebase/get_all_cars.dart';

import '../../main.dart';
import 'addCars.dart';

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
    allCars(ref);
    super.initState();
  }

  List plate = [];
  List year = [];
  List model = [];

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: ListView.builder(
    //       itemCount: ref.watch(userProvider).cars.length,
    //       itemBuilder: (BuildContext context, int index) {
    //         return ListTile(
    //             leading: Text(
    //                 ref.watch(userProvider).cars[index].noPlate.toString()),
    //             trailing: Text(
    //               ref.watch(userProvider).cars[index].model.toString() +
    //                   "\t" +
    //                   ref.watch(userProvider).cars[index].carAccess.toString(),
    //               style: TextStyle(color: Colors.green, fontSize: 15),
    //             ),
    //             title: Text("List item $index"));
    //       }),
    return Scaffold(
        backgroundColor: const Color(0xFFd1d9e6),
        appBar: AppBar(
          automaticallyImplyLeading: true,
          elevation: 0.0,
          backgroundColor: const Color(0xFF193566),
          title: Padding(
            padding: const EdgeInsets.only(right: 40),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [Text("View Cars")]),
          ),
        ),
        body: CustomPaint(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: const Color(0xFFd1d9e6),
            ), // red as border color
            child: SafeArea(
                child: AnimationLimiter(
              child: ListView.builder(
                  itemCount: ref.watch(userProvider).cars.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 6,
                      margin: EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            new BoxShadow(
                              blurRadius: 10.0,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(8.0),
                          color: const Color(0xFFd1d9e6),
                        ),
                        child: SingleChildScrollView(
                          child: GestureDetector(
                            onTap: () {
                              print('welcome'.tr());
                            },
                            child: ListTile(
                              leading: GestureDetector(
                                onTap: () {
                                  print("hiiii");

                                  deleteCarAllUsers(index);
                                },
                                child: CircleAvatar(
                                  radius: 30,
                                  child: Icon(Icons.delete, size: 40),
                                ),
                              ),
                              title: Text(
                                  ref
                                      .watch(userProvider)
                                      .cars[index]
                                      .model
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Padding(
                                padding: const EdgeInsets.all(0),
                                child: Column(children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Plate_Number".tr(),
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        ref
                                            .watch(userProvider)
                                            .cars[index]
                                            .noPlate
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Chassis_Number".tr(),
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      Text(
                                          ref
                                              .watch(userProvider)
                                              .cars[index]
                                              .noChassis
                                              .toString()
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Color".tr(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 19,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ]),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            )),
          ),
        ));
  }

  // deleteCar(index) async {
  //   String? chasis = ref.watch(userProvider).cars[index].noChassis;
  //   final userNotifier = ref.watch(userProvider.notifier);
  //   final Client carstate = ref.watch(userProvider);
  //
  //   //TODO check if this user is the owner of this car
  //   //authorization
  //   DatabaseReference cars = dbRef.child("cars").child(chasis!);
  //   DatabaseReference userCars = dbRef
  //       .child("users_cars")
  //       .child(FirebaseAuth.instance.currentUser!.uid)
  //       .child(chasis);
  //   userCars.set(false);
  //   ref
  //       .watch(userProvider.notifier)
  //       .removeCar(ref.watch(userProvider).cars[index]);
  //   // userNotifier.removeCar(carstate.cars);
  //   cars.remove();
  // }

  deleteCarAllUsers(index) async {
    String? chasis = ref.watch(userProvider).cars[index].noChassis;
    final userNotifier = ref.watch(userProvider.notifier);
    final Client carstate = ref.watch(userProvider);

    //TODO check if this user is the owner of this car
    //authorization
    // DatabaseReference cars = dbRef.child("cars").child(chasis!);
    DatabaseReference userCars = dbRef
        .child("users_cars")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child(chasis!);
    userCars.set(false);
    ref
        .watch(userProvider.notifier)
        .removeCar(ref.watch(userProvider).cars[index]);
    // userNotifier.removeCar(carstate.cars);
    // cars.remove();
  }
}
