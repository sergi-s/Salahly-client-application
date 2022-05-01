import '../../classes/provider/user_data.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:slahly/utils/firebase/get_all_cars.dart';

class ViewCars extends StatelessWidget {
  static const routeName = "/viewcars";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ViewCards(),
    );
  }
}

class ViewCards extends ConsumerStatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends ConsumerState<ViewCards> {
  @override
  void initState() {
    allCars(ref);
    super.initState();
  }

  List plate = [];
  List year = [];
  List model = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: ref.watch(userProvider).cars.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                leading: Text(
                    ref.watch(userProvider).cars[index].noPlate.toString()),
                trailing: Text(
                  ref.watch(userProvider).cars[index].model.toString() +
                      "\t" +
                      ref.watch(userProvider).cars[index].carAccess.toString(),
                  style: TextStyle(color: Colors.green, fontSize: 15),
                ),
                title: Text("List item $index"));
          }),
    );
  }
}
