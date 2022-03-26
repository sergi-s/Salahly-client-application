import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:slahly/main.dart';
import 'package:firebase_core/firebase_core.dart';

class AddSubowner extends StatefulWidget {
  static final routeName = "/addSubowner";

  @override
  State<AddSubowner> createState() => _AddSubownerState();
}

class _AddSubownerState extends State<AddSubowner> {
  DatabaseReference subowners =
      FirebaseDatabase.instance.ref().child("subowners");
  Future<void> addUser() async {
    await subowners.set({
      "user_id": "user id ", //user id
      "Car_id": "car id" //car id
    });
  }

  Future showAlertbox(context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Warning'),
        content: Text('are u sure want to add subowner ?'),
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

  var items = ['Lada', 'BMW', 'FERARI', 'MARCEDES'];

  var name = ['sergi ', 'hesham'];

  String dropdownvalue = 'BMW';
  String qrCode = 'Unknown';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFffffff),
        body: Container(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                ),
                Text(
                  "Welcome!",
                  style: TextStyle(fontSize: 30, color: Colors.black),
                ),
                Text(
                  "Here you can Add Subowner",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                SizedBox(
                  height: 100,
                ),
                Row(
                  children: [
                    Text('Sergi Samir',
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 20,
                    ),
                    FloatingActionButton.extended(
                        onPressed: () => scanQRcode(),
                        label: Text('Qr Scanner'),
                        icon: Icon(Icons.qr_code))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Enter subwner email"),
                ),
                SizedBox(
                  height: 30,
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
                        return DropdownMenuItem(
                            value: items, child: Text(items));
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          this.dropdownvalue = value!;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showAlertbox(context);
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.green,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }

  Future<void> scanQRcode() async {
    // print('hello');
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Close', true, ScanMode.QR);
    } on PlatformException {
      qrCode = 'failed to get version';
    }
  }
}
