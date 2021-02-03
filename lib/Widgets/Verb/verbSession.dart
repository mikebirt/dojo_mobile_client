import 'package:flutter/material.dart';

import 'package:verb_client/DataServices/dojoDataService.dart';
import 'package:verb_client/Domain/dojo.dart';
import 'package:verb_client/Domain/verb.dart';
import 'package:verb_client/Domain/verbValidation.dart';
import 'package:verb_client/Widgets/Verb/sessionProgress.dart';
import 'package:verb_client/Widgets/Verb/sessionReviewView.dart';

import '../VerbButton.dart';
import '../styles.dart';

class VerbSession extends StatefulWidget {
  final Dojo dojo;

  VerbSession(this.dojo);

  @override
  _VerbSessionState createState() => _VerbSessionState(dojo);
}

class _VerbSessionState extends State<VerbSession> {
  final Dojo dojo;
  List verbList;
  int currentVerbIndex;
  bool readyToProgress;
  bool attemptWasCorrect;
  bool preventUserEntry;
  DojoDataService dojoSvc;
  String userAttempt;
  FocusNode inputFocusNode;

  _VerbSessionState(this.dojo);

  @override
  void initState() {
    dojoSvc = DojoDataService();

    currentVerbIndex = 0;
    userAttempt = '';
    readyToProgress = false;
    attemptWasCorrect = false;
    preventUserEntry = false;
    inputFocusNode = FocusNode();

    loadVerbsList();

    super.initState();
  }

  @override
  void dispose() {
    inputFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('userAttempt: ' + userAttempt);
    debugPrint('attemptWasCorrect : ' + attemptWasCorrect.toString());

    return Column(children: [
      SessionProgress(
          verbList != null ? verbList.length : 0, currentVerbIndex + 1),
      Padding(
          padding: EdgeInsets.fromLTRB(0, 90, 0, 20),
          child: Text(currentVerb().italian, style: Styles.largeTextSyle)),
      TextField(
        controller: TextEditingController(text: userAttempt),
        textAlign: TextAlign.center,
        style: Styles.generalTextSyle,
        decoration: InputDecoration(
            hintText: "Enter the English translation",
            hintStyle: Styles.hintTextStyle),
        autofocus: true,
        readOnly: preventUserEntry,
        focusNode: inputFocusNode,
        onSubmitted: (text) {
          setState(() {
            userAttempt = text;
          });
        },
      ),
      (readyToProgress == false
          ? Container()
          : Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text(getCheckResultMessage(),
                  style: Styles.generalTextSyle))),
      Spacer(),
      VerbButton(
          text: readyToProgress == true ? "Next" : "Check",
          onPressed: userAttempt == '' ? null : handleOnPressed,
          backgroundColour: readyToProgress == false
              ? Colors.green
              : attemptWasCorrect == true
                  ? Colors.green
                  : Colors.red),
    ]);
  }

  String getCheckResultMessage() {
    return attemptWasCorrect == true
        ? 'Correct!'
        : 'Not quite... It was: ' + currentVerb().english;
  }

  void handleOnPressed() {
    if (readyToProgress == false) {
      final isCorrect = VerbValidation.test(currentVerb().english, userAttempt);

      setState(() {
        readyToProgress = true;
        preventUserEntry = true;
        attemptWasCorrect = isCorrect;
      });
    } else {
      if (1 + currentVerbIndex == verbList.length) {
        MaterialPageRoute route = MaterialPageRoute(
            builder: (_) => SessionReviewView(dojo, verbList.length));
        Navigator.push(context, route);
      } else {
        setState(() {
          currentVerbIndex = currentVerbIndex + 1;
          userAttempt = '';
          readyToProgress = false;
          attemptWasCorrect = false;
          preventUserEntry = false;
        });

        inputFocusNode.requestFocus();
      }
    }
  }

  Verb currentVerb() {
    if (verbList == null || verbList.length == 0) {
      return Verb("", "");
    }

    return verbList[currentVerbIndex];
  }

  void loadVerbsList() async {
    final List verbs = await dojoSvc.getVerbs(this.dojo.id);

    if (verbs != null) {
      setState(() {
        verbList = verbs;
      });
    }
  }
}
