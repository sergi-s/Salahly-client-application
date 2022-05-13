import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/classes/provider/ongoing_data.dart';
import 'package:slahly/classes/provider/user_data.dart';
import 'package:slahly/widgets/global_widgets/app_bar.dart';
import 'package:slahly/widgets/global_widgets/app_drawer.dart';
import 'package:slahly/widgets/location/finalScreen.dart';

class OngoingRequests extends ConsumerStatefulWidget {
  static const String routeName = "/ongoingRequests";

  const OngoingRequests({Key? key}) : super(key: key);

  @override
  ConsumerState<OngoingRequests> createState() => _OngoingRequestsState();
}

class _OngoingRequestsState extends ConsumerState<OngoingRequests> {
  // List<RSA> ongoingRequestsList = [];

  @override
  initState() {
    Future.delayed(Duration.zero, () {
      // getOngoingRequests();
      // setState(() {
      print("inside ui init ${ref.watch(userProvider).cars}");
      // print("${ref.watch(HistoryProvider).requests}");
      // ongoingRequestsList = ref.watch(HistoryProvider).requests;
      ref
          .watch(HistoryProvider.notifier)
          .assignRequests(ref.watch(userProvider).cars);

      // print("inside ui init ${ref.read(HistoryProvider)[0].mechanic!.name}");
      // });
      // ref
      //     .watch(HistoryProvider.notifier)
      //     .assignRequests(ref.watch(userProvider).cars);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: salahlyAppBar(title: "Ongoing Requests"),
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
                      ref
                          .watch(HistoryProvider.notifier)
                          .assignRequests(ref.watch(userProvider).cars);
                    });
                  },
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      reverse: false,
                      itemCount: ref.watch(HistoryProvider).length,
                      itemBuilder: (context, index) {
                        if (ref.watch(HistoryProvider)[index].state ==
                                RSAStates.canceled ||
                            ref.watch(HistoryProvider)[index].state ==
                                RSAStates.done) {
                          return Container();
                        }
                        print(ref.watch(HistoryProvider)[index].state);
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
                              child: ListTile(
                                leading: CircleAvatar(
                                    backgroundImage: NetworkImage(ref
                                        .watch(HistoryProvider)[index]
                                        .mechanic!
                                        .avatar
                                        .toString())),
                                // Text(ongoingRequestsList[index].car!.noPlate),
                                title: Row(
                                  children: [
                                    Text(
                                      ref
                                          .watch(HistoryProvider)[index]
                                          .mechanic!
                                          .name
                                          .toString()
                                          .capitalize(),
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Expanded(
                                        child: Divider(
                                      thickness: 0,
                                    )),
                                    Text(
                                      ref
                                          .watch(HistoryProvider)[index]
                                          .mechanic!
                                          .rating
                                          .toString()
                                          .capitalize(),
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: Column(children: [
                                    Row(
                                      children: [
                                        Text(
                                          "at".tr() + " ",
                                          style: const TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          ref
                                              .watch(HistoryProvider)[index]
                                              .mechanic!
                                              .address
                                              .toString()
                                              .capitalize(),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),

                                    Row(
                                      children: [
                                        Text(
                                          "workingOn".tr() + " ",
                                          style: const TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                            ref
                                                .watch(HistoryProvider)[index]
                                                .car!
                                                .noPlate
                                                .toString(),
                                            // ref
                                            //     .watch(userProvider)
                                            //     .cars[index]
                                            //     .noPlate
                                            //     .toString(),
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black)),
                                        const Expanded(
                                            child: Divider(
                                          thickness: 0,
                                        )),
                                        Text(
                                          ref
                                              .watch(HistoryProvider)[index]
                                              .car!
                                              .getCarAccess()
                                              .toString(),
                                          // ref
                                          // .watch(userProvider)
                                          // .cars[index].getCarAccess().toString()
                                        ),
                                      ],
                                    ),

                                    Row(
                                      children: [
                                        Text("request".tr() + " ",
                                            style: const TextStyle(
                                              fontSize: 18,
                                            )),
                                        Text(
                                          RSA.requestTypeToString(ref
                                              .watch(HistoryProvider)[index]
                                              .requestType!),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),

                                    Row(
                                      children: [
                                        Text("When".tr() + " ",
                                            style: const TextStyle(
                                              fontSize: 18,
                                            )),
                                        Text(
                                          "${ref.watch(HistoryProvider)[index].createdAt}",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
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
                                    //   ],
                                    // ),
                                  ]),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              )),
            ),
          )),
    );
  }

// typeOngoingRequests(DatabaseReference local) {
//   for (var car in ref.watch(userProvider).cars) {
//     // print("Will try car ${car.noChassis}");
//     local
//         .orderByChild("carID")
//         .equalTo(car.noChassis)
//         .once()
//         .then((event) async {
//       DataSnapshot rsaDataSnapShot = event.snapshot;
//       // print("found this: ${rsaDataSnapShot.value}");
//
//       for (var element in rsaDataSnapShot.children) {
//         String mechanicID = "";
//
//         if (element.child("state").value.toString() != "canceled" &&
//             element.child("state").value.toString() != "done") {
//           for (var response in element.child("mechanicsResponses").children) {
//             // print("isa 5er ${response.value}");
//             if (response.value == "accepted") {
//               mechanicID = response.key.toString();
//             }
//           }
//           Mechanic mechanic = await getMechanicData(mechanicID);
//
//           RequestType requestType =
//               (local == rsaRef) ? RequestType.RSA : RequestType.WSA;
//           RSA rsa = RSA(
//               rsaID: element.key.toString(),
//               car: car,
//               mechanic: mechanic,
//               requestType: requestType);
//
//           setState(() {
//             ongoingRequestsList.add(rsa);
//           });
//           // print("list length${ongoingRequestsList.length}");
//         }
//       }
//     });
//   }
// }

// getOngoingRequests() async {
//   allCars(ref);
//   typeOngoingRequests(rsaRef);
//   typeOngoingRequests(wsaRef);
// }
}