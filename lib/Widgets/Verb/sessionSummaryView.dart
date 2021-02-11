import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:verb_client/Domain/score.dart';

import '../VerbButton.dart';
import '../styles.dart';

class SessionSummaryView extends StatelessWidget {
  final String dojoName;
  final Score score;

  SessionSummaryView(this.dojoName, this.score);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Dojo: " + dojoName),
          automaticallyImplyLeading: false,
        ),
        body: _body(context));
  }

  Widget _body(BuildContext context) {
    return Center(
        child: Column(
      children: [
        Padding(
            padding: EdgeInsets.fromLTRB(0, 60, 0, 80),
            child: Text(
              "You scored " +
                  this.score.correctlyAnswered.toString() +
                  " out of " +
                  this.score.numberOfVerbs.toString(),
              style: Styles.generalTextSyle,
            )),
        Text(_getMessage(), style: Styles.generalTextSyle),
        Spacer(),
        VerbButton(
            text: "Continue",
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            backgroundColour: Colors.green)
      ],
    ));
  }

  String _getMessage() {
    if (score.correctlyAnswered == score.numberOfVerbs) {
      return "Amazing - go you!";
    } else if (1 + score.correctlyAnswered == score.numberOfVerbs) {
      return "Pretty good - so close!";
    } else if (2 + score.correctlyAnswered == score.numberOfVerbs) {
      return "Not bad - keep practising!";
    } else {
      return "Keep practising - I believe in you!";
    }
  }
}
