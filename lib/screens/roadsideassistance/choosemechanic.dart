import 'package:flutter/material.dart';
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/classes/models/mechanic.dart';
import 'package:slahly/abstract_classes/user.dart';
import 'package:slahly/widgets/ChooseTile.dart';

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
        avatar: 'https://www.woolha.com/media/2020/03/eevee.png',
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
        'https://thumbs.dreamstime.com/b/default-avatar-photo-placeholder-profile-image-default-avatar-photo-placeholder-profile-image-eps-file-easy-to-edit-124557892.jpg'),
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


    return Scaffold(
      body: Container(
        height: double.infinity,
        child: Center(
          child: RaisedButton(
            color: Color(0xFF193566),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Color(0xFFd1d9e6),
                      insetPadding: EdgeInsets.all(10),
                      contentPadding: EdgeInsets.zero,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      scrollable: true,
                      title: Center(
                        child: Container(
                          child: Text(
                            "Pick Mechanic",
                            style: TextStyle(fontSize: 35),
                          ),
                        ),
                      ),
                      content: setupAlertDialoadContainer(context),
                    );
                  });
            },
            child: Text(
              "Choose Mechanic",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget setupAlertDialoadContainer(context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          color: Color(0xFFd1d9e6),
          height: height - 210,
          width: width + 400, // Change as per your requirement
          child: ListView.builder(
            padding: EdgeInsets.all(25),
            itemBuilder: (BuildContext, index) {
              return ChooseTile(
                  mechanics[index].email.toString(),
                  mechanics[index].avatar.toString(),
                  mechanics[index].phoneNumber.toString(),
                  mechanics[index].name.toString(),
                  mechanics[index].loc!.address.toString(),
                  mechanics[index].type!,
                  mechanics[index].isCenter!);
            },
            itemCount: mechanics.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: FlatButton(
            color: Color(0xFF193566),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}