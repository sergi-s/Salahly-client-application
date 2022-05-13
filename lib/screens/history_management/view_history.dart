import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:slahly/classes/provider/ongoing_data.dart';
import 'package:slahly/screens/history_management/accordion.dart';

import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/screens/history_management/add_custom_history.dart';

class ViewHistory extends ConsumerStatefulWidget {
  static const routeName = "/viewhistory";

  ViewHistory({Key? key}) : super(key: key);

  @override
  ConsumerState<ViewHistory> createState() => _ViewHistoryState();
}

class _ViewHistoryState extends ConsumerState<ViewHistory> {
  @override
  void initState() {
    super.initState();
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
            SingleChildScrollView(
              child: Builder(builder: (context) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      ListView.builder(
                        itemBuilder: (BuildContext context, index) {
                          if (ref.watch(HistoryProvider)[index].state !=
                                  RSAStates.canceled &&
                              ref.watch(HistoryProvider)[index].state !=
                                  RSAStates.done) {
                            return Container();
                          }
                          return Accordion(
                              rsa: ref.watch(HistoryProvider)[index]);
                        },
                        itemCount: ref.watch(HistoryProvider).length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(5),
                        scrollDirection: Axis.vertical,
                      ),
                    ],
                  ),
                );
              }),
            ),
            Builder(builder: (context) {
              return Scaffold(
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      ListView.builder(
                        itemBuilder: (BuildContext context, index) {
                          return Accordion(
                              rsa: ref.watch(HistoryProvider)[index]);
                        },
                        itemCount: ref.watch(HistoryProvider).length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(5),
                        scrollDirection: Axis.vertical,
                      ),
                    ],
                  ),
                ),
                floatingActionButton: ElevatedButton(
                  child: const Icon(Icons.add),
                  onPressed: () {
                    context.push(AddCustomHistory.routeName);
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
