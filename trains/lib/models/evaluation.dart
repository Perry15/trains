import 'package:cloud_firestore/cloud_firestore.dart';

class Evaluation {
  String id, traincode, vote, location;
  Timestamp timestamp;

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