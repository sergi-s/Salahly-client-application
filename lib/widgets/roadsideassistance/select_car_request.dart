import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slahly/classes/models/car.dart';
import 'package:slahly/classes/provider/rsadata.dart';
import 'package:slahly/classes/provider/user_data.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../utils/firebase/get_all_cars.dart';
import '../location/progressDialog.dart';

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
  List<Widget> selectCarRadioItems = [];
  Car? selectedCar;

  @override
  Widget build(BuildContext context) {
    getCarsRadio();
    return SlidingUpPanel(
        controller: widget.pc,
        panelSnapping: false,
        isDraggable: false,
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
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          ListView.separated(
                              itemBuilder: (context, index) =>
                                  selectCarRadioItems[index],
                              separatorBuilder: (context, index) =>
                                  const Divider(height: 5),
                              itemCount: selectCarRadioItems.length)
                        ], //[...getCarsRadio()],
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

  // List<Widget>
  getCarsRadio() async {
    // List<Widget> widgets = [];
    selectCarRadioItems = [];
    for (Car car in ref.watch(userProvider).cars) {
      selectCarRadioItems.add(
        RadioListTile<Car>(
          value: car,
          groupValue: selectedCar,
          //ref.watch(rsaProvider).car,
          toggleable: true,
          title: Text(car.noPlate),
          secondary: Text(
              (car.getCarAccess() == null) ? "" : car.getCarAccess()!.tr()),
          isThreeLine: true,
          subtitle: Text(car.model ?? ""),
          onChanged: (Car? currentCar) async {
            showDialog(
                context: context,
                builder: (BuildContext context) =>
                    ProgressDialog(message: "holdConfirmCar".tr()));
            bool isInConflict = await isCarInConflict(currentCar!.noChassis!);
            if (isInConflict) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("conflictExits".tr()),
              ));
              Navigator.pop(context);
              return;
            }
            bool isAvailable = await doesExistInRequest(currentCar.noChassis!);
            if (!isAvailable) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("carAlreadyInUse".tr()),
              ));
              Navigator.pop(context);
              return;
            }
            // print("Current User ${car.noPlate}");
            setState(() {
              selectedCar = currentCar;
            });
            Navigator.pop(context);
          },
          activeColor: const Color(0xFF193566),
        ),
      );
      selectCarRadioItems.add(Container(
        height: 10,
      ));
    }
    // return widgets;
  }

  chooseCarDialog() {
    //deprecated
    List<Widget> carsRadioButtons = getCarsRadio();
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
                child: ListView.separated(
                    itemBuilder: ((context, index) => carsRadioButtons[index]),
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(height: 5);
                    },
                    itemCount: carsRadioButtons.length),
              ),
              actions: [
                FloatingActionButton(
                    onPressed: () =>
                        print("carIs:${ref.watch(rsaProvider).car!.noPlate}"))
              ],
            ));
  }
}
