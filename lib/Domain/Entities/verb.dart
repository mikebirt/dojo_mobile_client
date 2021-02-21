class Verb {
  String _italian;
  String _english;

  Verb(this._italian, this._english);

  String get italian {
    return _italian;
  }

  String get english {
    return _english;
  }

  Verb.fromJson(Map<String, dynamic> dojoJson) {
    this._italian = dojoJson['italian'];
    this._english = dojoJson['english'];
  }
}
