import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localstore/localstore.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/classes/provider/ongoing_data.dart';
import 'package:slahly/classes/provider/user_data.dart';
import 'package:slahly/screens/history_management/accordion.dart';
import 'package:slahly/screens/history_management/add_custom_history.dart';

class ViewHistory extends ConsumerStatefulWidget {
  static const routeName = "/viewhistory";

  ViewHistory({Key? key}) : super(key: key);

  @override
  ConsumerState<ViewHistory> createState() => _ViewHistoryState();
}

class _ViewHistoryState extends ConsumerState<ViewHistory> {
  final db = Localstore.instance;

  StreamSubscription<Map<String, dynamic>>? _subscription;
  final _items = <String, Map>{};

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      //History
      ref
          .watch(historyProvider.notifier)
          .assignRequests(ref.watch(userProvider).cars);

      //Custom History
      final data = await db.collection('customHistory').get();
      // print("the saved custom history $data");

      _subscription = db.collection('customHistory').stream.listen((event) {
        setState(() {
          // print("event-=> ${event}");
          Map item = {};
          item['id'] = event['id'];
          item['carNoPlate'] = event['carNoPlate'];
          item['dateTime'] = event['dateTime'];
          item['systemName'] = event['systemName'];
          item['partName'] = event['partName'];
          item['description'] = event['description'];
          item['actualDistance'] = event['actualDistance'];
          item['distance'] = event['distance'];
          item['partCost'] = event['partCost'];
          item['maintenanceCost'] = event['maintenanceCost'];
          item['otherCost'] = event['otherCost'];

          _items.putIfAbsent(item['id'], () => item);
        });
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    if (_subscription != null) _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFd1d9e6),
        appBar: AppBar(
          backgroundColor: const Color(0xFF193566),
          bottom: TabBar(
            tabs: [
              Tab(text: "history".tr()),
              Tab(text: "customHistory".tr()),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Builder(builder: (context) {
              return ListView.builder(
                itemBuilder: (BuildContext context, index) {
                  if (
                      // ref
                      //             .watch(HistoryProvider)[
                      //                 (ref.watch(HistoryProvider).length - 1) -
                      //                     index]
                      //             .state !=
                      //         RSAStates.canceled &&
                      ref
                              .watch(historyProvider)[
                                  (ref.watch(historyProvider).length - 1) -
                                      index]
                              .state !=
                          RSAStates.done) {
                    return Container();
                  }
                  return Accordion(
                      rsa: ref.watch(historyProvider)[
                          (ref.watch(historyProvider).length - 1) - index]);
                },
                itemCount: ref.watch(historyProvider).length,
                shrinkWrap: true,
                padding: const EdgeInsets.all(5),
                scrollDirection: Axis.vertical,
              );
            }),
            Builder(builder: (context) {
              return Scaffold(
                body: ListView.builder(
                    itemCount: _items.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(5),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, index) {
                      final key = _items.keys.elementAt(index);
                      final item = _items[key]!;
                      return CustomHistoryTile(
                        carNoPlate: item['carNoPlate'],
                        dateTime: DateTime.parse(item['dateTime']),
                        systemName: item['systemName'],
                        partId: item['partId'],
                        description: item['description'],
                        partName: item['partName'],
                        actualDistance: item['actualDistance'],
                        distance: item['distance'],
                        partCost: item['partCost'],
                        maintenanceCost: item['maintenanceCost'],
                        otherCost: item['otherCost'],
                        delete: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              db
                                  .collection('customHistory')
                                  .doc(item['id'])
                                  .delete();
                              _items.remove(item['id']);
                            });
                          },
                        ),
                      );
                    }),
                floatingActionButton: ElevatedButton(
                  child: const Icon(Icons.add),
                  onPressed: () {
                    context.push(AddCustomHistory.routeName);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    primary: const Color(0xFF193566),
                    padding: const EdgeInsets.all(10),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}