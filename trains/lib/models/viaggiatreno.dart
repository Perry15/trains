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

class Partenza {
  final String numeroTreno;
  final String codOrigine;
  final String destinazione;
  final String compOrarioPartenza;
  final String compTipologiaTreno;

  Partenza(
      {this.numeroTreno,
      this.codOrigine,
      this.destinazione,
      this.compOrarioPartenza,
      this.compTipologiaTreno});

  factory Partenza.fromJson(Map<String, dynamic> json) {
    return Partenza(
        numeroTreno: json['numeroTreno'].toString(),
        codOrigine: json['codOrigine'],
        destinazione: json['destinazione'],
        compOrarioPartenza: json['compOrarioPartenza'],
        compTipologiaTreno: json['compTipologiaTreno']);
  }
}

class Partenze {
  final List<Partenza> partenze;

  Partenze({
    this.partenze,
  });

  factory Partenze.fromJson(List<dynamic> json) {
    List<Partenza> partenze = new List<Partenza>();
    partenze = json.map((i) => Partenza.fromJson(i)).toList();
    return new Partenze(
      partenze: partenze,
    );
  }
}

class Fermata {
  final String stazione;
  final String id;
  final String partenzaReale;

  Fermata({
    this.stazione,
    this.id,
    this.partenzaReale,
  });

  factory Fermata.fromJson(Map<String, dynamic> json) {
    return Fermata(
      stazione: json['stazione'],
      id: json['id'],
      partenzaReale: json['partenzaReale'],
    );
  }
}

class Treno {
  final List<Fermata> fermate;

  Treno({
    this.fermate,
  });

  factory Treno.fromJson(List<dynamic> json) {
    List<Fermata> fermate = new List<Fermata>();
    fermate = json.map((i) => Fermata.fromJson(i)).toList();
    return new Treno(
      fermate: fermate,
    );
  }
}
