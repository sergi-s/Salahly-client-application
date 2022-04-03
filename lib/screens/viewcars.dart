import 'package:flutter/material.dart';



class ViewCars extends StatelessWidget {
  static final routeName = "/viewcars.dart";
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: CarCard(),
    );
  }
}

class CarCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: new EdgeInsets.only(left: 0.0, bottom: 8.0, right: 16.0),
      decoration: new BoxDecoration(color: Colors.blue),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [

          new SizedBox(
            width:0.0 ,
            height: 35.0,
          ),

          new Card(
            child: new Column(
              children: <Widget>[

                new Icon(Icons.invert_colors_on_sharp),
                new Text("Chassis Number: SV30-01xxxx",
                    style: new TextStyle(fontSize: 18.0)),
                new Padding(
                    padding: new EdgeInsets.all(7.0),
                    child: new Row(
                      children: <Widget>[

                        new Padding(
                          padding: new EdgeInsets.all(7.0),
                          child: new Text(
                            'Mg Car',
                            style: new TextStyle(fontSize: 18.0),
                          ),
                        ),

                        new Padding(
                          padding: new EdgeInsets.all(7.0),
                          child: new Text('Number Plate: س ق ه | 2111',
                              style: new TextStyle(fontSize: 18.0)),
                        )
                      ],
                    ))
              ],
            ),
          ),

          new Card(
            child: new Column(
              children: <Widget>[


                new Text("Chassis Number: SV30-01xxxx",
                    style: new TextStyle(fontSize: 18.0)),
                new Padding(
                    padding: new EdgeInsets.all(7.0),
                    child: new Row(
                      children: <Widget>[

                        new Padding(
                          padding: new EdgeInsets.all(7.0),
                          child: new Text(
                            'BYD',
                            style: new TextStyle(fontSize: 18.0),
                          ),
                        ),

                        new Padding(
                          padding: new EdgeInsets.all(7.0),
                          child: new Text('Number Plate: س ق ه | 2111',
                              style: new TextStyle(fontSize: 18.0)),

                        ),

                        new Icon(Icons.invert_colors_on_sharp),
                      ],
                    ))
              ],
            ),
          ),
          new Card(
            child: new Column(
              children: <Widget>[


                new Text("Chassis Number: SV30-01xxxx",
                    style: new TextStyle(fontSize: 18.0)),
                new Padding(
                    padding: new EdgeInsets.all(7.0),
                    child: new Row(
                      children: <Widget>[

                        new Padding(
                          padding: new EdgeInsets.all(7.0),
                          child: new Text(
                            'Bmw',
                            style: new TextStyle(fontSize: 18.0),
                          ),
                        ),

                        new Padding(
                          padding: new EdgeInsets.all(7.0),
                          child: new Text('Number Plate: س ق ه | 2111',
                              style: new TextStyle(fontSize: 18.0)),

                        ),
                        new Icon(Icons.invert_colors_on_sharp),
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}



