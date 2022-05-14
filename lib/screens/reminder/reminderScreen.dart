import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slahly/screens/reminder/addReminderScreen.dart';
import 'package:slahly/widgets/global_widgets/app_bar.dart';

class ReminderScreen extends StatefulWidget {
  static final routeName = "/reminderscreen";

  ReminderScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  @override
  void initState() {
    super.initState();
    start();
    if (!isListening) {
      isListening = true;
      AwesomeNotifications().createdStream.listen((notification) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notification Created '),
          ),
        );
        start();
      });
    }
  }

  static bool isListening = false;
  Map<String, bool> map = {};

  // @override
  // void dispose() {
  //   AwesomeNotifications().actionSink.close();
  //   AwesomeNotifications().createdSink.close();
  //   super.dispose();
  // }

  start() async {
    List<NotificationModel> reminders =
        await AwesomeNotifications().listScheduledNotifications();
    reminders.forEach((element) {
      if (element.content != null &&
          element.content!.body != null &&
          !(map.containsKey(element.content!.body))) {
        map[element.content!.body!] = true;
        reminder.add(Reminder(
            title: element.content!.body!,
            // date: "Hello"));
        date: element.content!.createdDate ?? DateTime.now().add(Duration(days: 1)).toString()));
              //  DateTime.now().toString()));
      } else {
        print("element not valid ");
      }
    });
    setState(() {});
  }

  List<Reminder> reminder = [];

  Widget personDetailCard(Reminder reminder, BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final String title = reminder.title;
    final String date = reminder.date;

    return Container(
      height: size.height / 8,
      alignment: Alignment.center,
      child: Center(
        child: Card(
          elevation: 8,
          color: Colors.grey[200],
          shadowColor: Colors.blueGrey[600],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 25),
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            highlightColor: Colors.grey[200],
            onTap: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text(
                    'Confirmation',
                    style: TextStyle(
                      color: Color(0xFF193566),
                    ),
                  ),
                  content: const Text(''),
                  actions: <Widget>[
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        textStyle: TextStyle(color: Colors.white),
                        backgroundColor: Colors.blueGrey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => {Navigator.pop(context, 'Delete')},
                      icon: Icon(
                        Icons.delete_outline_outlined,
                        color: Colors.white,
                      ),
                      label: Text('Delete',
                          style: TextStyle(
                            color: Colors.white,
                          )),
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        textStyle: TextStyle(color: Colors.white),
                        backgroundColor: Color(0xFF193566),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => {Navigator.pop(context, 'Okay')},
                      icon: Icon(
                        Icons.done,
                        color: Colors.white,
                      ),
                      label: Text('Okay',
                          style: TextStyle(
                            color: Colors.white,
                          )),
                    ),
                  ],
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ListTile(
                  leading: Icon(CupertinoIcons.alarm,
                      color: Color(0xFF193566), size: 40),
                  title: Text(title,
                          textScaleFactor: 1.4,
                          style: TextStyle(
                              color: Color(0xff193566),
                              fontWeight: FontWeight.bold))
                      .tr(),
                  subtitle: Text(date,
                          textScaleFactor: 1.1,
                          style: TextStyle(color: Colors.black54))
                      .tr(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFd1d9e6),
      appBar: salahlyAppBar(title: "Reminder"),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
              children: reminder.map((p) {
            return personDetailCard(p, context);
          }).toList()),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        isExtended: true,
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF193566),
        onPressed: () {
          context.push(AddReminder.routeName);
          print("after add");
          start();
        },
      ),
    );
    ;
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = const Color(0xFF193566);
    Path path = Path()
      ..relativeLineTo(0, 50)
      ..quadraticBezierTo(size.width / 2, 90, size.width, 50)
      ..relativeLineTo(0, -50)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class Reminder {
  final String title;
  final String date;

  Reminder({
    required this.title,
    required this.date,
  });
}
