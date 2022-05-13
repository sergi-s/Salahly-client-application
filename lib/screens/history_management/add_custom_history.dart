import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slahly/classes/provider/user_data.dart';
import 'package:slahly/widgets/global_widgets/app_bar.dart';

import '../../classes/models/car.dart';

class AddCustomHistory extends StatelessWidget {
  static final routeName = "/add_custom_history";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: CustomHistory(),
    );
  }
}

class CustomHistory extends ConsumerStatefulWidget {
  @override
  ConsumerState<CustomHistory> createState() => _CustomHistoryState();
}

class _CustomHistoryState extends ConsumerState<CustomHistory> {
  String car = "Mg 6";

  String date = "20/12/2022";

  String location = "Sedi Gaber";

  String mechanic = "This Car good el good";

  String noplate = "س ق ه | 2544";
  DateTime selectedTime = DateTime.now();
  String dropDownValue = "Choose Car";
  late Car selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: salahlyAppBar(title: 'Add_History'.tr()),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Image.asset(
                //   'assets/images/car_management/report.png',
                //   fit: BoxFit.contain,
                //   height: 150,
                // ),
                Container(
                  height: 100,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.dateAndTime,
                    initialDateTime: DateTime.now(),
                    onDateTimeChanged: (DateTime newDateTime) {
                      //Do Some thing
                      selectedTime = newDateTime;
                    },
                    use24hFormat: false,
                  ),
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

                // DropdownButton<dynamic>(
                //   value: dropDownValue,
                //   icon: Icon(Icons.keyboard_arrow_down),
                //   items: ref.watch(userProvider).cars.map((dynamic items) {
                //     return DropdownMenuItem(
                //         value: items,
                //         child: Text(items,
                //             style: const TextStyle(
                //                 fontSize: 15, color: Colors.black)));
                //   }).toList(),
                //   onChanged: (dynamic? value) {
                //     setState(() {
                //       this.dropDownValue = value!;
                //       selected = map[this.dropdownvalue];
                //     });
                //   },
                // ),
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
                  decoration: InputDecoration(
                    labelText: 'Mechanic_Report',
                  ),
                  controller: TextEditingController(text: mechanic),
                  textInputAction: TextInputAction.newline,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
                Row(
                  children: [
                    FlatButton(
                      child: Text('Cancel'.tr()),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      textColor: Colors.white,
                      child: Text('Send'.tr()),
                      color: Color(0xFF193566),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
