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
import 'package:slahly/widgets/location/finalScreen.dart';

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
          .watch(HistoryProvider.notifier)
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
                          .watch(HistoryProvider.notifier)
                          .assignRequests(ref.watch(userProvider).cars);
                    });
                  },
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: ref.watch(HistoryProvider).length,
                      itemBuilder: (context, index) {
                        if (ref.watch(HistoryProvider)[index].state ==
                                RSAStates.cancelled ||
                            ref.watch(HistoryProvider)[index].state ==
                                RSAStates.done) {
                          return Container();
                        }
                        print(
                            " hello world ya rab ostor${ref.watch(HistoryProvider)[index].rsaID}");
                        return GestureDetector(
                          onTap: () {
                            context.push(RequestFullDataScreen.routeName,
                                extra: ref.watch(HistoryProvider)[index]);
                          },
                          child: Card(
                            elevation: 6,
                            margin: const EdgeInsets.all(14),
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 10.0,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(8.0),
                                color: const Color(0xFFd1d9e6),
                              ),
                              child: SingleChildScrollView(
                                child: ListTile(
                                  leading: CircleAvatar(
                                      backgroundImage: NetworkImage((ref
                                                  .watch(HistoryProvider)[index]
                                                  .mechanic ==
                                              null)
                                          ? ""
                                          : ref
                                              .watch(HistoryProvider)[index]
                                              .mechanic!
                                              .avatar
                                              .toString())),
                                  // Text(ongoingRequestsList[index].car!.noPlate),
                                  title: Row(
                                    children: [
                                      Text(
                                        (ref
                                                    .watch(
                                                        HistoryProvider)[index]
                                                    .mechanic ==
                                                null)
                                            ? "${'searching'.tr()}..."
                                            : ref
                                                .watch(HistoryProvider)[index]
                                                .mechanic!
                                                .name
                                                .toString()
                                                .capitalize(),
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF193566)),
                                      ),
                                      const Expanded(
                                          child: Divider(
                                        thickness: 0,
                                      )),
                                      (ref
                                                      .watch(HistoryProvider)[
                                                          index]
                                                      .mechanic !=
                                                  null &&
                                              ref
                                                      .watch(HistoryProvider)[
                                                          index]
                                                      .mechanic!
                                                      .rating !=
                                                  null)
                                          ? Text(
                                              ref
                                                  .watch(HistoryProvider)[index]
                                                  .mechanic!
                                                  .rating
                                                  .toString()
                                                  .capitalize(),
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Color.fromARGB(
                                                    255,
                                                    127,
                                                    97,
                                                    11,
                                                  )),
                                            )
                                          : Container(),
                                      const SizedBox(height: 50),
                                    ],
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Column(children: [
                                      Row(
                                        children: [
                                          Text(
                                            "at".tr() + " ",
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text(
                                            (ref
                                                            .watch(HistoryProvider)[
                                                                index]
                                                            .mechanic !=
                                                        null &&
                                                    ref
                                                            .watch(HistoryProvider)[
                                                                index]
                                                            .mechanic!
                                                            .address !=
                                                        null)
                                                ? ref
                                                    .watch(
                                                        HistoryProvider)[index]
                                                    .mechanic!
                                                    .address
                                                    .toString()
                                                    .capitalize()
                                                : "...",
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: Color(0xFF193566),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Text(
                                            "workingOn".tr() + " ",
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text(
                                              ref
                                                  .watch(HistoryProvider)[index]
                                                  .car!
                                                  .noPlate
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF193566))),
                                          const Expanded(
                                              child: Divider(
                                            thickness: 0,
                                          )),
                                          Text(
                                            ref
                                                .watch(HistoryProvider)[index]
                                                .car!
                                                .getCarAccess()
                                                .toString(),
                                          ).tr(),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Text("request".tr() + " ",
                                              style: const TextStyle(
                                                fontSize: 18,
                                              )),
                                          Text(
                                            RSA.requestTypeToString(ref
                                                .watch(HistoryProvider)[index]
                                                .requestType!),
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF193566)),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      (ref
                                                  .watch(HistoryProvider)[index]
                                                  .createdAt ==
                                              null)
                                          ? Container()
                                          : Row(
                                              children: [
                                                Text("When".tr() + " ",
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                    )),
                                                Text(
                                                  DateFormat(
                                                          'yyyy-MM-dd – kk:mm')
                                                      .format(ref
                                                          .watch(HistoryProvider)[
                                                              index]
                                                          .createdAt!),
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xFF193566)),
                                                ),
                                              ],
                                            ),
                                      const SizedBox(height: 5),
                                    ]),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              )),
            ),
          )),
    );
  }
}