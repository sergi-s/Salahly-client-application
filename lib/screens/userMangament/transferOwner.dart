import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransferOwner extends StatefulWidget {
  static final routeName = "/transferOwner";

  @override
  State<TransferOwner> createState() => _TransferOwnerState();
}

class _TransferOwnerState extends State<TransferOwner> {
  String dropdownvalue = 'bmw';
  var items = ['lada', 'bmw', 'ferari', 'btngan'];

  Future showAlertbox(context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Result'),
        content: Text('press confirm to confirm ownership transfer'),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);

                // ShowSnackbar(context, info, index);
              },
              child: Text('Confirm')),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Back'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFffffff),
      body: Container(
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: Form(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 40,
            ),
            Text(
              "Welcome!",
              style: TextStyle(fontSize: 30, color: Colors.black),
            ),
            Text(
              "Here you can Transfer Ownership",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            SizedBox(
              height: 80,
            ),
            TextFormField(
              decoration:
                  InputDecoration(labelText: "Enter New Ownership email"),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Text('Choose Car',
                    style: TextStyle(fontSize: 20, color: Colors.black)),
                SizedBox(width: 20),
                DropdownButton(
                  value: dropdownvalue,
                  icon: Icon(Icons.keyboard_arrow_down),
                  items: items.map((String items) {
                    return DropdownMenuItem(value: items, child: Text(items));
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      this.dropdownvalue = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              height: 150,
            ),
            Center(
              child: TextButton(
                  child: Text("confirm transfer".toUpperCase(),
                      style: TextStyle(fontSize: 14)),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(15)),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.blue)))),
                  onPressed: () => showAlertbox(context)),
            ),
          ]),
        ),
      ),
    );
  }
}
