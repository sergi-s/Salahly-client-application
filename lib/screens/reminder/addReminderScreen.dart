import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../widgets/reminder/MyInputField.dart';

class AddReminder extends StatefulWidget {
  static final routeName = "/addreminderscreen";

  const AddReminder({Key? key}) : super(key: key);

  @override
  _AddReminderState createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {
  // final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endTime = "9:30 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now());
  int _selectedRemind = 5;
  List<int> remindList = [0,5, 10, 15, 20];
  String _selectedRepeat = "None";
  List<String> repeatList = ["None", "Daily", "Weekly", "Month"];
  int _selectedColor = 0;
String title="";
String note="";
updateTitle(String tit){
  title=tit;
}
  updateNote(String not){
    note=not;
  }
  updateDate(DateTime date){
    _selectedDate=date;
  }
  updateStartTime(String st){
    _startTime=st;
  }
  updateEndTime(String et){
    _endTime=et;
  }
  updateReminder(int rem){
    _selectedRemind=rem;
  }
  updateSelectRepeat(String sp){
   _selectedRepeat=sp;
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFd1d9e6),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xFF193566),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(""),
          Text(
            "Reminder",
            style: TextStyle(
              fontSize: 25,
              letterSpacing: 1.5,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          Image.asset(
            'assets/images/logo white.png',
            fit: BoxFit.contain,
            height: 32,
          ),
        ]),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            // margin: const EdgeInsets.only(bottom: 20),
            // padding: const EdgeInsets.only(left: 25, right: 25),
            width: size.width * 0.88,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              MyInputField(
                title: "Title",
                hint: "Enter your title",
               fn:updateTitle ,
              ),
              MyInputField(
                title: "Note",
                hint: "Enter your note",
                fn: updateNote,

              ),
              MyInputField(
                fn: updateDate,
                title: "Date",
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: () {
                    _getDateFromUser();
                  },
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: MyInputField(
                        fn: updateStartTime,
                    title: 'Start Time',
                    hint: _startTime,
                    widget: IconButton(
                      onPressed: () {
                        _getTimeFromUser(isStartTime: true);
                      },
                      icon: const Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey,
                      ),
                    ),
                  )),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                      child: MyInputField(
                        fn:updateEndTime,
                    title: 'End Time',
                    hint: _endTime,
                    widget: IconButton(
                      onPressed: () {
                        _getTimeFromUser(isStartTime: false);
                      },
                      icon: const Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey,
                      ),
                    ),
                  ))
                ],
              ),
              // //Remind field
              MyInputField(
                fn: updateReminder,
                title: "Remind",
                hint: "$_selectedRemind minutes early",
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRemind = int.parse(newValue!);
                    });
                  },
                  underline: Container(
                    height: 0,
                  ),
                  elevation: 4,
                  iconSize: 32,
                  items: remindList.map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                      child: Text(value.toString()),
                      value: value.toString(),
                    );
                  }).toList(),
                ),
              ),
              // //Repeat field
              MyInputField(
                fn: updateSelectRepeat,
                title: "Repeat",
                hint: _selectedRepeat,
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRepeat = newValue!;
                    });
                  },
                  underline: Container(
                    height: 0,
                  ),
                  elevation: 4,
                  iconSize: 32,
                  items:
                      repeatList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      child: Text(value.toString()),
                      value: value,
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 50,
                    child: RaisedButton(
                      splashColor: Colors.white.withAlpha(30),
                      color: Color(0xFF193566),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Cancel Task",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    // width: 95,
                    height: 50,
                    child: RaisedButton(
                      splashColor: Colors.white.withAlpha(40),
                      color: Color(0xFF193566),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onPressed: () {
                       _validateData();

                        // showDialog(
                        //     context: context,
                        //     builder: (context) {
                        //       return Dialog(
                        //         shape: RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.circular(40)),
                        //         elevation: 16,
                        //         child: Container(
                        //           height:
                        //               MediaQuery.of(context).size.height / 4,
                        //           width: MediaQuery.of(context).size.width,
                        //           child: ListView(
                        //             children: <Widget>[
                        //               SizedBox(height: 20),
                        //               Text(
                        //                   "Are You Sure You Want To Add Reminder",
                        //                   style: TextStyle(
                        //                       decoration:
                        //                           TextDecoration.underline,
                        //                       fontSize:18,
                        //                       letterSpacing: 2,
                        //                       color: Color(0xFF193566),
                        //                       fontWeight: FontWeight.bold)),
                        //               Padding(
                        //                 padding: const EdgeInsets.only(
                        //                     left: 70, top: 20),
                        //                 child: Row(
                        //                   children: [
                        //                     RaisedButton(
                        //                       color: Colors.blueGrey[300],
                        //                       shape: RoundedRectangleBorder(
                        //                           borderRadius:
                        //                               BorderRadius.circular(
                        //                                   12)),
                        //                       onPressed: () {
                        //                         Navigator.of(context).pop();
                        //                       },
                        //                       child: Text(
                        //                         "Cancel",
                        //                         style: TextStyle(
                        //                             color: Colors.white),
                        //                       ),
                        //                     ),
                        //                     SizedBox(
                        //                       width: 10,
                        //                     ),
                        //                     RaisedButton(
                        //                       color: Color(0xFF193566),
                        //                       shape: RoundedRectangleBorder(
                        //                           borderRadius:
                        //                               BorderRadius.circular(
                        //                                   12)),
                        //                       onPressed: () {},
                        //                       child: Text(
                        //                         "Confirm",
                        //                         style: TextStyle(
                        //                             color: Colors.white),
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       );
                        //     });
                        // },
                      },
                      child: Text(
                        "Create Task",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  // Mybutton(label: "Cancel Task", onTap: () =>   Navigator.of(context).pop()),
                  //  Mybutton(label: "Create Task", onTap: () => _validateData())
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2023));
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var _pickedTime = await _showTimePicker();
    String _formattedTime = _pickedTime.formate(context);
    print("AAAAAAAAAAAAA");
    if (_pickedTime == null) {
      print("Time cancelled");
    } else if (isStartTime == true) {
      setState(() {
        print("BBBBBBBBBB");
        _startTime = _formattedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        print("CCCCCCCC");
        _endTime = _formattedTime;
      });
    }
  }

  _showTimePicker() async {
    return await showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
            hour: int.parse(_startTime.split(":")[0]),
            minute: int.parse(_startTime.split(":")[1].split(" ")[0])));
  }

  _validateData() {
    if (title==null ||title=="") {
      print(title+note+_selectedRepeat+_endTime+_startTime);

      ScaffoldMessenger.of(context).showSnackBar(
          // SnackBar(content: Text('please_add_fields'.tr())));
          const SnackBar(content: Text('Please Add Fields')));

      print("wsl ll end");
    } else {
      print("Controller Data");
      print(title+"  "+note+"  "+_endTime+"  "+_startTime+"  "+_selectedRepeat);
      print(_selectedDate);
      print(_selectedRemind);
    }
  }
}
// class TaskController extends GetxController {
//   void onReady() {
//     super.onReady();
//   }
//
// }
