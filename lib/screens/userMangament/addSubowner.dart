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
        content: Text('Are u sure want to add Subowner ?'),
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
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFFd1d9e6),
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: const Color(0xFF193566),
          title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            // Image.asset(
            //   'assets/images/logo ta5arog white car.png',
            //   fit: BoxFit.contain,
            //   height: 32,
            // ),
          ]),
        ),
        body: CustomPaint(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Add Subowner",
                          style: TextStyle(fontSize: 40, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ]),
                  SizedBox(
                    height: 100,
                  ),

                  // Text(
                  //   " Sergi Samir",
                  //   style: TextStyle(fontSize: 30, color: Colors.black),
                  //   textAlign: TextAlign.center,
                  // ),
                  SizedBox(
                    width: 50,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(children: [
                    Container(
                      width: 250,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Enter Subowner Email",
                          filled: true,
                          fillColor: Color(0xFFd1d9e6).withOpacity(0.1),
                        ),
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: () => scanQRcode(),
                      child: const Icon(Icons.qr_code),
                      backgroundColor: Color(0xFF193566),
                    ),
                  ]),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Text('Choose Car',
                          style: TextStyle(fontSize: 25, color: Colors.black)),
                      SizedBox(width: 20),
                      DropdownButton(
                        value: dropdownvalue,
                        icon: Icon(Icons.keyboard_arrow_down),
                        items: items.map((String items) {
                          return DropdownMenuItem(
                              value: items,
                              child: Text(
                                items,
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ));
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

                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30.0,
                        backgroundImage: NetworkImage(""),
                        backgroundColor: Colors.blue,
                      ),
                      SizedBox(width: 50),
                      Text("Aya Adel", style: TextStyle(fontSize: 25))
                    ],
                  )
                ],
              ),
            ),
          ),
          painter: HeaderCurvedContainer(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showAlertbox(context);
          },
          child: const Icon(Icons.add),
          backgroundColor: Color(0xFF193566),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat);
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

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = const Color(0xFF193566);
    Path path = Path()
      ..relativeLineTo(0, 90)
      ..quadraticBezierTo(size.width / 2, 150, size.width, 90)
      ..relativeLineTo(0, -90)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
