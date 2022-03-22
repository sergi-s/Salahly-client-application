
import 'package:flutter/material.dart';

class WaitArrvial extends StatelessWidget {
  const WaitArrvial({Key? key}) : super(key: key);
  static final routeName = "/waitforarrvial";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // we have initialized active step to 0 so that
  // our stepper widget will start from first step
  int _activeCurrentStep = 0;

  TextEditingController Time = TextEditingController();
  TextEditingController Mi = TextEditingController();


  // Here we have created list of steps
  // that are required to complete the form
  List<Step> stepList() => [
    // This is step1 which is called Account.
    // Here we will fill our personal details
    Step(
      state: _activeCurrentStep <= 0 ? StepState.editing : StepState.complete,
      isActive: _activeCurrentStep >= 0,
      title: const Text('Received'),
      content: Container(
        child: Column(
          children: [
            Image.asset('assets/images/tow-truck.png'),



            Container(
              child:
              Text('Your Tow Truck is being prepared..',
                textAlign: TextAlign.start,
                style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),



              ),
            ),


          ],

        ),
      ),
    ),
    // This is Step2 here we will enter our address


    // This is Step3 here we will display all the details
    // that are entered by the user
    Step(
        state: StepState.complete,
        isActive: _activeCurrentStep >= 1,
        title: const Text('On The Way'),
        content: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                Image.asset('assets/images/tow-truck.png'),
                Column(
                mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(

                child:
                  Text('Estimated time: ${Time.text}',
                  textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),

                ),
                ),
                Container(
                    child: Text(' ${Mi.text}mi',
                  textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),

                )



                ),

          ])

              ],
            )))
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text('Waiting For Arrival',style: TextStyle(color: Colors.white), ),
      ),
      // Here we have initialized the stepper widget
      body: Stepper(
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Row(
            children: <Widget>[
              TextButton(
                onPressed: details.onStepContinue,
                child: const Text('NEXT'),
              ),
              TextButton(
                onPressed: details.onStepCancel,
                child: const Text('CANCEL'),
              ),

            ],
          );
        },

        type: StepperType.horizontal,
        currentStep: _activeCurrentStep,
        steps: stepList(),

        // onStepContinue takes us to the next step
        onStepContinue: () {
          if (_activeCurrentStep < (stepList().length - 1)) {
            setState(() {
              _activeCurrentStep += 1;
            });
          }
        },

        // onStepCancel takes us to the previous step
        onStepCancel: () {
          if (_activeCurrentStep == 0) {
            return;
          }

          setState(() {
            _activeCurrentStep -= 1;
          });
        },

        // onStepTap allows to directly click on the particular step we want


      ),
    );
  }
}


