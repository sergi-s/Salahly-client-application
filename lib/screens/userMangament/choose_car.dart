import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:slahly/classes/models/car.dart';
import 'package:slahly/classes/models/client.dart';
import 'package:slahly/classes/provider/user_data.dart';
import 'package:slahly/utils/firebase/get_all_cars.dart';

import '../../main.dart';
import 'manageSubowner.dart';

class Choose_car extends ConsumerStatefulWidget {
  static const routeName = "/Choose_car";

  @override
  _State createState() => _State();
}

class _State extends ConsumerState<Choose_car> {
  @override
  void initState() {
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

  @override
  Widget build(BuildContext context) {
    final Client carState = ref.watch(userProvider);
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
              decoration: const BoxDecoration(
                color: Color(0xFFd1d9e6),
              ), // red as border color
              child: SafeArea(
                child: RefreshIndicator(
                  onRefresh: () {
                    return Future.delayed(const Duration(seconds: 2), () {
                      allCars(ref);
                    });
                  },
                  child: ListView.builder(
                    itemCount: ref.watch(userProvider).cars.length,
                    itemBuilder: (context, index) {
                      if (carState.cars[index].carAccess != CarAccess.sub) {
                        return Card(
                          elevation: 6,
                          margin: EdgeInsets.all(10),
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
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
                                      extra: carState.cars[index].noChassis
                                          .toString());

                                  print('welcome'.tr());
                                },
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: carState.cars[index].color,
                                    // ref
                                    //     .watch(userProvider)
                                    //     .cars[index]
                                    //     .color as Color
                                    child: const Icon(
                                        Icons.directions_car_filled,
                                        size: 40),
                                  ),
                                  title: Row(
                                    children: [
                                      Flexible(
                                          child: Text(
                                              carState.cars[index].model
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 25,
                                                  fontWeight:
                                                      FontWeight.bold))),
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
                                                    const Text('Car_removed')
                                                        .tr());
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    content: const Text(
                                                            "carDeleteConfirmation")
                                                        .tr(),
                                                    title: Text("Warning".tr()),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text(
                                                              "Cancel".tr())),
                                                      TextButton(
                                                          onPressed: () {
                                                            deleteCar(index);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    snackBar);
                                                          },
                                                          child: Text(
                                                              "Confirm".tr())),
                                                    ],
                                                  );
                                                });
                                          },
                                          child: const CircleAvatar(
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
                                            "${'Plate_Number'.tr()}: ",
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                          Flexible(
                                            child: Text(
                                              carState.cars[index].noPlate
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "${'Chassis_Number'.tr()}: ",
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                          Flexible(
                                            child: Text(
                                                carState.cars[index].noChassis
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
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
                ),
              )),
          painter: HeaderCurvedContainer(),
        ));
  }

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  deleteCar(index) async {
    String? chasis = ref.watch(userProvider).cars[index].noChassis;

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
