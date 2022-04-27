import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HoldPlease extends StatelessWidget {
  HoldPlease({
    Key? key,
    this.who,
  }) : super(key: key);
  String? who;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(width: 15),
          (who != null)
              ? Text(
                  "searching_for_$who".tr(),
                  style: const TextStyle(fontSize: 17),
                )
              : const Text(""),
        ],
      )),
    );
  }
}
