import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slahly/classes/models/reminder.dart';
import 'package:slahly/screens/reminder/addReminderScreen.dart';
import 'package:slahly/widgets/global_widgets/app_bar.dart';

class ReminderScreen extends StatefulWidget {
  static const routeName = "/reminderscreen";

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
            content: const Text('notificationCreated').tr(),
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
  Future<void> cancelScheduledNotifications(Reminder rem) async {
    List<NotificationModel> deletereminder =
        await AwesomeNotifications().listScheduledNotifications();
    deletereminder.forEach((element) {
      String noonnote = rem.note??"";
      if ( element.content != null && element.content!.body!=null &&
          ( (rem.title+": "+noonnote) == element.content!.body!) && element.content!.id != null
      // &&
      //     element.content!.body != null &&
          ) {
        map[element.content!.body!] = false;
        // map[element.content!.body!]=true;
        reminder.remove(rem);
        AwesomeNotifications().cancel(element.content!.id!);
        setState(() {

        });
      }
    });
  }

  start() async {
    List<NotificationModel> reminders =
        await AwesomeNotifications().listScheduledNotifications();
    reminders.forEach((element) {
      if (element.content != null &&
          element.content!.body != null &&
          !(map.containsKey(element.content!.body))) {
        String note =( element.content!.payload != null &&  element.content!.payload!.containsKey("note"))? element.content!.payload!["note"]!: "";
        String title =( element.content!.payload != null &&  element.content!.payload!.containsKey("title"))? element.content!.payload!["title"]!: "";
        map[element.content!.body!] = true;
        reminder.add(Reminder(
            title: title,
            // date: "Hello"));
            date: element.content!.createdDate ??
                DateFormat('dd-MM-yyyy').format(DateTime.now()).toString(),
            note: note));
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
    final String? note=reminder.note;

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
                    'confirm',
                    style: TextStyle(
                      color: Color(0xFF193566),
                    ),
                  ).tr(),
                  content: const Text(''),
                  actions: <Widget>[
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(color: Colors.white),
                        backgroundColor: Colors.blueGrey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async{
                        await cancelScheduledNotifications(reminder);
                        Navigator.pop(context, 'delete'.tr());
                      },
                      icon: const Icon(
                        Icons.delete_outline_outlined,
                        color: Colors.white,
                      ),
                      label: const Text('delete',
                          style: TextStyle(
                            color: Colors.white,
                          )).tr(),
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(color: Colors.white),
                        backgroundColor: const Color(0xFF193566),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => {Navigator.pop(context, 'cancel'.tr())},
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      label:  Text('cancel'.tr(),
                          style: TextStyle(
                            color: Colors.white,
                          )).tr(),
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
                  leading: const Icon(CupertinoIcons.alarm,
                      color: Color(0xFF193566), size: 40),
                  title: Text(title,
                          textScaleFactor: 1.4,
                          style: const TextStyle(
                              color: Color(0xff193566),
                              fontWeight: FontWeight.bold))
                      .tr(),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(date,
                              textScaleFactor: 1.1,
                              style:  TextStyle(color: Colors.indigo.shade800))
                          .tr(),
                      Text(note??"",
                          // textScaleFactor: 1.1,
                          style: const TextStyle(color: Colors.black87))
                          .tr(),
                    ],
                  ),
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
      appBar: salahlyAppBar(title: "reminder".tr()),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
              children: reminder.map((p) {
            return personDetailCard(p, context);
          }).toList()),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        isExtended: true,
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF193566),
        onPressed: () {
          context.push(AddReminder.routeName);
          print("after add");
          start();
        },
      ),
    );
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