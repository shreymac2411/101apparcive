import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  Color colour;
  String title;
  Function onPress;

  RoundedButton({required this.title, required this.colour, required this.onPress});

  //final bool _isDisable = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: ElevatedButton( // changer from Material button to Elevated button
          onPressed: onPress(), //_isDisable? null : onPressed(),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(266,47),
          ),

          // minWidth: 200.0,
          // height: 42.0,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}