import 'package:verb_client/Domain/Entities/conjugation.dart';

class Verb {
  int _id;
  int _typeId;
  String italian;
  String english;
  List<Conjugation> conjugations;

  Verb(this._id, this._typeId, this.italian, this.english);

  int get id {
    return _id;
  }

  int get typeId {
    return _typeId;
  }

  Verb.fromJson(Map<String, dynamic> dojoJson) {
    this.italian = dojoJson['italian'];
    this.english = dojoJson['english'];
  }
}
