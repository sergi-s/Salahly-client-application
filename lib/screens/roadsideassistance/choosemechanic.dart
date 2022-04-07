import 'package:flutter/material.dart';
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/classes/models/mechanic.dart';
import 'package:slahly/abstract_classes/user.dart';
import 'package:slahly/widgets/ChooseTile.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../widgets/WSA/choose_mech_slider.dart';

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
            'https://thumbs.dreamstime.com/b/default-avatar-photo-placeholder-profile-image-default-avatar-photo-placeholder-profile-image-eps-file-easy-to-edit-124557892.jpg',
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

  static const routeName = "/chooseMechanicScreen";
  final PanelController _pc = PanelController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            ElevatedButton(
              child: Text("Open"),
              onPressed: () => _pc.open(),
            ),
            ElevatedButton(
              child: Text("Close"),
              onPressed: () => _pc.close(),
            ),
            ChooseMechanicSlider(
              pc: _pc,
              mechanics: mechanics,
            )
          ],
        ),
      ),
    );
  }
}
