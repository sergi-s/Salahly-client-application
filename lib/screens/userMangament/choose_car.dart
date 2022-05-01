import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:slahly/classes/models/car.dart';
import 'package:slahly/screens/car_management/add_car_screen.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';
import 'package:slahly/classes/models/client.dart';

import '../../classes/provider/user_data.dart';
import '../../main.dart';
import 'manageSubowner.dart';

class Choose_car extends ConsumerStatefulWidget {
  static final routeName = "/Choose_car";

  @override
  _State createState() => _State();
}

class _State extends ConsumerState<Choose_car> {
  @override
  void initState() {
    cardata();
    super.initState();
  }

  final List<String> titles = [
    "RED",
    "YELLOW",
    "BLACK",
    "CYAN",
    "BLUE",
    "GREY",
  ];

  final List<Widget> images = [
    Container(
      color: Colors.red,
    ),
    Container(
      color: Colors.yellow,
    ),
    Container(
      color: Colors.black,
    ),
    Container(
      color: Colors.cyan,
    ),
    Container(
      color: Colors.blue,
    ),
    Container(
      color: Colors.grey,
    ),
  ];

  List<Car> car = [
    Car(
        color: "blue",
        noPlate: '1945stak',
        model: "Ferari",
        id: "145",
        noChassis: "1294sfas"),
    Car(
        color: "green",
        noPlate: '1945stak',
        model: "BMW",
        id: "145",
        noChassis: "1294sfas"),
    Car(
        color: "black",
        noPlate: '1945stak',
        model: "porche",
        id: "145",
        noChassis: "1294sfas"),
    Car(
        color: "red",
        noPlate: '1945stak',
        model: "lada",
        id: "145",
        noChassis: "1294sfas")
  ];

  Map<String, Color> btncolor = {
    "red": Colors.red,
    "black": Colors.black,
    "blue": Colors.blue,
    "yellow": Colors.yellow,
    "green": Colors.green
  };

  @override
  Widget build(BuildContext context) {
    final Client carstate = ref.watch(userProvider);
    final userNotifier = ref.watch(userProvider.notifier);
    Size size = MediaQuery.of(context).size;
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
                children: [Text("Choose_Car".tr())]),
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
                itemCount: carstate.cars.length,
                itemBuilder: (context, index) => Card(
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
                          context.push(ManageSubowner.routeName,
                              extra: carstate.cars[index].noChassis.toString());

                          print('welcome'.tr());
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: btncolor[car[index].color],
                            child: Icon(Icons.directions_car_filled, size: 40),
                          ),
                          title: Text(carstate.cars[index].model.toString(),
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)),
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
                                    carstate.cars[index].noPlate.toString(),
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
                                      carstate.cars[index].noChassis.toString(),
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
                                  Text(car[index].color.toString(),
                                      style: TextStyle(
                                          fontSize: 19,
                                          color: btncolor[car[index].color],
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ]),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )),
          ),
          painter: HeaderCurvedContainer(),
        ));
  }

  cardata() async {
    print("saaaaaddddd");
    DatabaseReference cars = dbRef.child("cars");

    cars
        .orderByChild("owner")
        .equalTo(FirebaseAuth.instance.currentUser!.uid)
        .once()
        .then((event) {
      final dataSnapshot = event.snapshot;
      dataSnapshot.children.forEach((carsSnapShot) {
        print("this user's cars=>${carsSnapShot.child("model").value}");
        Car car = new Car(
            noPlate: carsSnapShot.child("plate").value.toString(),
            model: carsSnapShot.child("model").value.toString(),
            noChassis: carsSnapShot.key.toString());
        ref.watch(userProvider.notifier).assignCar(car);
        print(ref.watch(userProvider).cars);
      });
    });
    print("hiii");
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
