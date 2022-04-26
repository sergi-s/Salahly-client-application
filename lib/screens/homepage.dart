import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:slahly/screens/workshop_assistance/workshop_assistance_screen.dart';
import 'package:slahly/screens/myLocation/mylocationscreen.dart';
import 'package:slahly/widgets/gloable_widgets/app_bar.dart';
import 'package:slahly/widgets/gloable_widgets/app_drawer.dart';
import 'package:slahly/widgets/homepage/AppCard.dart';
import 'package:go_router/go_router.dart';

import 'dropOff_screens/dropOff_location_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = "/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: salahlyAppBar(),
      drawer: salahlyDrawer(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "welcome".tr(),
            textScaleFactor: 1.4,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xff193566)),
          ).tr(),
          CardWidget(
              fun: () {
                context.push(MyLocationScreen.routeName);
              },
              title: 'Roadside assistant',
              subtitle:
                  'Lorem ipsum dolor sit consectetur adipiscing sed do eiusmod tempor ',
              image: 'assets/images/tow-truck 2.png'),
          CardWidget(
              fun: () {
                context.push(WSAScreen.routeName);
              },
              title: 'Workshop assistant',
              subtitle:
                  'Lorem ipsum dolor sit consectetur adipiscing sed do eiusmod tempor',
              image: 'assets/images/mechanic.png'),
          CardWidget(
              fun: () {
                context.push(DropOffLocationScreen.routeName);
              },
              title: 'Tow Truck assistant',
              subtitle:
                  'Lorem ipsum dolor sit consectetur adipiscing sed do eiusmod tempor',
              image: 'assets/images/mechanic.png'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        isExtended: true,
        onPressed: () {},
        backgroundColor: const Color(0xff193566),
        child: Image.asset('assets/images/bot2.png'),
      ),
    );
  }
}
//TODO: el translate m4 byt3ml keda, fa edit it
// and complete translation
// TODO: add photo to TTA line:55
// Use state management to get user data
