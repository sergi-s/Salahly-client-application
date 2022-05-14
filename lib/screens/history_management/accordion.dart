import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:slahly/abstract_classes/user.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/widgets/global_widgets/custom_row.dart';

class Accordion extends StatefulWidget {
  RSA? rsa;

  Accordion({this.rsa});

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
                _showRatingDialog(widget.rsa!.towProvider!);
              },
              child: const Text("Review Tow Provider")),
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
                _showRatingDialog(widget.rsa!.mechanic!);
              },
              child: const Text("Review Mechanic")),
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
                widget.rsa!.state == RSAStates.done
                    ? const Icon(
                        Icons.check,
                        color: Colors.green,
                      )
                    : const Icon(Icons.access_time, color: Colors.grey),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            RSA
                                .requestTypeToString(widget.rsa!.requestType!)
                                .tr(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
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

  void _showRatingDialog(UserType toBeRated) {
    print("idddddddddd-> ${toBeRated.id!}");
    final _ratingDialog = RatingDialog(
      title: Text('Rate Please'),
      message: Text('Rate Your ${toBeRated.getUserType()}'),
      image: Image.asset(
        "assets/images/as.jpg",
        height: 100,
      ),
      submitButtonText: 'Submit',
      onCancelled: () => print('cancelled'),
      onSubmitted: (response) async {
        print('rating: ${response.rating}, '
            'comment: ${response.comment}');

        String childWho = (toBeRated.type == Type.mechanic)
            ? "mechanicsRequests"
            : "providersRequests";

        DataSnapshot old = await FirebaseDatabase.instance
            .ref()
            .child(childWho)
            .child(toBeRated.id!)
            .child(widget.rsa!.rsaID!)
            .child("rating")
            .get();

        await FirebaseDatabase.instance
            .ref()
            .child(childWho)
            .child(toBeRated.id!)
            .child(widget.rsa!.rsaID!)
            .child("rating")
            .set({"rating": response.rating, "review": response.comment});

        DataSnapshot ds = await FirebaseDatabase.instance
            .ref()
            .child("users")
            .child(toBeRated.id!)
            .child("rating")
            .get();

        int count = 0;
        if ((ds.child("count").value) != null) {
          count = int.parse((ds.child("count").value).toString());
        }

        double sum = 0;
        if ((ds.child("sum").value) != null) {
          sum = double.parse((ds.child("sum").value).toString());
        }
        if (old.value != null) {
          print("Test${old.child("rating").value}");
          sum -= double.parse(old.child("rating").value.toString());
          count -= 1;
        }
        sum += response.rating;
        count += 1;

        await FirebaseDatabase.instance
            .ref()
            .child("users")
            .child(toBeRated.id!)
            .child("rating")
            .set({"sum": sum, "count": count});
        //
        // if (response.rating < 3.0) {
        //   print('response.rating: ${response.rating}');
        // } else {
        //   Container();
        // }
      },
    );

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _ratingDialog,
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
