import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/widgets/dialogues/rating.dart';
import 'package:slahly/widgets/global_widgets/custom_row.dart';

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
    return Container(
      // color: Color(0xFFFAF9F6),
      child: Card(
        elevation: 10,
        semanticContainer: true,
        color: const Color(0xFFE8E8E8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: const EdgeInsets.all(10),
        child: Column(children: [
          ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: [
                  Text(
                    widget.rsa!.car!.noPlate,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),

                  // Text(
                  //   RSA.stateToString(widget.rsa!.state!),
                  //   style: const TextStyle(
                  //       fontWeight: FontWeight.bold, fontSize: 20),
                  // ),

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
                        customRow(
                            title: "requestType".tr(),
                            content: RSA
                                .requestTypeToString(widget.rsa!.requestType!)
                                .tr()),
                        (widget.rsa!.mechanic != null)
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  widget.rsa!.mechanic!.phoneNumber != null
                                      ? ElevatedButton.icon(
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(
                                                text: widget.rsa!.mechanic!
                                                    .phoneNumber));
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
                              )
                            : Container(),
                        widget.rsa!.createdAt == null
                            ? Container()
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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

                        (widget.rsa!.mechanic != null)
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Flexible(
                                    child: Text(
                                      widget.rsa!.mechanic!.address ??
                                          "address",
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),

                                  // SizedBox(height: 20),
                                ],
                              )
                            : Container(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: reviewList,
                        )
                      ]),
                )
              : Container()
        ]),
      ),
    );
  }
}

//TODO: 1- refactor codeak
//TODO: 2.0- add car name if possible

//TODO: 2.1- DATA in history: request type, car(name??numberPlate), date
//TODO: 2.2- add a icon
//TODO: text style in same color as the app bar
//el ba2y fl done page (mn el admin)

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
      color: Colors.white70,
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
                    : Center(
                      child: Text(
                          widget.carNoPlate!,
                          style: const TextStyle(color: Colors.indigo,
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                    ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                  _showContent ? Icons.arrow_drop_up : Icons.arrow_drop_down,color: Color(0xFF193566) ),
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
