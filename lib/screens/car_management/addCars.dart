import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:slahly/classes/models/client.dart';
import 'package:slahly/screens/car_management/view_cars_screen.dart';

import '../../classes/models/car.dart';
import '../../classes/provider/user_data.dart';
import '../../main.dart';
import '../../utils/constants.dart';

class Addcar extends ConsumerStatefulWidget {
  static const String routeName = "/addcar";

  @override
  _State createState() => _State();
}

final TextEditingController carModelController = TextEditingController();
final TextEditingController yearController = TextEditingController();
final TextEditingController plateController = TextEditingController();
final TextEditingController chasisController = TextEditingController();
final TextEditingController numberController = TextEditingController();
Car? carData;

class _State extends ConsumerState<Addcar> {
  // create some values
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  String? color;
// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context) {
    final userNotifier = ref.watch(userProvider.notifier);
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: const Color(0xFFd1d9e6),
        body: CustomPaint(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: screenSize.height * 0.1,
                      right: screenSize.width * 0.05,
                      left: screenSize.width * 0.05),
                  child: Column(
                    children: [
                      Text(
                        "Add_Car".tr(),
                        style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        controller: carModelController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.drive_eta_rounded,
                            color: Colors.grey[500],
                          ),
                          border: const OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: const TextStyle(
                              color: Colors.black, fontFamily: "WorkSansLight"),
                          filled: true,
                          label: Text("Car_Model".tr(),
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black)),
                          fillColor: Colors.white70,
                          hintText: "Enter Car Model",
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: chasisController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.add_circle_outlined,
                            color: Colors.grey[500],
                          ),
                          border: const OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: const TextStyle(
                              color: Colors.black, fontFamily: "WorkSansLight"),
                          filled: true,
                          label: Text("Chassis_Number".tr(),
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.black)),
                          fillColor: Colors.white70,
                          hintText: "Enter chasis Number",
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: plateController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.add_circle_outlined,
                            color: Colors.grey[500],
                          ),
                          border: const OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: const TextStyle(
                              color: Colors.black, fontFamily: "WorkSansLight"),
                          filled: true,
                          label: Text("Plate_Number".tr(),
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.black)),
                          fillColor: Colors.white70,
                          hintText: "Enter car plate",
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text("Color_Picker".tr(),
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold)),
                          const SizedBox(
                            width: 45,
                          ),
                          GestureDetector(
                            onTap: () {
                              pickColor(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: pickerColor),
                              width: 50,
                              height: 50,
                            ),
                          ),
                        ],
                      ),
                      FlatButton(
                        textColor: Colors.white,
                        child: const Text('Add_Car').tr(),
                        color: const Color(0xFF193566),
                        onPressed: () {
                          ///////////////
                          print("YAYAYAAYAYAY");
                          print(plateController.text.isEmpty);
                          print(carModelController.text.isEmpty);
                          print(chasisController.text.isEmpty);

                          if (plateController.text.isEmpty ||
                              carModelController.text.isEmpty ||
                              chasisController.text.isEmpty) {
                            noData(context);
                            return;
                          }
                          const snackBar = SnackBar(content: Text('Car Added'));
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Text(
                                      "are_you_sure_u_want_to_add_car".tr()),
                                  title: Text("Warning".tr()),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          userNotifier.assignCar(Car(
                                              noPlate: plateController.text,
                                              model: carModelController.text,
                                              noChassis: chasisController.text,
                                              color: pickerColor,
                                              id: numberController.text,
                                              carAccess: CarAccess.owner));
                                          addCar(ref);
                                          Navigator.of(context).pop();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                          context.push(ViewCars.routeName);
                                        },
                                        child: Text("confirm".tr())),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Cancel".tr()))
                                  ],
                                );
                              });
                        },
                      ),
                      // FloatingActionButton(
                      //   onPressed: () => context.push(Choose_car.routeName),
                      //   child: Text("choosecar"),
                      // ),
                      // FloatingActionButton(
                      //   onPressed: () => context.push(ViewCars.routeName),
                      //   child: Text("viewcar"),
                      // ),
                      // FloatingActionButton(
                      //   onPressed: () => context.push(TransferOwner.routeName),
                      //   child: Text("transfer"),
                      // ),
                      // FloatingActionButton(
                      //   onPressed: () => context.push(AddSubowner.routeName),
                      //   child: Text("add subowner"),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          painter: HeaderCurvedContainer(),
        ));
  }

  Widget buildColorPicker() => ColorPicker(
      pickerColor: pickerColor,
      onColorChanged: (pickerColor) => setState(() {
            this.pickerColor = pickerColor;
          }));
  pickColor(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 60),
            title: Text("Pick Color"),
            content: Column(
              children: [
                buildColorPicker(),
                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("cancel".tr())),
                    SizedBox(
                      width: 20,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Select_Color".tr())),
                  ],
                ),
              ],
            ),
          );
        });
  }

  void noData(context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(dialogRadius),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Data Error").tr(),
                ],
              ),
              content: Text("Please fill all data").tr(),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("ok").tr(),
                ),
              ],
            ));
  }

  addCar(ref) async {
    Client car = ref.watch(userProvider);
    DatabaseReference cars = dbRef.child("cars").child(chasisController.text);
    DatabaseReference usersCars = dbRef
        .child("users_cars")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child(chasisController.text);
    color = pickerColor.toString().substring(6);
    color = color.toString().substring(0, color.toString().length - 1);
    // String? key = dbRef.child("cars").push().key;
    String? key = cars.key;
    usersCars.set("true");

    await cars.set({
      "model": carModelController.text,
      "plate": plateController.text,
      "color": pickerColor.toString(),
      "owner": FirebaseAuth.instance.currentUser!.uid
    });

    carData = Car(
        noPlate: plateController.text,
        model: carModelController.text,
        noChassis: chasisController.text,
        color: pickerColor);
    ref.watch(userProvider.notifier).assignCar(carData);
    print(color);
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
