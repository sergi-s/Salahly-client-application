
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';


class SelectTextField extends StatefulWidget {

  final String hintText;
  final Function onChangedfunction;
  final List<String> items;
   SelectTextField({Key? key, required this.hintText,required this.onChangedfunction,required this.items }) : super(key: key);

  @override
  State<SelectTextField> createState() => _SelectTextFieldState();
}

class _SelectTextFieldState extends State<SelectTextField> {
  // final items = widget.items;
  String selectedValue ='Car Type';

 // late get hintText ;

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
      return Container(
         // height:70,
        child: Container(
         margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: size.width*0.8,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color:Colors.grey[200],
            boxShadow:[
              BoxShadow(
                color: Colors.blueGrey,
                blurRadius: 2.0,
                spreadRadius: 0.0,
                offset:Offset(3,0),

              ),
            ]
        ),

        // dropdown below..
        child: DropdownButtonFormField2<String>(

          decoration: InputDecoration(
            hintText: widget.hintText,
            border: InputBorder.none,
          ),
          // value: selectedValue,
          onChanged: (newValue) {
            setState(() => selectedValue = newValue!);
            widget.onChangedfunction(newValue);
          },
            items: widget.items
                .map<DropdownMenuItem<String>>(
            (String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
            ))
                .toList()
            ,

              // add extra sugar..
              icon: Padding(
                padding: EdgeInsets.fromLTRB(120,0,0,0),
                child: Icon(Icons.arrow_drop_down,color: Color(0xFF193566),),
              ),
              // iconSize: 50,
              // underline: SizedBox(),
            ),
          ),
      )

    ;
  }
}
