import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'package:flutter/material.dart';

import 'Input_container.dart';

class DatePicker extends StatefulWidget {
  DatePicker(
      {Key? key,required this.hintText, required this.icon, required this.fn})
      : super(key: key);
  final dateController = TextEditingController();
  final String hintText;
  final IconData icon;
  final Function fn;


  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  _DatePickerState(
      {Key? key, })
     ;
  final dateController = TextEditingController();

  IconData? get icon => null;

  get hintText => null;

  get fn => null;
  @override
  void dispose() {
    // Clean up the controller when the widget is removed
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  InputContainer(
      child: TextField(
        onChanged: (value) {
          fn(value);

        },
        readOnly: true,
        controller: dateController,
        cursorColor: Colors.blue,
        decoration: InputDecoration(

          icon: Icon(
           icon,
            color: Colors.blue,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),onTap: () async {
    var date = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime(2100));
    dateController.text = date.toString().substring(0, 10);}
      ),
    // ); Stack(
    //   children: [
    //     Center(
    //         child: TextField(
    //       readOnly: true,
    //       controller: dateController,
    //       decoration: InputDecoration(hintText: 'Pick your Date'),
    //       onTap: () async {
    //         var date = await showDatePicker(
    //             context: context,
    //             initialDate: DateTime.now(),
    //             firstDate: DateTime(1900),
    //             lastDate: DateTime(2100));
    //         dateController.text = date.toString().substring(0, 10);
    //       },
    //     )),
    //   ],
    );
  }
}
