import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart';
import 'package:slahly/classes/models/car.dart';
import 'package:slahly/classes/models/client.dart';

import 'package:slahly/classes/provider/user_data.dart';
import 'package:slahly/utils/firebase/get_all_cars.dart';
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
    allCars(ref);
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

  // List<Car> car = [
  //   Car(
  //       color: "blue",
  //       noPlate: '1945stak',
  //       model: "Ferari",
  //       id: "145",
  //       noChassis: "1294sfas"),
  //   Car(
  //       color: "green",
  //       noPlate: '1945stak',
  //       model: "BMW",
  //       id: "145",
  //       noChassis: "1294sfas"),
  //   Car(
  //       color: "black",
  //       noPlate: '1945stak',
  //       model: "porche",
  //       id: "145",
  //       noChassis: "1294sfas"),
  //   Car(
  //       color: "red",
  //       noPlate: '1945stak',
  //       model: "lada",
  //       id: "145",
  //       noChassis: "1294sfas")
  // ];
  //
  // Map<String, Color> btncolor = {
  //   "red": Colors.red,
  //   "black": Colors.black,
  //   "blue": Colors.blue,
  //   "yellow": Colors.yellow,
  //   "green": Colors.green
  // };

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
                child: ListView.builder(
                  itemCount: ref.watch(userProvider).cars.length,
                  itemBuilder: (context, index) {
                    if (carstate.cars[index].carAccess != CarAccess.sub) {
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
                                context.push(ManageSubowner.routeName,
                                    extra: carstate.cars[index].noChassis
                                        .toString());

                                print('welcome'.tr());
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: carstate.cars[index].color,
                                  // ref
                                  //     .watch(userProvider)
                                  //     .cars[index]
                                  //     .color as Color
                                  child: Icon(Icons.directions_car_filled,
                                      size: 40),
                                ),
                                title: Row(
                                  children: [
                                    Text(carstate.cars[index].model.toString(),
                                        style: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold)),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.01),
                                      child: GestureDetector(
                                        onTap: () {
                                          print("huuu");
                                          final snackBar = SnackBar(
                                              content:
                                                  Text('Car_removed'.tr()));
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: Text(
                                                      "are you sure u want to delete car"),
                                                  title: Text("Warning".tr()),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text(
                                                            "Cancel".tr())),
                                                    TextButton(
                                                        onPressed: () {
                                                          deleteCar(index);
                                                          Navigator.of(context)
                                                              .pop();
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  snackBar);
                                                        },
                                                        child: Text(
                                                            "Confirm".tr())),
                                                  ],
                                                );
                                              });
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Colors.black,
                                          radius: 15,
                                          child: Icon(
                                            Icons.delete,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
                                          carstate.cars[index].noPlate
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
                                            carstate.cars[index].noChassis
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    // Row(
                                    //   children: [
                                    //     Text("Color".tr(),
                                    //         style: TextStyle(
                                    //             color: Colors.black,
                                    //             fontSize: 19,
                                    //             fontWeight: FontWeight.bold)),
                                    //     Text("color",
                                    //         style: TextStyle(
                                    //             fontSize: 19,
                                    //             color: Colors.red,
                                    //             fontWeight: FontWeight.bold)),
                                    //   ],
                                    // ),
                                  ]),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              )),
          painter: HeaderCurvedContainer(),
        ));
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  deleteCar(index) async {
    String? chasis = ref.watch(userProvider).cars[index].noChassis;
    final userNotifier = ref.watch(userProvider.notifier);
    final Client carstate = ref.watch(userProvider);

    //TODO check if this user is the owner of this car
    //authorization
    DatabaseReference carsUsers = dbRef.child("cars_users").child(chasis!);
    DatabaseReference cars = dbRef.child("cars").child(chasis);
    DatabaseReference userCars = dbRef
        .child("users_cars")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child(chasis);
    userCars.set(false);
    ref
        .watch(userProvider.notifier)
        .removeCar(ref.watch(userProvider).cars[index]);
    // userNotifier.removeCar(carstate.cars);
    cars.remove();
    carsUsers.remove();
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
