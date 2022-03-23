import 'package:flutter/material.dart';
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/classes/models/mechanic.dart';
import 'package:slahly/abstract_classes/user.dart';
import 'package:easy_localization/easy_localization.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        title: Center(
          child: Text(("choose_mech".tr()),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black)),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 10),
            ListView.builder(
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
              padding: const EdgeInsets.all(5),
              scrollDirection: Axis.vertical,
            ),
          ],
        ),
      ),
    );
  }
}
