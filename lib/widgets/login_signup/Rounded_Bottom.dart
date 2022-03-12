import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,
    required this.title,
    required this.onPressedFunction
  }) : super(key: key);
  final Function onPressedFunction;
  final String title;

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onPressedFunction(),
      child: InkWell(
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
      ),
    );
  }
}