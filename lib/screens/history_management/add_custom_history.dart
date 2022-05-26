import 'package:dropdown_button2/dropdown_button2.dart';
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

  const AddCustomHistory({Key? key}) : super(key: key);

  @override
  ConsumerState<AddCustomHistory> createState() => _AddCustomHistoryState();
}

class _AddCustomHistoryState extends ConsumerState<AddCustomHistory> {
  String? systemName, partId, partName, description;
  double? actualDistance, distance, partCost, maintenanceCost, otherCost;
  DateTime selectedTime = DateTime.now();

  late Car? dropDownValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFd1d9e6),
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
                    child: ref.watch(userProvider).cars.isNotEmpty
                        ? CustomDropdownMenu(
                            values: ref.watch(userProvider).cars,
                            defaultValue: ref.watch(userProvider).cars[0],
                            onItemSelected: (value) {
                              dropDownValue = value;
                            })
                        : Container(
                            child: Text("noCar".tr()),
                          )),

                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 20),
                        InputTextField(
                            hintText: 'systemName'.tr(),
                            fn: (String value) {
                              systemName = value;
                            }),
                        InputTextField(
                            hintText: 'partId'.tr(),
                            fn: (String value) {
                              partId = value;
                            }),
                        InputTextField(
                          hintText: 'partName'.tr(),
                          fn: (value) {
                            partName = value;
                          },
                        ),
                        InputTextField(
                          hintText: 'actualDistance'.tr(),
                          fn: (String value) {
                            actualDistance = double.parse(value.toString());
                          },
                        ),
                        InputTextField(
                          hintText: 'distance'.tr(),
                          fn: (String value) {
                            distance = double.parse(value.toString());
                          },
                        ),
                        InputTextField(
                          hintText: 'partCost'.tr(),
                          fn: (String value) {
                            partCost = double.parse(value.toString());
                          },
                        ),
                        InputTextField(
                          hintText: 'maintenanceCost'.tr(),
                          fn: (String value) {
                            maintenanceCost = double.parse(value.toString());
                          },
                        ),
                        InputTextField(
                          hintText: 'otherCost'.tr(),
                          fn: (String value) {
                            otherCost = double.parse(value.toString());
                          },
                        ),
                        BuildMultipleTextField(
                          hintText: 'description'.tr(),
                          fn: (String value) {
                            description = value;
                          },
                        ),
                        RaisedButton(
                          child: Text(
                            "submit".tr(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          color: const Color(0xFF193566),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          onPressed: () {
                            if (systemName == "") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('pleaseAddField'.tr())));
                              SnackBar(content: Text('pleaseAddField'.tr()));
                            } else if (dropDownValue!.model == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: const Text("plzSpecCar").tr()));
                              SnackBar(content: const Text('plzSpecCar').tr());
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

class CustomDropdownMenu extends StatefulWidget {
  const CustomDropdownMenu(
      {Key? key,
      required this.defaultValue,
      required this.values,
      required this.onItemSelected})
      : super(key: key);
  final dynamic Function(Car? selectedValue) onItemSelected;
  final Car defaultValue;
  final List<Car> values;

  @override
  _CustomDropdownMenuState createState() => _CustomDropdownMenuState();
}

class _CustomDropdownMenuState extends State<CustomDropdownMenu> {
  late Car dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(

          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          padding: const EdgeInsets.all(5.0),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Car>(
              value: dropdownValue,
              items: widget.values.map((dropValue) {
                return DropdownMenuItem<Car>(
                  value: dropValue,
                  child: Text(dropValue.noPlate),
                );
              }).toList(),
              onChanged: (newDropdownValue) {
                setState(() {
                  dropdownValue = newDropdownValue!;
                });
                widget.onItemSelected(newDropdownValue);
              },
            ),
          ),
        ),
      ],
    );
  }
}
