import "package:flutter/material.dart";

void requestConfirmationDialogue(context,
    {required List<Widget> contentChildren,
    required List<Widget> titleChildren,
    required List<Widget> actionChildren}) {
  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: titleChildren),
          content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: contentChildren),
          actions: actionChildren));
}
