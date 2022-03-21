import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:slahly/classes/models/mechanic.dart';

class ChooseMechanicScreen extends StatelessWidget {
  ChooseMechanicScreen({Key? key}) : super(key: key);
  List<Mechanic> mechanics = [
    Mechanic(
        name: 'Ahmed tarek',
        email: 'Workshop',
        isCenter: true,
        avatar: 'https://www.woolha.com/media/2020/03/eevee.png'),
    Mechanic(
        name: 'Sergi Samir',
        email: 'mechanic',
        isCenter: false,
        avatar:
            'https://thumbs.dreamstime.com/b/default-avatar-photo-placeholder-profile-image-default-avatar-photo-placeholder-profile-image-eps-file-easy-to-edit-124557892.jpg'),
    Mechanic(
        name: 'Mahmoud Magdy',
        email: 'Workshop',
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
            SizedBox(height: 40),
            // Text(
            //   "Choose mechanic",
            //   style: TextStyle(
            //     fontWeight: FontWeight.bold,
            //     fontSize: 24,
            //   ),
            // ),
            SizedBox(height: 10),
            ListView.builder(
              itemBuilder: (BuildContext, index) {
                return Container(
                  height: 180,
                  child: Card(
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(15.0),
                    // ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage(
                              mechanics[index].avatar.toString(),
                            ),
                            radius: 25,
                          ),
                          title: Text(
                            mechanics[index].name.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          subtitle: Container(
                            child: Column(children: [
                              Row(
                                children: [
                                  Text(
                                    mechanics[index].email.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Icon(
                                    (mechanics[index].isCenter!)
                                        ? Icons.favorite
                                        : null,
                                    color: Colors.pink,
                                    size: 24.0,
                                    semanticLabel:
                                        'Text to announce in accessibility modes',
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
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),

                                  // mechanics[index].isCenter? : null ,
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 100.0,
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      child: Text('Confirm'),
                                      style: ElevatedButton.styleFrom(
                                          shape: StadiumBorder(),
                                          primary: Colors.blueGrey),
                                    ),
                                  )
                                ],
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
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
