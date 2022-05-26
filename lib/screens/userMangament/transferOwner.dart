import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:slahly/classes/models/client.dart';
import 'package:slahly/screens/car_management/add_car_screen.dart';
import '../../classes/models/car.dart';
import '../../classes/provider/user_data.dart';
import '../../main.dart';

class TransferOwner extends ConsumerStatefulWidget {
  static final routeName = "/transferOwner";

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
  String dropdownvalue = 'Choose car';
  var items = ['lada', 'bmw', 'ferari', 'btngan'];

  Future showAlertbox(context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Result'.tr()),
        content: Text('are you sure u want to+ confirm ownership transfer'),
        actions: [
          ElevatedButton(
              onPressed: () {
                transferOwner(selected);
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

  @override
  Widget build(
    BuildContext context,
  ) {
    final Client carstate = ref.watch(userProvider);

    final userNotifier = ref.watch(userProvider.notifier);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFd1d9e6),
      appBar: AppBar(
        elevation: 0,
        bottomOpacity: 0.0,
        backgroundColor: const Color(0xFF193566),
        // title: Center(
        //   child: Text('Manage Ownership',
        //       style: TextStyle(fontSize: 30, color: Colors.black)),
        // ),
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const []),
      ),
      body: CustomPaint(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: Form(
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "transfer_ownership".tr(),
                    style: TextStyle(fontSize: 30, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(
                height: 120,
              ),
              Row(children: [
                Container(
                  width: 250,
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
                  onPressed: () {
                    getuser();
                  },
                  tooltip: 'search',
                  child: Icon(Icons.search),
                ),
              ]),

              // TextFormField(
              //   controller: getUserController,
              //   decoration: InputDecoration(
              //     labelText: "Enter New Ownership email",
              //   ),
              // ),
              SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  Text('Choose_Car'.tr(),
                      style:
                          const TextStyle(fontSize: 25, color: Colors.black)),
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
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 30.0,
                    backgroundImage: NetworkImage(avatar ?? "sad"),
                    backgroundColor: Colors.transparent,
                  ),
                  const SizedBox(width: 20),
                  Text(email!, style: TextStyle(fontSize: 25))
                ],
              ),
              const SizedBox(
                height: 70,
              ),
              Visibility(
                visible: found,
                child: Container(
                    width: 300,
                    child: Center(
                      child: TextButton(
                          child: Text("Confirm_Transfer".tr(),
                              style:
                                  // <<<<<<< HEAD
                                  TextStyle(fontSize: 15, color: Colors.white)),
                          // >>>>>>> 931e111d966e6532a25d6451b6fa85ee81a45bd7
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(15)),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xFF193566)),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xFF193566)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: Color(0xFF193566))))),
                          onPressed: () => showAlertbox(context)),
                    )),
              ),
              // ElevatedButton(
              //     onPressed: () {
              //       // cardata();
              //       getuser();
              //     },
              //     child: Text("dataa")),
              // ElevatedButton(
              //     onPressed: () {
              //       context.push(AddCars.routeName);
              //     },
              //     child: Text("goooo")),
              // ElevatedButton(
              //     onPressed: () {
              //       transferOwner(selected);
              //     },
              //     child: Text("transfer"))
            ]),
          ),
        ),
        painter: HeaderCurvedContainer(),
      ),
    );
  }

  cardata() async {
    DatabaseReference cars = dbRef.child("cars");

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
    // ref
    //     .watch(userProvider.notifier)
    //     .removeCar(ref.watch(userProvider).cars[index]);
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
