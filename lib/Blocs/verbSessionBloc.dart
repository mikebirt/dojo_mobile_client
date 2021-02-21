import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:verb_client/Blocs/dojoBloc.dart';
import 'package:verb_client/DataServices/dojoDataService.dart';
import 'package:verb_client/Domain/Entities/dojo.dart';
import 'package:verb_client/Domain/Entities/score.dart';
import 'package:verb_client/Domain/Entities/sessionSummary.dart';
import 'package:verb_client/Domain/Entities/verbState.dart';
import 'package:verb_client/Domain/Entities/verb.dart';
import 'package:verb_client/Domain/Services/verbHelper.dart';
import 'package:verb_client/Domain/Services/verbValidation.dart';

class VerbSessionBloc {
  final _controller = StreamController<VerbState>.broadcast();
  final DojoDataService dojoSvc = DojoDataService();
  final DojoBloc dojoBloc = DojoBloc();
  final VerbHelper helper = VerbHelper();

  int dojoDbId;
  Dojo dojo;

  List<Verb> verbList;
  int currentVerbIndex;
  int correctAnswers;
  bool attemptWasSubmitted;
  bool attemptWasCorrect;
  SessionSummary completedSummary;
  String userEnteredText;

  Stream<VerbState> get activeVerbStream => _controller.stream;

  VerbSessionBloc(this.dojo, this.dojoDbId) {
    debugPrint('setUserEnteredText');
    currentVerbIndex = 0;
    correctAnswers = 0;

    final dojoSvc = DojoDataService();
    dojoSvc.getVerbs(dojo.id).then((verbs) {
      verbList = verbs;

      _resetVerbState();

      _setActiveVerb();
    });
  }

  void submitAttempt() {
    debugPrint('submitAttempt');
    if (attemptWasSubmitted == false) {
      attemptWasSubmitted = true;
      attemptWasCorrect = VerbValidation.test(
          verbList[currentVerbIndex].english, userEnteredText);

      correctAnswers += attemptWasCorrect ? 1 : 0;

      if (currentVerbIndex + 1 == verbList.length) {
        _persistSessionResult().then((summary) {
          completedSummary = summary;
          _setActiveVerb();
        });
      } else {
        _setActiveVerb();
      }
    }
  }

  void nextVerb() {
    debugPrint('nextVerb');

    _resetVerbState();
    currentVerbIndex = currentVerbIndex + 1;
    _setActiveVerb();
  }

  void setUserEnteredText(String userText) {
    debugPrint('setUserEnteredText(' + userText + ')');
    if (userEnteredText != userText) {
      userEnteredText = userText;
      _setActiveVerb();
    }
  }

  void getHelp() {
    debugPrint('getHelp');

    userEnteredText =
        helper.getHelp(verbList[currentVerbIndex].english, userEnteredText);

    _setActiveVerb();
  }

  void _resetVerbState() {
    attemptWasSubmitted = false;
    attemptWasCorrect = false;
    completedSummary = null;

    userEnteredText = "";
  }

  void _setActiveVerb() {
    _controller.sink.add(_getActiveVerbState());
  }

  VerbState _getActiveVerbState() {
    return VerbState(
        italian: verbList[currentVerbIndex].italian,
        enteredText: userEnteredText,
        isAttemptCompleted: attemptWasSubmitted,
        isAttemptCorrect: attemptWasCorrect,
        isAttemptSubmitable: userEnteredText != "",
        isHelpAvailable: helper.isHelpAvailable(
            verbList[currentVerbIndex].english, userEnteredText),
        currentVerbNumber: currentVerbIndex + 1,
        totalVerbCount: verbList.length,
        isLastVerb: currentVerbIndex + 1 == verbList.length,
        sessionSummary: completedSummary,
        resultMessage:
            attemptWasSubmitted == true ? _getCheckResultMessage() : "");
  }

  String _getCheckResultMessage() {
    return attemptWasCorrect == true
        ? 'Correct!'
        : 'Not quite... It was: ' + verbList[currentVerbIndex].english;
  }

  Future<SessionSummary> _persistSessionResult() {
    final score = Score(verbList.length, correctAnswers);
    final newSummary =
        SessionSummary(dojo.name, dojo.id, score, _getSummaryDate());
    newSummary.id = dojoDbId;

    return dojoBloc.storeSummary(newSummary);
  }

  String _getSummaryDate() {
    final DateTime now = DateTime.now();
    return now.day.toString() +
        '/' +
        now.month.toString() +
        '/' +
        now.year.toString();
  }

  void dispose() {
    _controller.close();
    // do not dispose dojoBloc!
  }
}
