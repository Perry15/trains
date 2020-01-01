import 'package:cloud_firestore/cloud_firestore.dart';

class Evaluation {
  int id;
  Timestamp timestamp;
  String traincode, vote;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'timestamp': timestamp,
      'traincode': traincode,
      'vote': vote
    };
    return map;
  }

  Evaluation.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    timestamp = map['timestamp'];
    traincode = map['traincode'];
    vote = map['vote'];
  }
}
