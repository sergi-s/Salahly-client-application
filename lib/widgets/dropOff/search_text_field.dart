import "package:flutter/material.dart";

class SearchTextField extends StatefulWidget {
  SearchTextField(
      {Key? key,
      required this.icon,
      required this.hint,
      required this.textEditingController,
      required this.onTap})
      : super(key: key);
  final Icon icon;
  final String hint;
  final Function onTap;
  TextEditingController textEditingController;

  @override
  _SearchTextFieldState createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  build(BuildContext context) {
    return Row(
      children: [
        widget.icon,
        const SizedBox(width: 18),
        Expanded(
            child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextField(
              onChanged: (value) {
                widget.onTap(value);
              },
              controller: widget.textEditingController,
              decoration: InputDecoration(
                hintText: widget.hint,
                fillColor: Colors.grey[400],
                filled: true,
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.only(
                  left: 11,
                  top: 8,
                  bottom: 8,
                ),
              ),
            ),
          ),
        ))
      ],
    );
  }
}
