import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slahly/classes/models/car.dart';
import 'package:slahly/classes/provider/user_data.dart';
import 'package:slahly/widgets/dialogues/customHistoryConfirmation.dart';
import 'package:slahly/widgets/global_widgets/app_bar.dart';
import 'package:slahly/widgets/login_signup/Input_container.dart';

class AddCustomHistory extends ConsumerStatefulWidget {
  static const routeName = "/add_custom_history";

  @override
  ConsumerState<AddCustomHistory> createState() => _AddCustomHistoryState();
}

class _AddCustomHistoryState extends ConsumerState<AddCustomHistory> {
  String? systemName, partId, partName, description;
  double? actualDistance, distance, partCost, maintenanceCost, otherCost;
  DateTime selectedTime = DateTime.now();
  late Car? dropDownValue = Car(noPlate: "There is no Car");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: salahlyAppBar(title: 'Add_History'.tr()),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: DateTime.now(),
                    onDateTimeChanged: (DateTime newDateTime) {
                      //Do Some thing
                      selectedTime = newDateTime;
                    },
                    use24hFormat: false,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.grey[200],
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.blueGrey,
                          blurRadius: 2.0,
                          spreadRadius: 0.0,
                          offset: Offset(3, 0),
                        ),
                      ]),

                  // dropdown below..
                  child: DropdownButton<Car>(
                    hint: const Text("selectCar"),
                    value: dropDownValue,
                    onChanged: (dynamic value) {
                      setState(() {
                        dropDownValue = value;
                      });
                    },
                    icon: const Padding(
                      padding: EdgeInsets.fromLTRB(120, 0, 0, 0),
                      child: Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFF193566),
                      ),
                    ),
                    items: ref.watch(userProvider).cars.map((Car car) {
                      return DropdownMenuItem<Car>(
                        value: car,
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            Text(
                              car.model!,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 20),
                        InputTextField(
                            hintText: 'System Name'.tr(),
                            fn: (String value) {
                              systemName = value;
                            }),
                        InputTextField(
                            hintText: 'Part Id'.tr(),
                            fn: (String value) {
                              partId = value;
                            }),
                        InputTextField(
                          hintText: 'Part Name'.tr(),
                          fn: (value) {
                            partName = value;
                          },
                        ),
                        InputTextField(
                          hintText: 'Actual Distance'.tr(),
                          fn: (String value) {
                            actualDistance = double.parse(value.toString());
                          },
                        ),
                        InputTextField(
                          hintText: 'Distance'.tr(),
                          fn: (String value) {
                            distance = double.parse(value.toString());
                          },
                        ),
                        InputTextField(
                          hintText: 'Part Cost'.tr(),
                          fn: (String value) {
                            partCost = double.parse(value.toString());
                          },
                        ),
                        InputTextField(
                          hintText: 'Maintance Cost'.tr(),
                          fn: (String value) {
                            maintenanceCost = double.parse(value.toString());
                          },
                        ),
                        InputTextField(
                          hintText: 'Other Cost'.tr(),
                          fn: (String value) {
                            otherCost = double.parse(value.toString());
                          },
                        ),
                        BuildMultipleTextField(
                          hintText: 'Description'.tr(),
                          fn: (String value) {
                            description = value;
                          },
                        ),
                        RaisedButton(
                          child: Text(
                            "Submit".tr(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          color: const Color(0xFF193566),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          onPressed: () {
                            if (systemName == "") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('please_add_fields'.tr())));
                              const SnackBar(
                                  content: Text('Please Add Fields'));
                            } else if (dropDownValue!.model == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Select a car plz")));
                              const SnackBar(content: Text('Select a car plz'));
                            } else {
                              confirmCustomHistory(context, ref,
                                  car: dropDownValue,
                                  actualDistance: actualDistance,
                                  dateTime: selectedTime,
                                  description: description,
                                  distance: distance,
                                  maintenanceCost: maintenanceCost,
                                  otherCost: otherCost,
                                  partCost: partCost,
                                  partId: partId,
                                  partName: partName,
                                  systemName: systemName);
                            }
                          },
                        ),
                        const SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  ),
                ),
                // Row(
                //   children: [
                //     FlatButton(
                //       child: Text('Cancel'.tr()),
                //       onPressed: () {
                //         Navigator.of(context).pop();
                //       },
                //     ),
                //     FlatButton(
                //       textColor: Colors.white,
                //       child: Text('Send'.tr()),
                //       color: const Color(0xFF193566),
                //       onPressed: () {
                //         Navigator.of(context).pop();
                //       },
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InputTextField extends StatelessWidget {
  InputTextField({
    Key? key,
    required this.hintText,
    required this.fn,
  }) : super(key: key);
  final String hintText;

  final TextEditingController _textEditingController = TextEditingController();
  final Function fn;

  @override
  Widget build(BuildContext context) {
    return InputContainer(
      child: TextField(
        onChanged: (value) {
          _textEditingController.text = value;
          fn(value);
        },
        cursorColor: Colors.blue,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class BuildMultipleTextField extends StatelessWidget {
  BuildMultipleTextField({
    Key? key,
    required this.hintText,
    required this.fn,
  }) : super(key: key);
  final String hintText;

  final TextEditingController _textEditingController = TextEditingController();
  final Function fn;

  @override
  Widget build(BuildContext context) {
    return InputContainer(
      child: TextField(
        onChanged: (value) {
          _textEditingController.text = value;
          fn(value);
        },
        cursorColor: Colors.blue,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
        maxLines: 10,
      ),
    );
  }
}
