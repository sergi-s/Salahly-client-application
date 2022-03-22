

import 'package:flutter/material.dart';
import 'package:slahly/widgets/login_signup/Input_container.dart';

class RounedPasswordInput extends StatelessWidget {
   RounedPasswordInput({

    Key? key,
    required this.hint,
     required this.function,
  }) : super(key: key);

final String hint;
  final TextEditingController _textEditingController = TextEditingController();
  final Function function;
  @override
  Widget build(BuildContext context) {
    return InputContainer(
      child:TextField(

        onChanged: (value) {
          function(value);

        },
        controller: _textEditingController,
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

