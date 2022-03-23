import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/classes/models/mechanic.dart';
import 'package:slahly/abstract_classes/user.dart';
import 'package:flutter/services.dart';

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
                "Factorya, shar3 45 odam mtafy 12311321312312hasdhdashjss221"),
        avatar: 'https://www.woolha.com/media/2020/03/eevee.png',
        email: 'email@yahoo.com'),
    Mechanic(
        name: 'Sergi Samir',
        email: 'mechanic@yahoo.com',
        type: Type.mechanic,
        phoneNumber: '0122321099',
        loc: CustomLocation(address: "sedigabr,180 3omrt y3okbyan"),
        isCenter: false,
        avatar:
            'https://thumbs.dreamstime.com/b/default-avatar-photo-placeholder-profile-image-default-avatar-photo-placeholder-profile-image-eps-file-easy-to-edit-124557892.jpg'),
    Mechanic(
        name: 'Mahmoud Magdy',
        type: Type.mechanic,
        email: 'Workshop@gmail.com',
        phoneNumber: '01550164495',
        loc: CustomLocation(address: "Miami, mostshafa 3m ahmed"),
        isCenter: true,
        avatar:
            'https://thumbs.dreamstime.com/b/default-avatar-photo-placeholder-profile-image-default-avatar-photo-placeholder-profile-image-eps-file-easy-to-edit-124557892.jpg')
  ];
  static final routeName = "/choosemechanicscreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        title: Center(
          child: Text("Choose mechanic",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black)),
        ),
        // title: Image.asset(
        //   'assets/images/logo1.png',
        //   alignment: Alignment.center,
        //   height: 200,
        //   width: 200,
        // ),
      ),
      body: Center(
        child: Column(
          children: [
            // Container(
            //     decoration: BoxDecoration(
            //   image: DecorationImage(
            //       image: AssetImage('assets/images/logo ta5arog 2.png'),
            //       alignment: Alignment.topCenter),
            // )),
            SizedBox(height: 10),
            // Text(
            //   "Choose mechanic",
            //   style: TextStyle(
            //     fontWeight: FontWeight.bold,
            //     fontSize: 24,
            //   ),
            // ),
            // SizedBox(height: 10),
            ListView.builder(
              itemBuilder: (BuildContext, index) {
                return MechanicTile(
                    mechanics[index].email.toString(),
                    mechanics[index].avatar.toString(),
                    mechanics[index].phoneNumber.toString(),
                    mechanics[index].name.toString(),
                    mechanics[index].loc!.address.toString(),
                    mechanics[index].isCenter!,
                    mechanics[index].type!);
              },
              itemCount: mechanics.length,
              shrinkWrap: true,
              padding: EdgeInsets.all(5),
              scrollDirection: Axis.vertical,
            ),
          ],
        ),
      ),
    );
  }
}

class MechanicTile extends StatelessWidget {
  String email;
  String avatar;
  String phone;
  String name;
  bool isCenter;
  String address;
  Type type;

  MechanicTile(this.email, this.avatar, this.phone, this.name, this.address,
      this.isCenter, this.type);

  @override
  Widget build(BuildContext context) {
    isCenter = type == Type.mechanic ? isCenter : false;
    return Container(
      height: 180,
      child: GestureDetector(
        onTap: () {
          print('card tapped');
        },
        child: Card(
          elevation: 5,
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(15.0),
          // ),
          child: Column(
            children: [
              Flexible(
                child: ListTile(
                  horizontalTitleGap: 20.0,
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(
                      avatar,
                    ),
                    radius: 30,
                  ),
                  title: Text(
                    name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  subtitle: Container(
                    child: Column(children: [
                      Row(
                        children: [
                          // Text(isCenter?? ((isCenter) ? "Center" : "Mechanic"),
                          // String a = b ?? 'Hello';
                          Text(
                              type != Type.mechanic
                                  ? ""
                                  : (isCenter)
                                      ? "Center"
                                      : "Mechanic",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)
                              //   color: Colors.pink,
                              //   size: 24.0,
                              //   semanticLabel:
                              //       'Text to announce in accessibility modes',
                              ),

                          //copy buttom
                          // Icon(
                          //   (isCenter) ? Icons.favorite : null,
                          //   color: Colors.pink,
                          //   size: 24.0,
                          //   semanticLabel:
                          //       'Text to announce in accessibility modes',
                          // )
                        ],
                      ),
                      Row(
                        children: [
                          // Text(
                          //   phone,
                          //   style: TextStyle(
                          //       fontWeight: FontWeight.bold, fontSize: 16),
                          // ),
                          // // Text(
                          // //   phone,
                          // //   style: TextStyle(
                          // //       fontWeight: FontWeight.bold, fontSize: 16),
                          // // ),

                          // mainAxisAlignment: MainAxisAlignment.end,

                          //copy buttom
                          Container(
                            //

                            child: ElevatedButton.icon(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: phone));
                              },
                              label: Text(
                                phone,
                                // textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                elevation: 0,
                                animationDuration: Duration.zero,
                              ),
                              icon: Icon(
                                Icons.copy,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            // padding: const EdgeInsets.symmetric(
                            //     horizontal: 83.0),
                            child: Text(
                              'Rating : 4.8',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),

                          // mechanics[index].isCenter? : null ,
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              address,
                              // softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          // SizedBox(height: 20),
                        ],
                      ),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
