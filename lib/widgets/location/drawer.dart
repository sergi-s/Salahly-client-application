import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'divider.dart';
//TODO: delete this
class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 165,
            child: DrawerHeader(
              decoration: BoxDecoration(color: Colors.white),
              child: Row(
                children: [
                  Image.asset(
                    "images/user_icon.png",
                    height: 65,
                    width: 65,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Profile name".tr(),
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text("Visit profile".tr()),
                    ],
                  )
                ],
              ),
            ),
          ),
          DividerWidget(),
          SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }
}
