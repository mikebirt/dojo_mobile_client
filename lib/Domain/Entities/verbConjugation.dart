class VerbConjugation {
  int _id;
  int _conjugationId;
  int _verbId;
  String _italian;
  String _english;

  VerbConjugation(this._id, this._conjugationId, this._verbId, this._italian,
      this._english);

  int get id {
    return _id;
  }

  int get conjugationId {
    return _conjugationId;
  }

  int get verbId {
    return _verbId;
  }

  String get italian {
    return _italian;
  }

  String get english {
    return _english;
  }
}
