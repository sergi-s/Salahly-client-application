import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/widgets/global_widgets/custom_row.dart';

import 'package:slahly/widgets/dialogues/rating.dart';

class Accordion extends StatefulWidget {
  RSA? rsa;

  Accordion({Key? key, this.rsa}) : super(key: key);

  @override
  _AccordionState createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  bool _showContent = false;
  List<Widget> reviewList = [];

  @override
  void initState() {
    reviewList = [];
    if (widget.rsa!.towProvider != null) {
      print("@@@@@@@${widget.rsa!.towProvider!.id}");
      reviewList.add(
        Center(
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF193566),
              ),
              onPressed: () {
                print(widget.rsa!.rsaID);
                // _showRatingDialog(widget.rsa!.towProvider!);

                rateServiceProvider(
                    widget.rsa!.towProvider!, widget.rsa!, context);
              },
              child: Text('${"review".tr()} ${"provider".tr()}')),
        ),
      );
    } else {
      print("asdasdasdasdasdasdasdasdasdasdasdasda");
    }

    if (widget.rsa!.mechanic != null) {
      reviewList.add(
        Center(
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF193566),
              ),
              onPressed: () {
                print(widget.rsa!.rsaID);
                // _showRatingDialog(widget.rsa!.mechanic!);

                rateServiceProvider(
                    widget.rsa!.mechanic!, widget.rsa!, context);
              },
              child: Text('${"review".tr()} ${"mechanic".tr()}')),
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: const Color(0xFFE8E8E8),
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: const EdgeInsets.all(10),
      child: Column(children: [
        ListTile(
            title: Row(
              children: [
                Text(
                  widget.rsa!.car!.noPlate,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                  _showContent ? Icons.arrow_drop_up : Icons.arrow_drop_down),
              onPressed: () {
                setState(() {
                  _showContent = !_showContent;
                });
              },
            )),
        _showContent
            ? Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      customRow(title: "requestType".tr(),content:
                      RSA
                          .requestTypeToString(widget.rsa!.requestType!)
                          .tr()),
                      Row(
                        children: [
                          widget.rsa!.mechanic!.phoneNumber != null
                              ? ElevatedButton.icon(
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(
                                        text:
                                            widget.rsa!.mechanic!.phoneNumber));
                                  },
                                  label: Text(
                                    widget.rsa!.mechanic!.phoneNumber!,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color(0xFFff193566)
                                        .withOpacity(0),
                                    elevation: 0,
                                    animationDuration: Duration.zero,
                                  ),
                                  icon: const Icon(
                                    Icons.car_repair,
                                    color: Colors.black,
                                    size: 25,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                      widget.rsa!.createdAt == null
                          ? Container()
                          : Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Text(
                                    "Date",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    DateFormat('yyyy-MM-dd – kk:mm')
                                        .format(widget.rsa!.createdAt!),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                              ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              widget.rsa!.mechanic!.address ?? "address",
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),

                          // SizedBox(height: 20),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: reviewList,
                      )
                    ]),
        )
            : Container()
      ]),
    );
  }
}

class CustomHistoryTile extends StatefulWidget {
  DateTime? dateTime;
  String? carNoPlate,
      systemName,
      partId,
      partName,
      actualDistance,
      distance,
      partCost,
      maintenanceCost,
      otherCost,
      description;
  Widget? delete;

  CustomHistoryTile({
    this.carNoPlate,
    this.systemName,
    this.dateTime,
    this.description,
    this.otherCost,
    this.maintenanceCost,
    this.partCost,
    this.partName,
    this.actualDistance,
    this.partId,
    this.distance,
    this.delete,
  });

  @override
  _CustomHistoryTileState createState() => _CustomHistoryTileState();
}

class _CustomHistoryTileState extends State<CustomHistoryTile> {
  bool _showContent = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: const Color(0xFFE8E8E8),
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: const EdgeInsets.all(10),
      child: Column(children: [
        ListTile(
            title: Row(
              children: [
                widget.carNoPlate == null
                    ? Container()
                    : Text(
                        widget.carNoPlate!,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                  _showContent ? Icons.arrow_drop_up : Icons.arrow_drop_down),
              onPressed: () {
                setState(() {
                  _showContent = !_showContent;
                });
              },
            )),
        _showContent
            ? Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (widget.systemName == null)
                          ? Container()
                          : customRow(
                              title: "System Name",
                              content: widget.systemName!),
                      (widget.dateTime == null)
                          ? Container()
                          : customRow(
                              title: "Date",
                              content: DateFormat('yyyy-MM-dd – kk:mm')
                                  .format(widget.dateTime!)),
                      const SizedBox(height: 5),
                      (widget.description == null)
                          ? Container()
                          : customRow(
                              title: "Description",
                              content: widget.description!)
                    ]),
              )
            : Container(),
        widget.delete ?? Container(),
      ]),
    );
  }
}
