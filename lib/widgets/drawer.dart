import 'package:flutter/material.dart';
import 'divider.dart';


class DrawerWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 165,
              child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.white),
                child: Row(
                  children: [
                    Image.asset("images/user_icon.png",height: 65,width: 65,)
                    ,SizedBox(width: 16,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Profile name",style: TextStyle(fontSize: 16),),
                        SizedBox(height: 6,),
                        Text("Visit profile"),

                      ],
                    )
                  ],
                ),
              ),
          ),
          DividerWidget(),
          SizedBox(height: 12,),

        ],
      ),
    );
  }
}
