import 'package:flutter/material.dart';
import 'package:slahly/abstract_classes/user.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

class Accordion extends StatefulWidget {
  String email;
  String avatar;
  String phone;
  String name;
  bool isCenter;
  String address;
  Type type;

  Accordion(this.email, this.avatar, this.phone, this.name, this.address,
      this.type, this.isCenter);

  @override
  _AccordionState createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  bool _showContent = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Color(0xFFE8E8E8),
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: const EdgeInsets.all(10),
      child: Column(children: [
        ListTile(
          title: Text(
            widget.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          trailing: IconButton(
            icon: Icon(
                _showContent ? Icons.arrow_drop_up : Icons.arrow_drop_down),
            onPressed: () {
              setState(() {
                _showContent = !_showContent;
              });
            },
          ),
        ),
        _showContent
            ? Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Column(children: [
              Row(
                children: [
                  Text(
                    widget.type != Type.mechanic
                        ? ""
                        : (widget.isCenter)
                        ? ("center".tr())
                        : ("mechanic".tr()),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: widget.phone));
                      },
                      label: Text(
                        widget.phone,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFff193566).withOpacity(0),
                        elevation: 0,
                        animationDuration: Duration.zero,
                      ),
                      icon: const Icon(
                        Icons.car_repair,
                        color: Colors.black,
                        size: 25,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      '20/2/2022 \n\nSedi Gaber',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      widget.type != Type.provider ? widget.address : "",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),

                  // SizedBox(height: 20),
                ],
              ),
            ]),
          ),
        )
            : Container()
      ]),
    );
  }
}
