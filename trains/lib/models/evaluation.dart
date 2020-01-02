class Evaluation {
  String id;
  String traincode, vote;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'id': id, 'traincode': traincode, 'vote': vote};
    return map;
  }

  Evaluation.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    traincode = map['traincode'];
    vote = map['vote'];
  }
}
