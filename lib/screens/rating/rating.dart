import 'package:flutter/material.dart';
import 'package:rating_dialog/rating_dialog.dart';



class RatingScreen extends StatefulWidget {
  static final routeName = "/rating";

  @override
  Rating createState() => Rating();
}

class Rating extends State<RatingScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Rating '),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: Center(
          child: MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            color: Colors.cyan,
            padding: EdgeInsets.only(left: 30,right: 30),
            child: Text('Rating Dialog',style: TextStyle
              (color: Colors.white,fontSize: 15),
            ),
            onPressed: _showRatingDialog,
          ),
        ),
      ),
    );

  }

  void _showRatingDialog() {
    final _ratingDialog = RatingDialog(

      title: Text('Rate Your Order'),
      message: Text('Rating this Mechanic.'),
      image: Image.asset("assets/images/as.jpg",
        height: 100,),
      submitButtonText: 'Submit',
      onCancelled: () => print('cancelled'),
      onSubmitted: (response) {
        print('rating: ${response.rating}, '
            'comment: ${response.comment}');

        if (response.rating < 3.0) {
          print('response.rating: ${response.rating}');
        } else {
          Container();
        }
      },
    );

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _ratingDialog,
    );
  }

}
