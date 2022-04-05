import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HoldPlease extends StatelessWidget {
  const HoldPlease({
    Key? key,
    required this.who,
  }) : super(key: key);
  final String who;

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
          Text(
            "searching_for_$who".tr(),
            style: const TextStyle(fontSize: 17),
          )
        ],
      )),
    );
  }
}
