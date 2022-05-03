import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:slahly/main.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../classes/provider/user_data.dart';

class AddSubowner extends ConsumerStatefulWidget {
  static final routeName = "/addSubowner";

  @override
  _State createState() => _State();
}

class _State extends ConsumerState<AddSubowner> {
  @override
  void initState() {
    cardata();
    super.initState();
  }

  DatabaseReference subowners =
      FirebaseDatabase.instance.ref().child("subowners");
  final TextEditingController getUserController = TextEditingController();

  String? email = "";
  String? subId;
  String? avatar;
  List models = [];
  List chasis = [];
  String? sub;
  String? selected;
  Map<String, String> map = new Map();

  DatabaseReference user = dbRef.child("users");
  late String dropdownvalue;

  Future showAlertbox(context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Warning'.tr()),
        content: Text('Are_u_sure_want_to_add_Subowner'.tr()),
        actions: [
          ElevatedButton(
              onPressed: () {
                addSubowner(selected);
                Navigator.pop(context, true);

                // ShowSnackbar(context, info, index);
              },
              child: Text('Confirm'.tr())),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Back'.tr()))
        ],
      ),
    );
  }

  var items = ['Lada', 'BMW', 'FERARI', 'MARCEDES'];

  var name = ['sergi ', 'hesham'];

  String qrCode = 'Unknown';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFFd1d9e6),
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: const Color(0xFF193566),
          title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            // Image.asset(
            //   'assets/images/logo ta5arog white car.png',
            //   fit: BoxFit.contain,
            //   height: 32,
            // ),
          ]),
        ),
        body: CustomPaint(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Add_Subowner".tr(),
                          style: TextStyle(fontSize: 40, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ]),
                  const SizedBox(
                    height: 100,
                  ),

                  // Text(
                  //   " Sergi Samir",
                  //   style: TextStyle(fontSize: 30, color: Colors.black),
                  //   textAlign: TextAlign.center,
                  // ),
                  const SizedBox(width: 50),
                  const SizedBox(height: 20),
                  Row(children: [
                    Container(
                      width: 250,
                      child: TextFormField(
                        controller: getUserController,
                        decoration: InputDecoration(
                          labelText: "Enter_Subowner_Email".tr(),
                          filled: true,
                          fillColor: const Color(0xFFd1d9e6).withOpacity(0.1),
                        ),
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        getuser();
                      },
                      tooltip: 'search',
                      child: Icon(Icons.search),
                    ),
                  ]),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Text('Choose_Car'.tr(),
                          style: TextStyle(fontSize: 25, color: Colors.black)),
                      SizedBox(width: 20),
                      DropdownButton<dynamic>(
                        value: dropdownvalue,
                        icon: Icon(Icons.keyboard_arrow_down),
                        items: models.map((dynamic items) {
                          return DropdownMenuItem(
                              value: items,
                              child: Text(items,
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black)));
                        }).toList(),
                        onChanged: (dynamic? value) {
                          setState(() {
                            this.dropdownvalue = value!;
                            selected = map[this.dropdownvalue];
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30.0,
                        backgroundImage: NetworkImage(avatar ?? "sad"),
                        backgroundColor: Colors.blue,
                      ),
                      SizedBox(width: 50),
                      Text(email!, style: TextStyle(fontSize: 25))
                    ],
                  )
                ],
              ),
            ),
          ),
          painter: HeaderCurvedContainer(),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: FloatingActionButton(
                onPressed: () => scanQRcode(),
                child: const Icon(Icons.qr_code),
                backgroundColor: const Color(0xFF193566),
              ),
            ),
            // SizedBox(width: MediaQuery.of(context).size.width * 0.7),
            FloatingActionButton(
              onPressed: () {
                showAlertbox(context);
              },
              child: const Icon(Icons.add),
              backgroundColor: Color(0xFF193566),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat);
  }

  Future<void> scanQRcode() async {
    // print('hello');
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Close', true, ScanMode.QR);
    } on PlatformException {
      qrCode = 'failed to get version';
    }
  }

  cardata() async {
    DatabaseReference cars = dbRef.child("cars");
    // final userNotifier = ref.watch(userProvider.notifier);

    cars
        .orderByChild("owner")
        .equalTo(FirebaseAuth.instance.currentUser!.uid)
        .once()
        .then((event) {
      final dataSnapshot = event.snapshot;

      dataSnapshot.children.forEach((carsSnapShot) {
        print("this user's cars=>${carsSnapShot.child("model").value}");
        print("this user's cars=>${carsSnapShot.key}");

        setState(() {
          models.add(carsSnapShot.child("model").value.toString());
          chasis.add(carsSnapShot.key);
          for (var i = 0; i < models.length; i++) {
            map[models[i]] = chasis[i];
          }

          dropdownvalue = models[0].toString();
        });
        print(models);
        print(map);
      });
    });
  }

  addSubowner(selected) async {
    DatabaseReference carsUsers = dbRef.child("cars_users").child(selected);
    DatabaseReference cars = dbRef.child("cars");
    DatabaseReference usersCars = dbRef.child("users_cars").child(subId!);
    cars
        .orderByChild("owner")
        .equalTo(FirebaseAuth.instance.currentUser!.uid)
        .once()
        .then((event) async {
      final dataSnapshot = event.snapshot;

      dataSnapshot.children.forEach((carsSnapShot) async {
        print("this user's cars=>${carsSnapShot.key}");
        sub = carsSnapShot.key;
        print("thiss xxxx ${sub}");
        if (sub.toString() == carsUsers.key.toString()) {
          print("car added");
          await carsUsers
              .child(FirebaseAuth.instance.currentUser!.uid)
              .child(subId!)
              .set(true);
          usersCars.child(selected).set("true");
        } else {
          print("add car");
        }
      });
    });
    print("herreee");
    print(carsUsers.key.toString());
  }

  getuser() async {
    user
        .child("clients")
        .orderByChild("email")
        .equalTo(getUserController.text)
        .once()
        .then((event) {
      final dataSnapshot = event.snapshot;
      print("read" + dataSnapshot.value.toString());
      var x = dataSnapshot.value.toString();
      x.trim();
      var y = x.split(":");
      String z = y[0];
      String f = z.replaceAll("{", "");
      print(f);

      var data = dataSnapshot.value as Map;

      if (data != null) {
        email = data[f]["email"];
        avatar = data[f]["image"];
        subId = f;
      }
      print(subId);
      print(avatar);
      print(email);

      // user.child("cars").orderByChild("model").equalTo(dropdownvalue).;
    });
    print(items);
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
