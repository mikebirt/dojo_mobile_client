import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:verb_client/Domain/dojo.dart';

import '../VerbButton.dart';
import '../styles.dart';

class SessionReviewView extends StatelessWidget {
  final Dojo dojo;
  final int verbCount;

  SessionReviewView(this.dojo, this.verbCount);

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
                  "You just practised " + this.verbCount.toString() + " verbs!",
                  style: Styles.generalTextSyle,
                )),
            Text("Go you!", style: Styles.generalTextSyle),
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
}
