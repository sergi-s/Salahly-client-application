import 'package:flutter/material.dart';

import 'Input_container.dart';


class RounedInput extends StatefulWidget {
  RounedInput({
    Key? key,
    required this.icon,
    required this.hint,
    required this.fn,
  }) : super(key: key);

  final IconData icon;
  final String hint;
  final Function fn;

  @override
  State<RounedInput> createState() => _RounedInputState();
}

class _RounedInputState extends State<RounedInput> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return InputContainer(
      child: TextField(
        onChanged: (value) {
          widget.fn(value);
          _textEditingController.text = value;
        },
        // controller: _textEditingController,
        cursorColor: Colors.blue[900],
        decoration: InputDecoration(
          icon: Icon(
            widget.icon,
            color: Color(0xFF193566),
          ),
          hintText: widget.hint,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
