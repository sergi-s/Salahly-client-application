

import 'package:flutter/material.dart';
import 'package:slahly/widgets/login_signup/Input_container.dart';

class RounedPasswordInput extends StatelessWidget {
  const RounedPasswordInput({

    Key? key,
    required this.hint
  }) : super(key: key);

final String hint;

  @override
  Widget build(BuildContext context) {
    return InputContainer(
      child:TextField(

        cursorColor: Colors.blue,
        obscureText: true,
        decoration:InputDecoration(
          icon:   Icon(Icons.lock,color: Colors.blue,),
          hintText: hint,
          border: InputBorder.none,

        ),


      ),);
  }
}

