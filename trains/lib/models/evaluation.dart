class Evaluation {
  String id;
  String traincode, vote, location;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'id': id, 'traincode': traincode, 'vote': vote, 'location':location};
    return map;
  }

  Evaluation.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    traincode = map['traincode'];
    vote = map['vote'];
    location = map['location'];
  }
}
