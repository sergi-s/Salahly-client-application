import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slahly/screens/reminder/addReminderScreen.dart';

class ReminderScreen extends StatelessWidget {
  static final routeName = "/reminderscreen";

  ReminderScreen({
    Key? key,
  }) : super(key: key);
  List<Reminder> Clients = [
    Reminder(
      title: 'Air Condition',
      date: '10:30 AM',
    ),
    Reminder(
      title: 'Tires',
      date: '05:30 PM',
    ),
    Reminder(
      title: 'Motor',
      date: '09:30 PM ',
    )
  ];

  Widget personDetailCard(Reminder,BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final String title = Reminder.title;
    final String date = Reminder.date;

    return Container(
      height: size.height/8,
      alignment: Alignment.center,

      child: Center(
        child: Card(
          elevation:5,
          color: Colors.grey[200],
          shadowColor:Colors.blueGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 25),
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
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
                      shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => {Navigator.pop(context, 'Delete')},
                    icon: Icon(Icons.delete_outline_outlined,color: Colors.white,),
                    label: Text('Delete',style:TextStyle(color: Colors.white,)),
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(color: Colors.white),
                      backgroundColor: Color(0xFF193566),
                      shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => {Navigator.pop(context, 'Okay')},
                    icon: Icon(Icons.done,color: Colors.white,),
                    label: Text('Okay',style:TextStyle(color: Colors.white,)),
                  ),
                ],
              ),
              );},
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
                  subtitle: Text(title,
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
          child: Column(
              children: Clients.map((p) {
            return personDetailCard(p,context);
          }).toList()),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        isExtended: true,
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF193566),
        onPressed: () { context.push(AddReminder.routeName);},
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
