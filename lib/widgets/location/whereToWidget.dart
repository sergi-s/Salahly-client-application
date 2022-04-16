import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:slahly/widgets/location/divider.dart';

import 'divider.dart';

class WhereToWidget extends StatelessWidget {
  const WhereToWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 6),
          Text(
            "Hi_there".tr(),
            style: TextStyle(fontSize: 12),
          ),
          Text(
            "where_to".tr(),
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.black),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Search_drop_off".tr()),
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                    color: Colors.black54,
                    blurRadius: 6,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7)),
              ],
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Row(
            children: [
              Icon(Icons.home, color: Colors.grey),
              SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Add_home".tr()),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Your_living_home_address".tr(),
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 10),
          DividerWidget(),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.home, color: Colors.grey),
              SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Add_work".tr()),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Your_work_address".tr(),
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
