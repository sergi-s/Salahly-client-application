import 'package:flutter/material.dart';
import 'package:slahly/widgets/login_signup/Input_container.dart';

class RounedInput extends StatelessWidget {
  const RounedInput({
    Key? key,

    required this.icon,
    required this.hint,
  }) : super(key: key);


  final IconData icon;
  final String hint;
  @override
  Widget build(BuildContext context) {
    return InputContainer(
      child:TextField(
      cursorColor: Colors.blue,
      decoration:InputDecoration(
          icon:   Icon(icon,color: Colors.blue,),
          hintText: hint,
          border: InputBorder.none,

      ),


    ),);
  }
}

