import 'package:verb_client/Domain/Entities/score.dart';

class SessionSummary {
  int id;
  String dojoName;
  int dojoId;
  Score score;
  String dojoDate;

  SessionSummary(this.dojoName, this.dojoId, this.score, this.dojoDate);

  SessionSummary.fromMap(Map<String, dynamic> json) {
    this.id = json['id'];
    this.dojoName = json['dojoName'];
    this.dojoId = json['dojoId'];
    this.score = Score.fromMap(json['score']);
    this.dojoDate = json['dojoDate'];
  }

  Map<String, dynamic> toMap() {
    return {
      'dojoName': dojoName,
      'dojoId': dojoId,
      'score': score.toMap(),
      'dojoDate': dojoDate
    };
  }

  String toString() {
    return '{' +
        'id: ' +
        (id == null ? 'null' : id.toString()) +
        ',dojoName: ' +
        dojoName +
        ', dojoId: ' +
        dojoId.toString() +
        ', score: ' +
        score.toString() +
        ', dojoDate: ' +
        dojoDate.toString() +
        '}';
  }
}
