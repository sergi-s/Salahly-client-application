import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/classes/models/mechanic.dart';
import 'package:slahly/abstract_classes/user.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:slahly/widgets/ChooseTile.dart';
import 'package:slahly/classes/models/mechanic.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ChooseMechanicScreen extends StatelessWidget {
  ChooseMechanicScreen({Key? key}) : super(key: key);
  List<Mechanic> mechanics = [
    Mechanic(
        name: 'Ahmed tarek',
        phoneNumber: '01115612314',
        isCenter: true,
        type: Type.mechanic,
        loc: CustomLocation(
            address:
                "Factorya, shar3 45 odam mtafy 12311321312312hasdhdashjss221",
            latitude: 11,
            longitude: 12),
        avatar:
            'data:image/jpeg;base64,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',
        email: 'email@yahoo.com'),
    Mechanic(
        name: 'Sergi Samir',
        email: 'mechanic@yahoo.com',
        type: Type.mechanic,
        phoneNumber: '0122321099',
        loc: CustomLocation(
            address: "sedigabr,180 3omrt y3okbyan",
            latitude: 11,
            longitude: 12),
        isCenter: false,
        avatar:
            'data:image/jpeg;base64,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'),
    Mechanic(
        name: 'Mahmoud Magdy',
        type: Type.mechanic,
        email: 'Workshop@gmail.com',
        phoneNumber: '01550164495',
        loc: CustomLocation(
            address: "Miami, mostshafa 3m ahmed", latitude: 11, longitude: 12),
        isCenter: true,
        avatar:
            'https://thumbs.dreamstime.com/b/default-avatar-photo-placeholder-profile-image-default-avatar-photo-placeholder-profile-image-eps-file-easy-to-edit-124557892.jpg')
  ];

  static const routeName = "/choosemechanicscreen";

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   backgroundColor: const Color(0xFFd1d9e6),
    //   appBar: AppBar(
    //     backgroundColor: Colors.transparent,
    //     bottomOpacity: 0.0,
    //     elevation: 0.0,
    //     title: Center(
    //       child: Text(("choose_mech".tr()),
    //           style: const TextStyle(
    //               fontWeight: FontWeight.bold,
    //               fontSize: 24,
    //               color: Colors.black)),
    //     ),
    //   ),
    //   body: Center(
    //     child: FloatingActionButton(
    //       child: Icon(Icons.add),
    //       onPressed: () {
    //         showModalBottomSheet<void>(
    //           context: context,
    //           isScrollControlled: true,
    //           enableDrag: true,
    //           backgroundColor: const Color(0xFFd1d9e6),
    //           isDismissible: true,
    //           builder: (BuildContext context) {
    //             return Column(
    //               children: [
    //                 SizedBox(height: 10),
    //                 ListView.builder(
    //                   itemBuilder: (BuildContext, index) {
    //                     return ChooseTile(
    //                         mechanics[index].email.toString(),
    //                         mechanics[index].avatar.toString(),
    //                         mechanics[index].phoneNumber.toString(),
    //                         mechanics[index].name.toString(),
    //                         mechanics[index].loc!.address.toString(),
    //                         mechanics[index].type!,
    //                         mechanics[index].isCenter!);
    //                   },
    //                   itemCount: mechanics.length,
    //                   shrinkWrap: true,
    //                   padding: EdgeInsets.all(5),
    //                   scrollDirection: Axis.vertical,
    //                 ),
    //               ],
    //             );
    //           },
    //         );
    //       },
    //     ),
    //   ),
    // );
    //
    //   return Scaffold(
    //     body: Container(
    //       height: double.infinity,
    //       child: Center(
    //         child: RaisedButton(
    //           color: Color(0xFF193566),
    //           onPressed: () {
    //             showDialog(
    //                 context: context,
    //                 builder: (BuildContext context) {
    //                   return AlertDialog(
    //                     backgroundColor: Color(0xFFd1d9e6),
    //                     insetPadding: EdgeInsets.all(10),
    //                     contentPadding: EdgeInsets.zero,
    //                     clipBehavior: Clip.antiAliasWithSaveLayer,
    //                     scrollable: true,
    //                     title: Center(
    //                       child: Container(
    //                         child: Text(
    //                           "Pick Mechanic",
    //                           style: TextStyle(fontSize: 35),
    //                         ),
    //                       ),
    //                     ),
    //                     content: setupAlertDialoadContainer(context),
    //                   );
    //                 });
    //           },
    //           child: Text(
    //             "Choose Mechanic",
    //             style: TextStyle(color: Colors.white),
    //           ),
    //         ),
    //       ),
    //     ),
    //   );
    // }
    //
    // Widget setupAlertDialoadContainer(context) {
    //   var height = MediaQuery.of(context).size.height;
    //   var width = MediaQuery.of(context).size.width;
    //   return Column(
    //     children: [
    //       Container(
    //         color: Color(0xFFd1d9e6),
    //         height: height - 210,
    //         width: width + 400, // Change as per your requirement
    //         child: ListView.builder(
    //           padding: EdgeInsets.all(25),
    //           itemBuilder: (BuildContext, index) {
    //             return ChooseTile(
    //                 mechanics[index].email.toString(),
    //                 mechanics[index].avatar.toString(),
    //                 mechanics[index].phoneNumber.toString(),
    //                 mechanics[index].name.toString(),
    //                 mechanics[index].loc!.address.toString(),
    //                 mechanics[index].type!,
    //                 mechanics[index].isCenter!);
    //           },
    //           itemCount: mechanics.length,
    //           shrinkWrap: true,
    //           scrollDirection: Axis.vertical,
    //         ),
    //       ),
    //       Align(
    //         alignment: Alignment.bottomRight,
    //         child: FlatButton(
    //           color: Color(0xFF193566),
    //           onPressed: () {
    //             Navigator.pop(context);
    //           },
    //           child: Text(
    //             "Cancel",
    //             style: TextStyle(color: Colors.white),
    //           ),
    //         ),
    //       )
    //     ],
    //   );
//   }
// }
//     return Scaffold(
//         body: SlidingUpPanel(
//       minHeight: 90,
//       maxHeight: MediaQuery.of(context).size.height / 2,
//       backdropEnabled: true,
//       panel: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               child: ListView.builder(
//                 padding: EdgeInsets.all(25),
//                 itemBuilder: (BuildContext, index) {
//                   return ChooseTile(
//                       mechanics[index].email.toString(),
//                       mechanics[index].avatar.toString(),
//                       mechanics[index].phoneNumber.toString(),
//                       mechanics[index].name.toString(),
//                       mechanics[index].loc!.address.toString(),
//                       mechanics[index].type!,
//                       mechanics[index].isCenter!);
//                 },
//                 itemCount: mechanics.length,
//                 shrinkWrap: true,
//               ),
//             )
//           ],
//         ),
//       ),
//     ));
    return Scaffold(
        body: SlidingUpPanel(
      color: Color(0xFFd1d9e6),
      backdropEnabled: true,
      panelSnapping: true,
      minHeight: 50,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(50),
      ),
      defaultPanelState: PanelState.CLOSED,
      panelBuilder: (ScrollController sc) => Stack(children: [
        Padding(
          padding: const EdgeInsets.only(left: 160.0, top: 10),
          child: Container(
            //first container
            height: 20,
            width: 60,
            child: Padding(
              padding: EdgeInsets.only(bottom: 5, top: 5),
              child: RaisedButton(
                  color: Colors.white,
                  onPressed: () {},
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0))),
            ),
          ),
        ),
        // SizedBox(
        //   height: 40,
        // ),
        ListView.separated(
          itemCount: mechanics.length,
          controller: sc,
          itemBuilder: (BuildContext context, int index) {
            return ChooseTile(
                mechanics[index].email.toString(),
                mechanics[index].avatar.toString(),
                mechanics[index].phoneNumber.toString(),
                mechanics[index].name.toString(),
                mechanics[index].loc!.address.toString(),
                mechanics[index].type!,
                mechanics[index].isCenter!);
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              height: 5,
            );
          },
        )
      ]),
      collapsed: Container(),
    ));
  }
}
