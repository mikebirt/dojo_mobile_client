import 'package:flutter/cupertino.dart';
import 'package:verb_client/Domain/Entities/sessionSummary.dart';

class VerbState {
  final String italian;
  final String enteredText;
  final bool isAttemptCompleted;
  final bool isAttemptSubmitable;
  final bool isAttemptCorrect;
  final bool isHelpAvailable;
  final int currentVerbNumber;
  final int totalVerbCount;
  final String resultMessage;
  final bool isLastVerb;
  final SessionSummary sessionSummary;

  VerbState(
      {@required this.italian,
      @required this.enteredText,
      @required this.isAttemptCompleted,
      @required this.isAttemptCorrect,
      @required this.isAttemptSubmitable,
      @required this.isHelpAvailable,
      @required this.currentVerbNumber,
      @required this.totalVerbCount,
      @required this.resultMessage,
      @required this.isLastVerb,
      @required this.sessionSummary});
}
