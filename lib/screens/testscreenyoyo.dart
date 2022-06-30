import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../classes/firebase/nearbylocations.dart';
import 'homescreen.dart';
import 'login_signup/registration.dart';

class TestScreenAya extends StatefulWidget{
  TestScreenAya({Key? key}) : super(key: key);
  static final routeName = "/yoyotestscreen";
  @override
  _SetAvalability createState() => new _SetAvalability();


}
  NearbyLocations as=NearbyLocations();
  class _SetAvalability extends State<TestScreenAya>{
bool isAvailable=false;

 @override
 void initState(){
   super.initState();
   getSavedAvailability();
 }
 getSavedAvailability() async{
   SharedPreferences prefs = await SharedPreferences.getInstance();
   bool? isAvailableSP = prefs.getBool("isAvailable");
   if (isAvailableSP != null && isAvailableSP){
    isAvailable=true;}
   setState(() {});
 }
DateTime selectedDate = DateTime.now();

Future<void> _selectDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1920, 1),
      lastDate: DateTime(2101));
  if (picked != null && picked != selectedDate)
    setState(() {
      selectedDate = picked;
    });
}
TimeOfDay selectedTime = TimeOfDay.now();
Future<void>_selectTime(BuildContext context) async {
  final TimeOfDay? timeOfDay = await showTimePicker(
    context: context,
    initialTime: selectedTime,
    initialEntryMode: TimePickerEntryMode.dial,

  );
  if(timeOfDay != null && timeOfDay != selectedTime)
  {
    setState(() {
      selectedTime = timeOfDay;
    });
  }}
  @override
  Widget build(BuildContext context) {
   bool positive=false;

    return SizedBox(
      height: 100,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Container(
            //   child: ToggleSwitch(
            //     minWidth: 40.0,
            //     minHeight:25,
            //     initialLabelIndex: isAvailable?1:0,
            //     cornerRadius: 20.0,
            //     activeFgColor: Colors.white,
            //     inactiveBgColor: Colors.blueGrey.shade50,
            //     inactiveFgColor: Colors.white,
            //     totalSwitches: 2,
            //     labels: ['', ''],
            //     icons: [FontAwesomeIcons.close, FontAwesomeIcons.check],
            //     activeBgColors: [[Color(0xFF193566)],[Color(0xFF193566)]],
            //     onToggle: (index) async{
            //       if(index==0){
            //         print("isAvailable is false");
            //       await NearbyLocations.setAvailabilityOff();
            //       SharedPreferences prefs = await SharedPreferences.getInstance();
            //       prefs.setBool("isAvailable", false);
            //       }
            //       if(index==1){
            //         print("isAvailable is true");
            //         await NearbyLocations.setAvailabilityOn();
            //         SharedPreferences prefs = await SharedPreferences.getInstance();
            //         prefs.setBool("isAvailable", true);
            //       };
            //     },
            //   ),
            // ),
            // Container(
            //  child: RaisedButton(
            //     child: Text("Report!!!"),
            //     onPressed: (){  context.goNamed("ReportScreen",params: {"requestType":"wsa" ,"rsaId":"12345678"} );},
            //   ),
            // ),
          SizedBox(height: 50,),

            Container(
              child: RaisedButton(
                child: Text("Register!!!"),
                onPressed: (){  context.go(Registration.routeName, extra: "email") ;},
              ),
            ),
            SizedBox(height: 50,),
            Container(
              child: RaisedButton(
                child: Text("HomeScreen!!!"),
                onPressed: (){  context.go(HomeScreen.routeName);},
              ),
            ),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("${selectedDate.toLocal()}".split(' ')[0]),
          SizedBox(height: 20.0,),
          RaisedButton(
            onPressed: () => _selectDate(context),
            child: Text('Select date'),
          ),
          ],
        ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    _selectTime(context);
                    
                  },
                  child: Text("Choose Time"),
                ),
                Text("${selectedTime.hour}:${selectedTime.minute}"),
              ],
            ),
      ]),
    ));}
  }

