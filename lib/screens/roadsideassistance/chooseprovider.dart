import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/classes/models/towProvider.dart';

import 'choosemechanic.dart';

class ChooseProviderScreen extends StatelessWidget {
  static final routeName = "/chooseproviderscreen";
  List<TowProvider> providers = [
    TowProvider(
        nationalID: '123132',
        name: 'Ahmed tarek',
        phoneNumber: '01115612314',
        loc: CustomLocation(
            address:
                "Factorya, shar3 45 odam mtafy 12311321312312hasdhdashjss221"),
        avatar: 'https://www.woolha.com/media/2020/03/eevee.png',
        email: 'email@yahoo.com'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        title: Center(
          child: Text("Choose Provider",
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
                    providers[index].email.toString(),
                    providers[index].avatar.toString(),
                    providers[index].phoneNumber.toString(),
                    providers[index].name.toString(),
                    providers[index].isCenter!,
                    providers[index].loc!.address.toString());
              },
              itemCount: providers.length,
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
