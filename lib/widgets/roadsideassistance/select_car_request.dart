import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:slahly/classes/models/car.dart';
import 'package:slahly/classes/provider/rsadata.dart';
import 'package:slahly/classes/provider/user_data.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SelectCarRequest extends ConsumerStatefulWidget {
  SelectCarRequest({
    Key? key,
    required this.pc,
    required this.onTap,
  }) : super(key: key);
  PanelController pc;
  Function onTap;

  @override
  ConsumerState<SelectCarRequest> createState() => _SelectCarRequestState();
}

class _SelectCarRequestState extends ConsumerState<SelectCarRequest> {
  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
        controller: widget.pc,
        panelSnapping: true,
        isDraggable: true,
        minHeight: 0,
        defaultPanelState: PanelState.CLOSED,
        panelBuilder: (sc) {
          return DefaultTabController(
              length: 1,
              child: Scaffold(
                backgroundColor: const Color(0xFFd1d9e6),
                appBar: AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => widget.pc.close(),
                  ),
                  title: TabBar(tabs: [Tab(text: "Choose_Car".tr())]),
                  backgroundColor: const Color(0xFF193566),
                ),
                body: TabBarView(
                  children: [
                    Builder(builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 10, top: 15),
                        child: Column(
                          children: [...getCarsRadio()],
                        ),
                      );
                    }),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                    backgroundColor: const Color(0xFF193566),
                    child: const Icon(Icons.navigate_next_sharp),
                    onPressed: () {
                      if (selectedCar != null) {
                        ref.watch(rsaProvider.notifier).assignCar(selectedCar!);
                      }
                      widget.onTap();
                    }),
              ));
        });
  }

  Car? selectedCar;

  List<Widget> getCarsRadio() {
    List<Widget> widgets = [];
    for (Car car in ref.watch(userProvider).cars) {
      widgets.add(
        RadioListTile<Car>(
          value: car,
          groupValue: selectedCar,
          //ref.watch(rsaProvider).car,
          toggleable: true,
          title: Text(car.noPlate),
          secondary: Text(car.getCarAccess() ?? ""),
          isThreeLine:true,
          subtitle: Text(car.model  ?? ""),
          onChanged: (Car? currentCar) {
            print("Current User ${car.noPlate}");
            setState(() {
              selectedCar = currentCar;
            });
            // (currentCar == null)
            //     ? ref.watch(rsaProvider.notifier).assignCar(null)
            //     : ref.watch(rsaProvider.notifier).assignCar(currentCar!);
          },
          // selected: selectedCar,
          //ref.watch(rsaProvider).car == car,
          activeColor: const Color(0xFF193566),
        ),
      );
    }
    return widgets;
  }

  chooseCarDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              contentPadding: const EdgeInsets.only(left: 25, right: 25),
              title: const Center(child: Text("Choose Car")),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              content: SizedBox(
                height: 200,
                width: 300,
                child: SingleChildScrollView(
                    child: Column(children: getCarsRadio())),
              ),
              actions: [
                FloatingActionButton(
                    onPressed: () =>
                        print("carIs:${ref.watch(rsaProvider).car!.noPlate}"))
              ],
            ));
  }
}
