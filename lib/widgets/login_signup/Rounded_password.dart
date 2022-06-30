

import 'package:flutter/material.dart';


import 'Input_container.dart';

class RounedPasswordInput extends StatefulWidget {
  RounedPasswordInput({

    Key? key,
    required this.hint,
    required this.function,
  }) : super(key: key);

  final String hint;
  final Function function;

  @override
  State<RounedPasswordInput> createState() => _RounedPasswordInputState();
}

class _RounedPasswordInputState extends State<RounedPasswordInput> {
  final TextEditingController _textEditingController = TextEditingController();

  bool _passwordVisible=false;

  @override
  Widget build(BuildContext context) {
    return InputContainer(
      child:TextField(

        onChanged: (value) {
          _textEditingController.text=value;
          widget.function(value);

        },
        cursorColor: Colors.blue,
        obscureText: !_passwordVisible,
        decoration:InputDecoration(
          icon:InkWell(onTap:() {   setState(() {
            _passwordVisible = !_passwordVisible;
          });},
            child: Icon(
              _passwordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,color: Color(0xFF193566),),
          ),
          hintText: widget.hint,
          border: InputBorder.none,

          // onPressed: () {
          //   // Update the state i.e. toogle the state of passwordVisible variable
          //   setState(() {
          //     _passwordVisible = !_passwordVisible;
          //   });
          // },
        ),
      ),


    );
  }
}

