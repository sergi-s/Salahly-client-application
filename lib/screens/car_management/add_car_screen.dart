import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AddCars extends StatelessWidget {
  static final routeName = "/addcarscreen";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AddCarDialog(),
    );
  }
}

class AddCarDialog extends StatelessWidget {
  final TextEditingController carModelController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController plateController = TextEditingController();
  final TextEditingController chasisController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  _displayDialog(BuildContext context) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.all(8.0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            title: Text('Add_Car'.tr(),
                style: TextStyle(
                  color: Color(0xFF193566),
                )),
            content: Container(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/car_management/addcar.png',
                        fit: BoxFit.contain,
                        height: 150,
                      ),
                      TextField(
                        enabled: false,
                        readOnly: true,
                        controller: carModelController,
                        decoration: InputDecoration(
                          labelText: 'Car_Model'.tr(),
                        ),
                        textInputAction: TextInputAction.newline,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                      ),
                      TextField(
                        enabled: false,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Model_Year'.tr(),
                        ),
                        controller: carModelController,
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
                        controller: numberController,
                        textInputAction: TextInputAction.newline,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                      ),
                      TextField(
                        enabled: false,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Chassis_Number'.tr(),
                        ),
                        controller: chasisController,
                        textInputAction: TextInputAction.newline,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                      ),
                    ],
                  ),
                )),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancel'.tr()),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                textColor: Colors.white,
                child: new Text('Send'.tr()),
                color: Color(0xFF193566),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add_Car'.tr()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
