import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/classes/provider/ongoing_data.dart';
import 'package:slahly/classes/provider/user_data.dart';
import 'package:slahly/screens/roadsideassistance/request_full_data_screen.dart';
import 'package:slahly/widgets/global_widgets/app_bar.dart';

import 'package:slahly/widgets/requests/request_tile.dart';

class OngoingRequests extends ConsumerStatefulWidget {
  static const String routeName = "/ongoingRequests";

  const OngoingRequests({Key? key}) : super(key: key);

  @override
  ConsumerState<OngoingRequests> createState() => _OngoingRequestsState();
}

class _OngoingRequestsState extends ConsumerState<OngoingRequests> {
  // List<RSA> ongoingRequestsList = [];

  @override
  initState() {
    Future.delayed(Duration.zero, () {
      ref
          .watch(historyProvider.notifier)
          .assignRequests(ref.watch(userProvider).cars);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: salahlyAppBar(title: "viewOngoing".tr()),
          // drawer: salahlyDrawer(context),
          body: CustomPaint(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                color: Color(0xFFd1d9e6),
              ), // red as border color
              child: SafeArea(
                  child: AnimationLimiter(
                child: RefreshIndicator(
                  onRefresh: () {
                    return Future.delayed(const Duration(seconds: 2), () {
                      ref
                          .watch(historyProvider.notifier)
                          .assignRequests(ref.watch(userProvider).cars);
                    });
                  },
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: ref.watch(historyProvider).length,
                      itemBuilder: (context, index) {
                        if (ref.watch(historyProvider)[index].state ==
                                RSAStates.cancelled ||
                            ref.watch(historyProvider)[index].state ==
                                RSAStates.done) {
                          return Container();
                        }
                        print(
                            " hello world ya rab ostor${ref.watch(historyProvider)[index].rsaID}");
                        return GestureDetector(
                            onTap: () {
                              context.push(RequestFullDataScreen.routeName,
                                  extra: ref.watch(historyProvider)[index]);
                            },
                            child: RequestTile(
                                rsa: ref.watch(historyProvider)[index]));
                      }),
                ),
              )),
            ),
          )),
    );
  }
}