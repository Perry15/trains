///Classe che rappresenta una risposta di ViaggiaTreno
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

///Classe che rappresenta una risposta di ViaggiaTreno
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

///Classe che rappresenta una risposta di ViaggiaTreno per una partenza
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

///Classe che rappresenta una risposta di ViaggiaTreno per le partenze
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

///Classe che rappresenta una risposta di ViaggiaTreno per una fermata
class Fermata {
  final String stazione;
  final String id;
  final int programmata;

  Fermata({
    this.stazione,
    this.id,
    this.programmata,
  });

  factory Fermata.fromJson(Map<String, dynamic> json) {
    return Fermata(
      stazione: json['stazione'],
      id: json['id'],
      programmata: json['programmata'],
    );
  }
}

///Classe che rappresenta una risposta di ViaggiaTreno per le fermate di un treno
class Treno {
  final List<Fermata> fermate;

  Treno({
    this.fermate,
  });

  factory Treno.fromJson(Map<String, dynamic> json) {
    var list = json['fermate'] as List;
    List<Fermata> fermate = list.map((i) => Fermata.fromJson(i)).toList();
    return new Treno(
      fermate: fermate,
    );
  }
}
