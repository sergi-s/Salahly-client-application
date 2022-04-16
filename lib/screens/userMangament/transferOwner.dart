import 'package:easy_localization/easy_localization.dart';
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
        title: Text('Result'.tr()),
        content: Text('are you sure u want to+ confirm ownership transfer'),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);

                // ShowSnackbar(context, info, index);
              },
              child: Text('Confirm'.tr())),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('back'.tr()))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFd1d9e6),
      appBar: AppBar(
        elevation: 0,
        bottomOpacity: 0.0,
        backgroundColor: const Color(0xFF193566),
        // title: Center(
        //   child: Text('Manage Ownership',
        //       style: TextStyle(fontSize: 30, color: Colors.black)),
        // ),
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const []),
      ),
      body: CustomPaint(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: Form(
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Transfer Ownership".tr(),
                    style: TextStyle(fontSize: 35, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(
                height: 120,
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
                  Text('Choose_Car'.tr(),
                      style: TextStyle(fontSize: 25, color: Colors.black)),
                  SizedBox(width: 20),
                  DropdownButton(
                    value: dropdownvalue,
                    icon: Icon(Icons.keyboard_arrow_down),
                    items: items.map((String items) {
                      return DropdownMenuItem(
                          value: items,
                          child: Text(items,
                              style: TextStyle(
                                  fontSize: 20, color: Colors.black)));
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
                height: 30,
              ),
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
              ),
              SizedBox(
                height: 70,
              ),
              Container(
                  width: 300,
                  child: Center(
                    child: TextButton(
                        child: Text("Confirm_Transfer".tr(),
                            style:
                                // <<<<<<< HEAD
                                TextStyle(fontSize: 15, color: Colors.white)),
                        // >>>>>>> 931e111d966e6532a25d6451b6fa85ee81a45bd7
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.all(15)),
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFF193566)),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFF193566)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.blue)))),
                        onPressed: () => showAlertbox(context)),
                  )),
            ]),
          ),
        ),
        painter: HeaderCurvedContainer(),
      ),
    );
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
