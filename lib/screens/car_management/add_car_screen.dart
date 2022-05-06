import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:slahly/classes/models/car.dart';
import 'package:slahly/classes/models/client.dart';
import 'package:slahly/screens/car_management/view_cars_screen.dart';
import 'package:slahly/screens/userMangament/addSubowner.dart';
import 'package:slahly/screens/userMangament/choose_car.dart';
import 'package:slahly/screens/userMangament/transferOwner.dart';
import '../../classes/provider/user_data.dart';
import '../../main.dart';

class AddCars extends StatelessWidget {
  static final routeName = "/addcarscreen";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AddCarDialog(),
    );
  }
}

class AddCarDialog extends ConsumerWidget {
  final TextEditingController carModelController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController plateController = TextEditingController();
  final TextEditingController chasisController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController year = TextEditingController();

  Car? carData;

  _displayDialog(BuildContext context, WidgetRef ref) async {
    final Client carstate = ref.watch(userProvider);
    final userNotifier = ref.watch(userProvider.notifier);
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.all(8.0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            title: Text('Add_Car'.tr(),
                style: TextStyle(
                  color: Color(0xFF193566),
                )),
            content: Container(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/car_management/addcar.png',
                        fit: BoxFit.contain,
                        height: 150,
                      ),
                      TextField(
                        controller: carModelController,
                        decoration: InputDecoration(
                          labelText: 'Car_Model'.tr(),
                        ),
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Model_Year'.tr(),
                        ),
                        controller: yearController,
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Number_Plate'.tr(),
                        ),
                        controller: plateController,
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Chassis_Number'.tr(),
                        ),
                        controller: chasisController,
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                      ),
                    ],
                  ),
                )),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancel'.tr()),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                textColor: Colors.white,
                child: new Text('Send'.tr()),
                color: Color(0xFF193566),
                onPressed: () {
                  userNotifier.assignCar(Car(
                      noPlate: plateController.text,
                      model: carModelController.text,
                      noChassis: chasisController.text,
                      id: numberController.text,
                      carAccess: CarAccess.owner));
                  owner(ref);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add_Car'.tr()),
      ),
      body: Row(children: [
        FloatingActionButton(
          onPressed: () => _displayDialog(context, ref),
          child: Icon(Icons.add),
        ),
        FloatingActionButton(
          onPressed: () => context.push(Choose_car.routeName),
          child: Text("choosecar"),
        ),
        FloatingActionButton(
          onPressed: () => context.push(ViewCars.routeName),
          child: Text("viewcar"),
        ),
        FloatingActionButton(
          onPressed: () => context.push(TransferOwner.routeName),
          child: Text("transfer"),
        ),
        FloatingActionButton(
          onPressed: () => context.push(AddSubowner.routeName),
          child: Text("add subowner"),
        ),
      ]),
    );
  }

  owner(ref) async {
    Client car = ref.watch(userProvider);
    // final firebaseuser = await FirebaseAuth.instance.currentUser;
    DatabaseReference cars = dbRef.child("cars").child(chasisController.text);
    DatabaseReference usersCars = dbRef
        .child("users_cars")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child(chasisController.text);

    // String? key = dbRef.child("cars").push().key;
    String? key = cars.key;

    // String? key1 = cars.orderByChild("path").equalTo(value)
    // Map<String, dynamic> map = Map();
    // map['model'] = carModelController.text;
    // map['plate'] = plateController.text;
    // map['chasis'] = chasisController.text;
    // map['year'] = yearController.text;
    // Map<String, dynamic> map1 = Map();carsUsers.set(value)
    usersCars.set("true");
    await cars.set({
      "model": carModelController.text,
      "plate": plateController.text,
      "year": yearController.text,
      "owner": FirebaseAuth.instance.currentUser!.uid
    });

    carData = Car(
        noPlate: plateController.text,
        model: carModelController.text,
        noChassis: chasisController.text);
    ref.watch(userProvider.notifier).assignCar(carData);

    // await cars.set({
    //   "model": carModelController.text,
    //   "plate": plateController.text,
    //   "year": yearController.text,
    //   "owner": {
    //     "uid": FirebaseAuth.instance.currentUser!.uid,
    //     "type": "owner",
    //   }
    // });
    // cars.set(<String, Object>{
    //   "id": FirebaseAuth.instance.currentUser!.uid,
    //   "type": "owner",
    // });
    //   map1['type'] = "owner";
    //   DatabaseReference cars_user = await dbRef
    //       .child("cars_users")
    //       .child(FirebaseAuth.instance.currentUser!.uid)
    //       .child("$key");
    //   await cars_user.set(map1);
    // }
  }
}
