import 'package:flutter/material.dart';
import 'package:verb_client/Blocs/dojoBloc.dart';

import 'package:verb_client/Domain/dojo.dart';
import 'package:verb_client/Domain/score.dart';
import 'package:verb_client/Domain/sessionSummary.dart';
import 'package:verb_client/Domain/verb.dart';
import 'package:verb_client/Domain/verbValidation.dart';
import 'package:verb_client/Widgets/Verb/sessionProgress.dart';
import 'package:verb_client/Widgets/Verb/sessionSummaryView.dart';

import '../VerbButton.dart';
import '../styles.dart';

class VerbSession extends StatefulWidget {
  final Dojo dojo;
  final int dojoDbId;
  final List<Verb> verbList;

  VerbSession(this.verbList, this.dojo, this.dojoDbId);

  @override
  _VerbSessionState createState() =>
      _VerbSessionState(verbList, dojo, dojoDbId);
}

class _VerbSessionState extends State<VerbSession> {
  final Dojo dojo;
  final int dojoDbId;
  final List<Verb> verbList;
  int currentVerbIndex;
  bool readyToProgress;
  bool attemptWasCorrect;
  bool preventUserEntry;
  FocusNode inputFocusNode;
  TextEditingController verbEntryController;
  int numberAnsweredCorrectly = 0;
  DojoBloc dojoBloc;

  _VerbSessionState(this.verbList, this.dojo, this.dojoDbId);

  @override
  void initState() {
    currentVerbIndex = 0;
    readyToProgress = false;
    attemptWasCorrect = false;
    preventUserEntry = false;
    inputFocusNode = FocusNode();
    verbEntryController = new TextEditingController();
    dojoBloc = DojoBloc();

    verbEntryController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    inputFocusNode.dispose();
    verbEntryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SessionProgress(
          verbList != null ? verbList.length : 0, currentVerbIndex + 1),
      Spacer(),
      Text(_currentVerb().italian, style: Styles.largeTextSyle),
      TextField(
        controller: verbEntryController,
        textAlign: TextAlign.center,
        style: Styles.generalTextSyle,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: "Enter the English translation",
            hintStyle: Styles.hintTextStyle),
        autofocus: true,
        readOnly: preventUserEntry,
        focusNode: inputFocusNode,
      ),
      (readyToProgress == false
          ? Container()
          : Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text(_getCheckResultMessage(),
                  style: Styles.generalTextSyle))),
      Spacer(
        flex: 2,
      ),
      VerbButton(
          text: readyToProgress == true ? "Next" : "Check",
          onPressed: verbEntryController.text == '' ? null : _handleOnPressed,
          backgroundColour: readyToProgress == false
              ? Colors.green
              : attemptWasCorrect == true
                  ? Colors.green
                  : Colors.red),
    ]);
  }

  String _getCheckResultMessage() {
    return attemptWasCorrect == true
        ? 'Correct!'
        : 'Not quite... It was: ' + _currentVerb().english;
  }

  void _handleOnPressed() {
    if (readyToProgress == false) {
      final isCorrect =
          VerbValidation.test(_currentVerb().english, verbEntryController.text);

      setState(() {
        numberAnsweredCorrectly =
            numberAnsweredCorrectly + (isCorrect == true ? 1 : 0);
        readyToProgress = true;
        preventUserEntry = true;
        attemptWasCorrect = isCorrect;
      });
    } else {
      if (1 + currentVerbIndex == verbList.length) {
        final score = Score(verbList.length, numberAnsweredCorrectly);
        final newSummary =
            SessionSummary(dojo.name, dojo.id, score, _getSummaryDate());
        newSummary.id = dojoDbId;

        MaterialPageRoute route = MaterialPageRoute(
            builder: (_) => SessionSummaryView(dojo.name, score));

        dojoBloc
            .storeSummary(newSummary)
            .then((value) => Navigator.push(context, route))
            .catchError(() => Navigator.push(context, route));
      } else {
        setState(() {
          currentVerbIndex = currentVerbIndex + 1;
          readyToProgress = false;
          attemptWasCorrect = false;
          preventUserEntry = false;
          this.verbEntryController.text = '';
        });

        inputFocusNode.requestFocus();
      }
    }
  }

  String _getSummaryDate() {
    final DateTime now = DateTime.now();
    return now.day.toString() +
        '/' +
        now.month.toString() +
        '/' +
        now.year.toString();
  }

  Verb _currentVerb() {
    if (verbList == null || verbList.length == 0) {
      return Verb("", "");
    }

    return verbList[currentVerbIndex];
  }
}
