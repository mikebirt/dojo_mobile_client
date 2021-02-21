import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:verb_client/Domain/Entities/score.dart';
import 'package:verb_client/Domain/Entities/sessionSummary.dart';
import 'package:verb_client/Widgets/VerbButton.dart';
import 'package:verb_client/Widgets/styles.dart';

class CompletedDialog extends StatelessWidget {
  final SessionSummary sessionSummary;

  CompletedDialog(this.sessionSummary);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("Complete!"),
      children: [
        Center(
            child: Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Text(
                  "You scored " +
                      sessionSummary.score.correctlyAnswered.toString() +
                      " out of " +
                      sessionSummary.score.numberOfVerbs.toString(),
                  style: Styles.generalTextSyle,
                ))),
        Center(
            child: Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Text(_getMessage(sessionSummary.score),
                    style: Styles.generalTextSyle))),
        VerbButton(
            text: "Continue",
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            backgroundColour: Colors.green)
      ],
    );
  }

  String _getMessage(Score score) {
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
