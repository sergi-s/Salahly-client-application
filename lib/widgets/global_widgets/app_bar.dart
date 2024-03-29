import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:slahly/classes/provider/user_data.dart';
import 'package:slahly/screens/userMangament/pofile.dart';

PreferredSizeWidget salahlyAppBar({String? title}) {
  return AppBar(
    title: title != null
        ? Text(title)
        : Image.asset('assets/images/logo white.png',
            fit: BoxFit.contain, scale: 50),
    centerTitle: true,
    backgroundColor: const Color(0xff193566),
    actions: [
      Consumer(
        builder: (context, ref, child) {
          return Container(
            // alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(left: 0.0, right: 10.0),
            child:
            // Container()
            GestureDetector(
              onTap: () => context.push(Profile.routeName),
              child: CircleAvatar(
                backgroundImage: NetworkImage(ref.watch(userProvider).avatar ??
                    "https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png"),
              ),
            ),
          );
        },
      )
    ],
    // flexibleSpace: Container(
    //   alignment: Alignment.centerRight,
    //   padding: const EdgeInsets.only(left: 0.0, right: 10.0),
    //   child: const CircleAvatar(
    //     backgroundImage: AssetImage('assets/images/tarek.jpg'),
    //   ),
    // ),
  );
}
