import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:verb_client/Domain/dojo.dart';

import '../VerbButton.dart';
import '../styles.dart';

class SessionReviewView extends StatelessWidget {
  final Dojo dojo;
  final int verbCount;
  final int correctlyAnswered;

  SessionReviewView(this.dojo, this.verbCount, this.correctlyAnswered);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Dojo: " + dojo.name),
          automaticallyImplyLeading: false,
        ),
        body: Center(
            child: Column(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(0, 60, 0, 80),
                child: Text(
                  "You scored " +
                      this.correctlyAnswered.toString() +
                      " out of " +
                      this.verbCount.toString(),
                  style: Styles.generalTextSyle,
                )),
            Text(getMessage(), style: Styles.generalTextSyle),
            Spacer(),
            VerbButton(
                text: "Continue",
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                backgroundColour: Colors.green)
          ],
        )));
  }

  String getMessage() {
    if (correctlyAnswered == verbCount) {
      return "Amazing - go you!";
    } else if (1 + correctlyAnswered == verbCount) {
      return "Pretty good - so close!";
    } else if (2 + correctlyAnswered == verbCount) {
      return "Not bad - keep practising!";
    } else {
      return "Keep practising - I believe in you!";
    }
  }
}
