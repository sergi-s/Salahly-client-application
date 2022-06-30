import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:slahly/main.dart';

import '../../classes/models/car.dart';

class AddSubowner extends ConsumerStatefulWidget {
  static const routeName = "/addSubowner";
  String? chasis;
  @override
  _State createState() => _State();

  AddSubowner({this.chasis});
}

class _State extends ConsumerState<AddSubowner> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      cardata();
    });
    super.initState();
  }

  DatabaseReference subowners =
      FirebaseDatabase.instance.ref().child("subowners");
  final TextEditingController getUserController = TextEditingController();
  bool found = false;
  String? email = "";
  String? subId;
  String? avatar;
  List models = [];
  List chasis = [];
  String? sub;
  String? selected;
  Map<String, String> map = Map();

  DatabaseReference user = dbRef.child("users");
  late String dropdownvalue = "Choose Car";

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
                addSubowner(widget.chasis);
                Navigator.pop(context, true);

                // ShowSnackbar(context, info, index);
              },
              child: Text('Confirm'.tr())),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('back'.tr()))
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
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            context.pop();
          },
        ),
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(""),
          Text(
            "Add_Subowner".tr(),
            style: const TextStyle(
              fontSize: 22,
              letterSpacing: 1,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          Image.asset(
            'assets/images/logo white.png',
            fit: BoxFit.contain,
            height: 30,
          ),
        ]),
      ),
      body: CustomPaint(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.12),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     children: [
                //       Text(
                //         "Add_Subowner".tr(),
                //         style: TextStyle(fontSize: 40, color: Colors.white),
                //         textAlign: TextAlign.center,
                //       ),
                //     ]),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),

                Row(children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: TextFormField(
                      controller: getUserController,
                      decoration: InputDecoration(
                        labelText: "enter_subowner_email".tr(),
                        filled: true,
                        errorText:
                            email != getUserController.text ? "invalid" : null,
                        fillColor: const Color(0xFFd1d9e6).withOpacity(0.1),
                      ),
                    ),
                  ),
                  FloatingActionButton(
                    backgroundColor: Color(0xFF193566),
                    onPressed: () {
                      getuser();
                    },
                    tooltip: 'search',
                    child: const Icon(Icons.search),
                  ),
                ]),
                // const SizedBox(height: 30),
                // Row(
                //   children: [
                //     Text('Choose_Car'.tr(),
                //         style:
                //             const TextStyle(fontSize: 25, color: Colors.black)),
                //     const SizedBox(width: 20),
                //     // DropdownButton<dynamic>(
                //     //   value: dropdownvalue,
                //     //   icon: const Icon(Icons.keyboard_arrow_down),
                //     //   items: models.map((dynamic items) {
                //     //     return DropdownMenuItem(
                //     //         value: items,
                //     //         child: Text(items,
                //     //             style: const TextStyle(
                //     //                 fontSize: 15, color: Colors.black)));
                //     //   }).toList(),
                //     //   onChanged: (dynamic? value) {
                //     //     setState(() {
                //     //       this.dropdownvalue = value!;
                //     //       selected = map[this.dropdownvalue];
                //     //     });
                //     //   },
                //     // ),
                //   ],
                // ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    (avatar == null)
                        ? Container()
                        : CircleAvatar(
                            radius: 30.0,
                            backgroundImage: NetworkImage(avatar ??
                                "https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png"),
                            backgroundColor: Colors.transparent,
                          ),
                    const SizedBox(width: 20),
                    Text(email!,
                        style: const TextStyle(
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
        // painter: HeaderCurvedContainer(),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            // child: FloatingActionButton(
            //   onPressed: () => scanQRcode(),
            //   child: const Icon(Icons.qr_code),
            //   backgroundColor: const Color(0xFF193566),
            // ),
          ),
          // SizedBox(width: MediaQuery.of(context).size.width * 0.7),

          Visibility(
            visible: found,
            child: FloatingActionButton(
              onPressed: () {
                showAlertbox(context);
              },
              child: const Icon(Icons.add),
              backgroundColor: const Color(0xFF193566),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
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
    DatabaseReference carsUsers = dbRef.child("users_cars");

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
            setState(() {
              models.add(carsSnapshot.child("model").value.toString());
              chasis.add(carsSnapshot.key);
              for (var i = 0; i < models.length; i++) {
                map[models[i]] = chasis[i];
              }

              dropdownvalue = models[0].toString();
            });
          }

          print(models);
          print(map);
        });
      }
    });
  }

  // cardata() async {
  //   DatabaseReference cars = dbRef.child("cars");
  //   // final userNotifier = ref.watch(userProvider.notifier);
  //
  //   cars
  //       .orderByChild("owner")
  //       .equalTo(FirebaseAuth.instance.currentUser!.uid)
  //       .once()
  //       .then((event) {
  //     final dataSnapshot = event.snapshot;
  //
  //     dataSnapshot.children.forEach((carsSnapShot) {
  //       print("this user's cars=>${carsSnapShot.child("model").value}");
  //       print("this user's cars=>${carsSnapShot.key}");
  //
  //       setState(() {
  //         models.add(carsSnapShot.child("model").value.toString());
  //         chasis.add(carsSnapShot.key);
  //         for (var i = 0; i < models.length; i++) {
  //           map[models[i]] = chasis[i];
  //         }
  //
  //         dropdownvalue = models[0].toString();
  //       });
  //       print(models);
  //       print(map);
  //     });
  //   });
  // }

  addSubowner(chasis) async {
    print("selected ${widget.chasis}");
    DatabaseReference carsUsers = dbRef.child("cars_users").child(chasis);
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
        if (sub.toString() == carsUsers.key.toString() &&
            subId != FirebaseAuth.instance.currentUser!.uid) {
          print("car added");
          await carsUsers
              .child(FirebaseAuth.instance.currentUser!.uid)
              .child(subId!)
              .set(true);
          usersCars.child(chasis).set("true");
          context.pop();
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
        setState(() {
          email = data[f]["email"];
          avatar = data[f]["image"];
          subId = f;
          found = true;
        });
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
