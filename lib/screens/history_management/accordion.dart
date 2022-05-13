import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';

class Accordion extends StatefulWidget {
  RSA? rsa;

  Accordion({this.rsa});

  @override
  _AccordionState createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
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
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              widget.rsa!.createdAt.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
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
                    ]),
              )
            : Container()
      ]),
    );
  }
}
