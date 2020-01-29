import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

import 'package:trains/models/viaggiatreno.dart';
import 'package:trains/screens/valutazione_treno.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trains/services/database.dart';

///Widget per visualizzare i dettagli di un treno
class TrenoDetails extends StatelessWidget {
  final Treno treno;
  final String codTreno;
  final String stazPartenza;
  TrenoDetails(this.treno, this.codTreno, this.stazPartenza);

  final DatabaseService _dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    List<String> results = ["Vuoto", "Quasi vuoto", "Quasi pieno", "Pieno"];
    List<Color> color = [
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.red
    ];
    return FutureBuilder<int>(
        future: _dbService.getTrainEvaluation(codTreno),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(children: <Widget>[
              SizedBox(
                height: 20,
              ),
              CircleAvatar(
                radius: 130,
                backgroundColor: color[snapshot.data],
                child: Text(
                  'Il treno è \n${results[snapshot.data]}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ButtonTheme(
                minWidth: MediaQuery.of(context).size.width - 100,
                height: 60.0,
                child: RaisedButton(
                  color: Color(0xff9b0014),
                  child: Text(
                    'Valuta il treno',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ValutazioneTreno(stazPartenza,
                                codTreno, SharedPreferences.getInstance())));
                  },
                ),
              ),
              Expanded(
                  child: ListView.builder(
                itemCount: treno.fermate.length,
                itemBuilder: (context, index) {
                  Fermata fermata = treno.fermate[index];
                  return ListTile(
                    title: Text(fermata.stazione),
                    subtitle: Text('Arriva alle ' +
                        formatDate(
                            DateTime.fromMillisecondsSinceEpoch(
                                fermata.programmata),
                            [
                              HH,
                              ':',
                              nn,
                            ])),
                    onTap: null,
                  );
                },
              ))
            ]);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        });
  }
}
