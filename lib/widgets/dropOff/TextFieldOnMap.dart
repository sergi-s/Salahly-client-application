import "package:flutter/material.dart";

class TextFieldOnMap extends StatelessWidget {
  const TextFieldOnMap({
    Key? key,
    required this.textToDisplay,
    this.imageIconToDisplay,
    this.iconToDisplay,
    required this.isSelected,
    this.child,
  }) : super(key: key);

  final String textToDisplay;

  final ImageIcon? imageIconToDisplay;
  final Icon? iconToDisplay;
  final bool isSelected;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            isSelected
                ? BoxShadow(
                    color: Colors.black54,
                    blurRadius: isSelected ? 6 : 0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  )
                : BoxShadow(),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          iconToDisplay ?? imageIconToDisplay ?? const Icon(Icons.close),
          const SizedBox(width: 5),
          Text(
            textToDisplay,
            style: const TextStyle(fontSize: 17),
          ),
          const SizedBox(width: 5),
          child ?? const SizedBox(),
        ],
      ),
    );
  }
}
