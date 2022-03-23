import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/classes/models/towProvider.dart';
import 'package:slahly/abstract_classes/user.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:slahly/widgets/ChooseTile.dart';

class ChooseProviderScreen extends StatelessWidget {
  static const routeName = "/chooseproviderscreen";
  List<TowProvider> providers = [
    TowProvider(
        nationalID: '123132',
        name: 'Ahmed tarek',
        phoneNumber: '01115612314',
        loc: CustomLocation(
            address:
                "Factorya, shar3 45 odam mtafy 12311321312312hasdhdashjss221",
            longitude: 11,
            latitude: 11),
        avatar: 'https://www.woolha.com/media/2020/03/eevee.png',
        email: 'email@yahoo.com',
        type: Type.provider),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        title: Center(
          child: Text(("choose_provider".tr()),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black)),
        ),
      ),
      body: Center(
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              enableDrag: true,
              isDismissible: true,
              builder: (BuildContext context) {
                return Column(
                  children: [
                    SizedBox(height: 10),
                    ListView.builder(
                      itemBuilder: (BuildContext, index) {
                        return ChooseTile(
                            providers[index].email.toString(),
                            providers[index].avatar.toString(),
                            providers[index].phoneNumber.toString(),
                            providers[index].name.toString(),
                            providers[index].loc!.address.toString(),
                            providers[index].type!,
                            false);
                      },
                      itemCount: providers.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.all(5),
                      scrollDirection: Axis.vertical,
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
