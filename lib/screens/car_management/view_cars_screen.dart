import 'package:flutter/material.dart';



class ViewCars extends StatelessWidget {
  static const routeName = "/viewcars";
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: ViewCards(),
    );
  }
}

class ViewCards extends  StatefulWidget {
  @override
  State<ViewCards> createState() => CarCard();
}

class CarCard extends State<ViewCards> {

  @override
  Widget build(BuildContext context) {

    List<Car> cars = [
      Car(name: "Mg 6", rollno: 1, year: "2022"),

      Car(name: "Bmw", rollno: 2, year: "2006"),
      Car(name: "BYD", rollno: 3, year: "2007"),

    ];

    var seen = Set<String>();
    List<Car> uniquelist = cars.where((student) => seen.add(student.name)).toList();
    //output list: John Cena, Jack Sparrow, Harry Potter

    return Scaffold(
        backgroundColor: const Color(0xFFd1d9e6),
        appBar: new AppBar(
          backgroundColor: const Color(0xFF193566),
          title: new Text("View Cars"),
        ), // appBar
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(20),
          child: Column(
            children:uniquelist.map((carname){
              return Container(
                  child: Card(
                      child:ListTile(
                        leading: Text(carname.rollno.toString(),
                          style: TextStyle(fontSize: 25),),
                        title: Text(carname.name),
                        subtitle: Text(carname.year),
                      )
                  )
              );
            }).toList(),
          ),
        )
    );
  }
}

class Car{
  String name, year;
  int rollno;

  Car({
    required this.name,
    required this.rollno,
    required this.year
  });
}