class Train {
  int id;
  String code;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'id': id, 'code': code};
    return map;
  }

  Train.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    code = map['code'];
  }
}
