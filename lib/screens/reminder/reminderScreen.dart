import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slahly/screens/reminder/addReminderScreen.dart';

class ReminderScreen extends StatefulWidget {
  static final routeName = "/reminderscreen";

  const ReminderScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}


class _ReminderScreenState extends State<ReminderScreen> {
  @override
  void initState(){
    super.initState();
start();
if(!isListening){
  isListening=true;
    AwesomeNotifications().createdStream.listen((notification) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reminder added Sucessfully'),
        ),

      );
start();
    });
  }}
static bool isListening =false;
  Map<String,bool> map={};
  // @override
  // void dispose() {
  //   AwesomeNotifications().actionSink.close();
  //   AwesomeNotifications().createdSink.close();
  //   super.dispose();
  // }

  Future<void> cancelScheduledNotifications() async {
   List<NotificationModel>deletereminder=await AwesomeNotifications().listScheduledNotifications();
   deletereminder.forEach((element) {
     if(element.content!= null && element.content!.body   !=  null && !(map.containsKey(element.content!.body))){
       map[element.content!.body!]=true;
       reminder.remove(element.content!.id);

   }});

  }

  start ()async{
    List<NotificationModel>reminders=await AwesomeNotifications().listScheduledNotifications();
    reminders.forEach((element) {
      if(element.content!= null && element.content!.body   !=  null && !(map.containsKey(element.content!.body))){
        map[element.content!.body!]=true;
        reminder.add(Reminder(title: element.content!.body! , date: element.content!.displayedDate??DateTime.now().toString()));

      }else{
        print("element not valid ");
      }
    });
    setState(() { });
  }


  List<Reminder> reminder = [

  ];

  Widget personDetailCard(Reminder reminder,BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final String title = reminder.title;
    final String date = reminder.date;

    return Container(
      height: size.height/8,
      alignment: Alignment.center,

      child: Center(
        child: Card(
          elevation:8,
          color: Colors.grey[200],
          shadowColor:Colors.blueGrey[600],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 25),
          child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          highlightColor: Colors.grey[200],
          onLongPress: (){
            // cancelScheduledNotifications();
            },
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
                      textStyle: const TextStyle(color: Colors.white),
                      backgroundColor: Colors.blueGrey[300],
                      shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => {Navigator.pop(context, 'Delete')},
                    icon: const Icon(Icons.delete_outline_outlined,color: Colors.white,),
                    label: const Text('Delete',style:TextStyle(color: Colors.white,)),
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(color: Colors.white),
                      backgroundColor: const Color(0xFF193566),
                      shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => {Navigator.pop(context, 'Okay')},
                    icon: const Icon(Icons.done,color: Colors.white,),
                    label: const Text('Okay',style:TextStyle(color: Colors.white,)),
                  ),
                ],
              ),
            );},
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
                subtitle: Text(date,
                        textScaleFactor: 1.1,
                        style: const TextStyle(color: Colors.black54))
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
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text(""),
          const Text(
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
              children: reminder.map((p) {
            return personDetailCard(p,context);
          }).toList()),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        isExtended: true,
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF193566),
        onPressed: () { context.push(AddReminder.routeName);
          print("after add");
          start();},
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
