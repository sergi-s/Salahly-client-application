import 'package:flutter/material.dart';


class AddCars extends StatelessWidget {
  // This widget is the root of your application.
  static final routeName = "/addcarbutton.dart";
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

class AddCarDialog extends StatefulWidget {
  @override
  _AddCarDialogState createState() => _AddCarDialogState();
}

class _AddCarDialogState extends State<AddCarDialog> {
  var _addCard = 0;

  void _incrementCard() {
    setState(() {
      _addCard++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Car"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCard,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
          itemCount: _addCard,
          itemBuilder: (context, index) {
            return AlertDialog(
              title: Text('New Car'),
              content: Column(
                children: [
                  TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                        border: InputBorder.none, labelText: "Car Model"),
                  ),
                  TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none, labelText: "Model Year"),
                  ),
                  TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none, labelText: "Number Plate"),
                  ),
                  TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none, labelText: "Color Pickes"),
                  ),
                  TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none, labelText: " Chassis Number"),
                  ),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    setState(() {
                      Navigator.of(context).pop();
                    });
                  },
                ),
                FlatButton(
                  child: Text('Add'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }),
    );
  }
}
