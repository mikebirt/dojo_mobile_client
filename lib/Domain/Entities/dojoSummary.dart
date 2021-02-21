import 'package:verb_client/Domain/Entities/score.dart';

class DojoSummary {
  int dbSessionSummaryId;
  int id;
  String name;
  Score score;
  String lastPractise;

  DojoSummary(this.id, this.name, this.score, this.lastPractise,
      this.dbSessionSummaryId);

  DojoSummary.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.lastPractise = json['lastPractise'];
    this.score = Score.fromMap(json['score']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'score': score.toMap(),
      'lastPractise': lastPractise
    };
  }

  String toString() {
    return '{' +
        'id: ' +
        id.toString() +
        ', name: ' +
        name +
        ', score: ' +
        score.toString() +
        ', lastPractise: ' +
        lastPractise.toString() +
        '}';
  }
}
