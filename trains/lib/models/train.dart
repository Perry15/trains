///Classe per rappresentare un treno
class Train {
  String code;

  Train(this.code);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'code': code};
    return map;
  }

  Train.fromMap(Map<String, dynamic> map) {
    code = map['code'];
  }
}
