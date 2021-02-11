class Dojo {
  int _id;
  String _name;

  Dojo(this._id, this._name);

  int get id {
    return _id;
  }

  String get name {
    return _name;
  }

  Dojo.fromJson(Map<String, dynamic> dojoJson) {
    this._id = dojoJson['id'];
    this._name = dojoJson['name'];
  }
}
