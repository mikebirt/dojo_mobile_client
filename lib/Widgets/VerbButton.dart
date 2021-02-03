import 'package:flutter/material.dart';
import 'package:verb_client/Widgets/styles.dart';

class VerbButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color backgroundColour;

  VerbButton(
      {@required this.text,
      @required this.onPressed,
      @required this.backgroundColour});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: SizedBox(
        child: RaisedButton(
            child: Text(text, style: Styles.generalTextSyle),
            onPressed: onPressed,
            disabledColor: Color.fromARGB(15, 0, 0, 0),
            disabledTextColor: Colors.grey,
            color: backgroundColour,
            textColor: Colors.white,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0))),
        width: double.infinity,
        height: 50,
      ),
    );
  }
}
