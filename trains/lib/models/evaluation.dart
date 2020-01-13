class Evaluation {
  String id, traincode, vote, location;
  DateTime timestamp;

  Evaluation(this.id,this.location,this.timestamp,this.traincode,this.vote);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'traincode': traincode,
      'vote': vote,
      'location': location,
      'timestamp': timestamp
    };
    return map;
  }

  Evaluation.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    traincode = map['traincode'];
    vote = map['vote'];
    location = map['location'];
  }
}
