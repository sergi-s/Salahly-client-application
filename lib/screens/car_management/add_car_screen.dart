import 'package:flutter/material.dart';


class AddCars extends StatelessWidget {
  // This widget is the root of your application.
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
  String car = "Mg 6";
  String model = "2022";
  String noplate = "س ق ه | 2544";
  String color= "YELLOW";
  String Chassis = "SV30-01xxxx";

  _displayDialog(BuildContext context) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.all(8.0),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            title: Text('Add Car'),
            content: Container(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset
                        ('assets/images/car_management/addcar.png',
                        fit: BoxFit.contain,
                        height: 150,),
                      TextField(
                        enabled: false,
                        readOnly: true,

                        decoration: InputDecoration(
                          labelText: 'Car Model:',
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
                          labelText: 'Model Year',
                        ),
                        controller: TextEditingController(text: model),
                        textInputAction: TextInputAction.newline,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                      ),
                      TextField(
                        enabled: false,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Number Plate',
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
                          labelText: 'Color Pickes',
                        ),
                        controller: TextEditingController(text: color),
                        textInputAction: TextInputAction.newline,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                      ),
                      TextField(
                        enabled: false,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Chassis Number',
                        ),
                        controller: TextEditingController(text: Chassis),
                        textInputAction: TextInputAction.newline,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                      ),

                    ],
                  ),
                ) ),
            actions: <Widget>[
              new FlatButton(
                textColor: Colors.white,
                child: new Text('Send'),
                color: Colors.black,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('Cancel'),
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
        title: Text('Add Car'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:() =>_displayDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }
}