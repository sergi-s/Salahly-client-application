import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slahly/classes/provider/user_data.dart';

import '../../classes/provider/ongoing_data.dart';

class TestSergi extends ConsumerStatefulWidget {
  const TestSergi({Key? key}) : super(key: key);
  static const String routeName = "/testSergi";

  @override
  ConsumerState<TestSergi> createState() => _TestSergiState();
}

class _TestSergiState extends ConsumerState<TestSergi> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      print("ya rab bgad ${ref.watch(userProvider).cars}");
      ref
          .watch(historyProvider.notifier)
          .assignRequests(ref.watch(userProvider).cars);

      // print("ya rab bgad ${ref.watch(HistoryProvider).requests}");
      print("ya rab bgad ${ref.watch(historyProvider)}");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
