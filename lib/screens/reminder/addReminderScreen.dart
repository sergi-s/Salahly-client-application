import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:slahly/screens/reminder/reminderScreen.dart';

import '../../utils/local_notifications/notifications.dart';
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
  DateTime? _selectedDate = DateTime.now();
  String _startTime = DateFormat("hh:mm a").format(DateTime.now());

  // int _selectedRemind = 5;
  // List<int> remindList = [0, 5, 10, 15, 20];
  String _selectedRepeat = "None";
  List<String> repeatList = ["None", "Daily", "Weekly", "Month"];

  TimeOfDay selectedTime = TimeOfDay.now();
  String title = "";
  String note = "";

  updateTitle(String tit) {
    title = tit;
  }

  updateNote(String not) {
    note = not;
  }

  updateDate(DateTime date) {
    _selectedDate = date;
  }

  updateStartTime(TimeOfDay st) {
    selectedTime = st;
  }

  // updateReminder(int rem) {
  //   _selectedRemind = rem;
  // }

  updateSelectRepeat(String sp) {
    _selectedRepeat = sp;
  }

  @override
  void initState() {
    // dateinput.text = "";
    // timeinput.text = "";
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Allow Notifications'),
            content: Text('Our app would like to send you notifications'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Don\'t Allow',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: () => AwesomeNotifications()
                    .requestPermissionToSendNotifications()
                    .then((_) => Navigator.pop(context)),
                child: Text(
                  'Allow',
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    });
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
          onPressed: () {
            context.go(ReminderScreen.routeName);
          },
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      MyInputField(
                        title: "Title",
                        hint: "Enter your title",
                        fn: updateTitle,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      MyInputField(
                        title: "Note",
                        hint: "Enter your note",
                        fn: updateNote,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      MyInputField(
                        fn: () {},
                        title: "Date",
                        hint: DateFormat.yMd().format(_selectedDate!),
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
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: MyInputField(
                              fn: () {},
                              title: 'Start Time',
                              hint:
                                  "${selectedTime.hour}:${selectedTime.minute}",
                              widget: IconButton(
                                onPressed: () {
                                  _selectTime(context);
                                },
                                icon: const Icon(
                                  Icons.access_time_rounded,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                              },
                              child: Text(
                                "Create Task".tr(),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          // Mybutton(label: "Cancel Task", onTap: () =>   Navigator.of(context).pop()),
                          //  Mybutton(label: "Create Task", onTap: () => _validateData())
                        ],
                      )
                    ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)));
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
        print(
            "Selected Date:HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH ${_selectedDate.toString()}");
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
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
    if (title == null || title == "") {
      print(title + note + _selectedRepeat + _startTime);

      ScaffoldMessenger.of(context).showSnackBar(
          // SnackBar(content: Text('please_add_fields'.tr())));
          SnackBar(content: Text('Please Add Fields'.tr())));

      print("wsl ll end");
    } else {
      print(title + " " + note + " " + _selectedRepeat + " ");
      print(_selectedDate);
      // print(_selectedRemind);
      print(selectedTime);
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            'Confirmation'.tr(),
            style: const TextStyle(
              color: Color(0xFF193566),
            ),
          ),
          content: const Text('Are you sure you Want To Save Data').tr(),
          actions: <Widget>[
            RaisedButton(
              color: Colors.blueGrey[300],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: Text(
                'Cancel'.tr(),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              color: Color(0xFF193566),
              onPressed: () {
                NotificationDateAndTime nwt = NotificationDateAndTime(
                    year: _selectedDate!.year,
                    month: _selectedDate!.month,
                    day: _selectedDate!.day,
                    timeOfDay: selectedTime);
                addReminder(
                    title: "Salhlay".tr(),
                    body: title,
                    notificationSchedule: nwt);
                Navigator.pop(context);
              },
              child: Text(
                'OK'.tr(),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }
    ;
  }
}
