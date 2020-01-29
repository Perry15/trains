///Classe per rappresentare una localizzazione
class Location {
  String code;

  Location(this.code);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'code': code};
    return map;
  }

  Location.fromMap(Map<String, dynamic> map) {
    code = map['code'];
  }
}
