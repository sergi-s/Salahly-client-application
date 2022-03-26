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

class CarCard extends StatefulWidget {


  @override
  _CarCardState createState() => _CarCardState();
}

class _CarCardState extends State<CarCard> {

  var _addCard = 0;

  void _incrementCard()
  {
    setState(() {
      _addCard ++ ;
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text("App Bar"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCard,
        child: Icon(Icons.add),
      ),
      body:ListView.builder(
          itemCount: _addCard,
          itemBuilder: (context, index){
            return Card(
              child: Container(

                color:Colors.white12,
                child: Column(
                  children: [
                    TextField (
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "Car Model"

                      ),
                    ),
                    TextField (
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "Model Year"
                      ),
                    ),
                    TextField (
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "Number Plate"
                      ),
                    ),
                    TextField (
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "Color Pickes"
                      ),
                    ),
                    TextField (
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: " Chassis Number"
                      ),
                    ),
                  ],
                ),


              ),
            );
          }
      ),
    );
  }



}




