import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:slahly/classes/models/client.dart';
import 'package:slahly/classes/provider/user_data.dart';
import 'package:slahly/main.dart';
import 'package:slahly/utils/firebase/get_all_cars.dart';
import 'package:slahly/widgets/global_widgets/app_bar.dart';
import 'package:slahly/widgets/global_widgets/app_drawer.dart';

class ViewCars extends ConsumerStatefulWidget {
  static const routeName = "/viewcars";

  @override
  _State createState() => _State();
}

class _State extends ConsumerState<ViewCars> {
  @override
  void initState() {
    Future.delayed(Duration.zero,(){
      print("caaaaaaaaarss${ref.watch(userProvider).cars}");
    });
    // allCars(ref);
    // print("carrrrrrs ${ref.watch(userProvider).cars[0].model}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFd1d9e6),
        appBar: salahlyAppBar(title: "View Cars"),
        drawer: salahlyDrawer(context),
        body: CustomPaint(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              color: Color(0xFFd1d9e6),
            ), // red as border color
            child: SafeArea(
                child: AnimationLimiter(
              child: RefreshIndicator(
                onRefresh: () {
                  return Future.delayed(const Duration(seconds: 2), () {
                    allCars(ref);
                  });
                },
                child: ListView.builder(
                    itemCount: ref.watch(userProvider).cars.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 6,
                        margin: const EdgeInsets.all(10),
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
                                print('welcome'.tr());
                              },
                              child: ListTile(
                                leading: GestureDetector(
                                  onTap: () {
                                    print("hiiii");

                                    deleteCarAllUsers(index);
                                  },
                                  child: const CircleAvatar(
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
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold)),
                                subtitle: Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: Column(children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Plate_Number".tr(),
                                          style: const TextStyle(
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
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Chassis_Number".tr(),
                                          style: const TextStyle(
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
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Color".tr(),
                                            style: const TextStyle(
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
              ),
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

    DatabaseReference userCars = dbRef
        .child("users_cars")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child(chasis!);
    userCars.set(false);
    ref
        .watch(userProvider.notifier)
        .removeCar(ref.watch(userProvider).cars[index]);
  }
}
