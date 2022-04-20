import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AddCustomHistory extends StatelessWidget {
  static final routeName = "/add_custom_history";
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: CustomHistory(),
    );
  }
}

class CustomHistory extends StatelessWidget {
  String car = "Mg 6";
  String date = "20/12/2022";
  String location = "Sedi Gaber";
  String mechanic = "This Car good el good";
  String noplate = "س ق ه | 2544";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF193566),
        title: Text('Add_History'.tr()),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/car_management/report.png',
                  fit: BoxFit.contain,
                  height: 150,
                ),
                TextField(
                  enabled: false,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Date'.tr(),
                  ),
                  controller: TextEditingController(text: date),
                  textInputAction: TextInputAction.newline,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
                TextField(
                  enabled: false,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Car'.tr(),
                  ),
                  controller: TextEditingController(text: car),
                  textInputAction: TextInputAction.newline,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
                TextField(
                  enabled: false,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Number_Plate'.tr(),
                  ),
                  controller: TextEditingController(text: noplate),
                  textInputAction: TextInputAction.newline,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
                TextField(
                  enabled: false,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Location'.tr(),
                  ),
                  controller: TextEditingController(text: location),
                  textInputAction: TextInputAction.newline,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Mechanic_Report',
                  ),
                  controller: TextEditingController(text: mechanic),
                  textInputAction: TextInputAction.newline,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),

                Row(
                  children: [

                    FlatButton(
                      child: Text('Cancel'.tr()),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      textColor: Colors.white,
                      child: Text('Send'.tr()),
                      color: Color(0xFF193566),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),


              ],
            ),


          ),

        ),


      ),


    );
  }
}