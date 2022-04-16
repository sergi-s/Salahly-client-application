import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AddCustomHistory extends StatelessWidget {
  static final routeName = "/addcustomhistory";
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: TextFieldAlertDialog(),
    );
  }
}

class TextFieldAlertDialog extends StatelessWidget {
  String car = "Mg 6";
  String date = "20/12/2022";
  String location = "Sedi Gaber";
  String mechanic = "This Car good el good";
  String noplate = "س ق ه | 2544";
  _displayDialog(BuildContext context) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.all(8.0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            title: Text('Add_History'.tr()),
            content: Container(
                width: MediaQuery.of(context).size.width,
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
                        enabled: false,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Mechanic_Report'.tr(),
                        ),
                        controller: TextEditingController(text: mechanic),
                        textInputAction: TextInputAction.newline,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                      ),
                    ],
                  ),
                )),
            actions: <Widget>[
              new FlatButton(
                textColor: Colors.white,
                child: new Text('Send'.tr()),
                color: Colors.black,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('Cancel'.tr()),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add_History'.tr()),
      ),
      body: Center(
        child: RaisedButton(
          child: Text(
            'Problem'.tr(),
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.blueAccent,
          onPressed: () => _displayDialog(context),
        ),
      ),
    );
  }
}