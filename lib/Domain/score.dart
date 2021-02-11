class Score {
  int numberOfVerbs;
  int correctlyAnswered;

  Score(this.numberOfVerbs, this.correctlyAnswered);

  Map<String, dynamic> toMap() {
    return {
      'numberOfVerbs': numberOfVerbs,
      'correctlyAnswered': correctlyAnswered
    };
  }

  Score.fromMap(Map<String, dynamic> json) {
    this.numberOfVerbs = json['numberOfVerbs'];
    this.correctlyAnswered = json['correctlyAnswered'];
  }

  String toString() {
    return '{' +
        'numberOfVerbs: ' +
        numberOfVerbs.toString() +
        ', correctlyAnswered: ' +
        correctlyAnswered.toString() +
        '}';
  }
}
