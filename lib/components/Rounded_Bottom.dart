import 'package:flutter/material.dart';

class RoundedButtom extends StatelessWidget {
  const RoundedButtom({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return InkWell(
      onTap: (){},
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width:size.width*0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color:Colors.grey,
        ),
        padding: EdgeInsets.symmetric(vertical:13),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}