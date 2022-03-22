import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
void main() => runApp(DescCarProblem());

class DescCarProblem extends StatelessWidget {
  static final routeName = "/Describeproblem.dart";
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: TextFieldAlertDialog(),
    );
  }
}

class TextFieldAlertDialog extends StatelessWidget {
  String intialvalue = "My car is broke and doesn't work".tr();
  _displayDialog(BuildContext context) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.all(8.0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            title: Text('Describe Your Problem'.tr()),
            content: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Image.asset('assets/images/Problem.jpeg'),
                  TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Enter Your Problem'.tr(),
                    ),
                    controller: TextEditingController(text: intialvalue),
                    textInputAction: TextInputAction.newline,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                ],
              ),
            ),
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
        title: Text('decribe problem page'.tr()),
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
