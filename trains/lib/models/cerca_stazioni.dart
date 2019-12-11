class CercaStazione {
  final String nomeLungo;
  final String nomeBreve;
  final String label;
  final String id;

  CercaStazione({this.nomeLungo, this.nomeBreve, this.label, this.id});

  factory CercaStazione.fromJson(Map<String, dynamic> json) {
    return CercaStazione(
      nomeLungo: json['nomeLungo'],
      nomeBreve: json['nomeBreve'],
      label: json['label'],
      id: json['id'],
    );
  }
}

class CercaStazioni {
  final List<CercaStazione> stazioni;

  CercaStazioni({
    this.stazioni,
  });

  factory CercaStazioni.fromJson(List<dynamic> json) {
    List<CercaStazione> stazioni = new List<CercaStazione>();
    stazioni = json.map((i) => CercaStazione.fromJson(i)).toList();
    return new CercaStazioni(
      stazioni: stazioni,
    );
  }
}
