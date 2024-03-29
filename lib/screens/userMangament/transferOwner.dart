import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:slahly/classes/provider/user_data.dart';
import 'package:slahly/main.dart';

import '../../classes/models/car.dart';

class TransferOwner extends ConsumerStatefulWidget {
  static const routeName = "/transferOwner";

  @override
  _State createState() => _State();
}

class _State extends ConsumerState<TransferOwner> {
  @override
  void initState() {
    cardata();
    super.initState();
  }

  final TextEditingController getUserController = TextEditingController();

  String? email = "";
  String? subId;
  String? avatar;
  List models = [];
  List chasis = [];
  String? sub;
  bool found = false;
  String? selected;
  Map<String, String> map = new Map();

  DatabaseReference user = dbRef.child("users");
  String dropDownValue = 'Choose car';

  Future showAlertbox(context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Result').tr(),
        content: const Text('transferConfirmation').tr(),
        actions: [
          ElevatedButton(
              onPressed: () {
                transferOwner(selected);
                final snackBar =
                    SnackBar(content: Text('ownership_transfered'.tr()));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                context.pop();

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

  @override
  Widget build(BuildContext context) {
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
            "transfer_ownership".tr(),
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
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.15),
          child: Form(
            child: Column(children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     Text(
              //       "transfer_ownership".tr(),
              //       style: TextStyle(fontSize: 30, color: Colors.white),
              //       textAlign: TextAlign.center,
              //     ),
              //   ],
              // ),
              const SizedBox(height: 120),
              Row(children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextFormField(
                    controller: getUserController,
                    decoration: InputDecoration(
                      labelText: "enter_new_owner_email".tr(),
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

              const SizedBox(height: 50),
              Row(
                children: [
                  const Text('Choose_Car',
                          style: TextStyle(fontSize: 25, color: Colors.black))
                      .tr(),
                  const SizedBox(width: 20),
                  DropdownButton<dynamic>(
                    value: dropDownValue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: models.map((dynamic items) {
                      return DropdownMenuItem(
                          value: items,
                          child: Text(items,
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black)));
                    }).toList(),
                    onChanged: (dynamic? value) {
                      setState(() {
                        dropDownValue = value!;
                        selected = map[dropDownValue];
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  (avatar != null)
                      ? CircleAvatar(
                          radius: 30.0,
                          backgroundImage: NetworkImage(avatar!),
                          backgroundColor: Colors.transparent,
                        )
                      : Container(),
                  const SizedBox(width: 20),
                  Text(
                    email!,
                    style: const TextStyle(
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.17,
              ),
              Visibility(
                visible: found,
                child: Container(
                    width: 300,
                    child: Center(
                      child: TextButton(
                          child: const Text("Confirm_Transfer",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white))
                              .tr(),
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                const EdgeInsets.all(15)),
                            foregroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFF193566)),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFF193566)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: const BorderSide(
                                        color: Color(0xFF193566)))),
                          ),
                          onPressed: () => showAlertbox(context)),
                    )),
              ),
            ]),
          ),
        ),
      ),
    );
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
              dropDownValue = models[0].toString();
            });
          }
          // dropDownValue = models[0].toString();
        });
      }
    });
  }

  transferOwner(selected) {
    DatabaseReference cars = dbRef.child("cars");
    DatabaseReference carsUsers = dbRef.child("cars_users");
    DatabaseReference Userscar = dbRef.child("users_cars");
    cars.child(selected).update({"owner": subId});
    carsUsers.child(selected).remove();
    Userscar.child(FirebaseAuth.instance.currentUser!.uid)
        .update({selected: "false"});
    Userscar.child(subId!).child(selected).set("true");
    for (int i = 0; i < ref.watch(userProvider).cars.length; i++) {
      if (ref.watch(userProvider).cars[i].noChassis == selected) {
        ref
            .watch(userProvider.notifier)
            .removeCar(ref.watch(userProvider).cars[i]);
      }
    }
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
      String userId = z.replaceAll("{", "");
      print(userId);

      var data = dataSnapshot.value as Map;

      if (data != null) {
        setState(() {
          email = data[userId]["email"];
          avatar = data[userId]["image"];
          subId = userId;
          found = true;
        });
      }
    });
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
