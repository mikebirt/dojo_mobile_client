import 'package:flutter/material.dart';
import 'package:verb_client/Blocs/verbSessionBloc.dart';
import 'package:verb_client/Domain/Entities/sessionSummary.dart';

import 'package:verb_client/Domain/Entities/dojo.dart';
import 'package:verb_client/Domain/Entities/verbState.dart';
import 'package:verb_client/Widgets/Verb/completedDialog.dart';
import 'package:verb_client/Widgets/Verb/sessionProgress.dart';

import '../VerbButton.dart';
import '../styles.dart';

class VerbSession extends StatefulWidget {
  final Dojo dojo;
  final int dojoDbId;

  VerbSession(this.dojo, this.dojoDbId);

  @override
  _VerbSessionState createState() => _VerbSessionState(dojo, dojoDbId);
}

class _VerbSessionState extends State<VerbSession> {
  FocusNode inputFocusNode;
  TextEditingController verbEntryController;

  final Dojo dojo;
  final int dojoDbId;
  VerbSessionBloc verbSessionBloc;

  _VerbSessionState(this.dojo, this.dojoDbId);

  @override
  void initState() {
    inputFocusNode = FocusNode();
    verbEntryController = new TextEditingController();
    verbSessionBloc = VerbSessionBloc(dojo, dojoDbId);

    verbEntryController.addListener(() {
      verbSessionBloc.setUserEnteredText(verbEntryController.text);
    });

    super.initState();
  }

  @override
  void dispose() {
    inputFocusNode.dispose();
    verbEntryController.dispose();
    verbSessionBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<VerbState>(
        stream: verbSessionBloc.activeVerbStream,
        builder: (context, AsyncSnapshot<VerbState> snapshot) {
          if (snapshot.hasData == false) {
            return Center(child: CircularProgressIndicator());
          }

          return _buildBody(snapshot.data);
        });
  }

  Widget _buildBody(VerbState verbState) {
    if (verbEntryController.text != verbState.enteredText) {
      verbEntryController.text = verbState.enteredText;
      verbEntryController.selection = TextSelection.fromPosition(
          TextPosition(offset: verbEntryController.text.length));
    }

    return Column(children: [
      SessionProgress(verbState.totalVerbCount, verbState.currentVerbNumber),
      Spacer(),
      Row(children: [
        Spacer(),
        Text(verbState.italian, style: Styles.largeTextSyle),
        IconButton(
            icon: Icon(Icons.help_rounded),
            onPressed: verbState.isHelpAvailable
                ? () => verbSessionBloc.getHelp()
                : null),
        Spacer(),
      ]),
      TextField(
        controller: verbEntryController,
        textAlign: TextAlign.center,
        style: Styles.generalTextSyle,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: "Enter the English translation",
            hintStyle: Styles.hintTextStyle),
        autofocus: true,
        readOnly: verbState.isAttemptCompleted,
        focusNode: inputFocusNode,
      ),
      (verbState.isAttemptCompleted == false
          ? Container()
          : Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text(verbState.resultMessage,
                  style: Styles.generalTextSyle))),
      Spacer(
        flex: 2,
      ),
      VerbButton(
          text: verbState.isAttemptCompleted == true ? "Next" : "Check",
          onPressed: verbState.enteredText == ''
              ? null
              : () => _handleOnPressed(verbState),
          backgroundColour: verbState.isAttemptCompleted == false
              ? Colors.green
              : verbState.isAttemptCorrect == true
                  ? Colors.green
                  : Colors.red),
    ]);
  }

  void _handleOnPressed(VerbState verbState) {
    if (verbState.isAttemptCompleted == false) {
      verbSessionBloc.submitAttempt();
    } else {
      if (verbState.isLastVerb) {
        _showCompletedDialog(verbState.sessionSummary);
      } else {
        verbEntryController.text = "";
        verbSessionBloc.nextVerb();
        inputFocusNode.requestFocus();
      }
    }
  }

  void _showCompletedDialog(SessionSummary sessionSummary) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CompletedDialog(sessionSummary);
        });
  }
}
