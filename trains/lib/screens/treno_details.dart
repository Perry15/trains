import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

import 'package:trains/models/viaggiatreno.dart';
import 'package:trains/screens/valutazione_treno.dart';
import 'package:shared_preferences/shared_preferences.dart';
class TrenoDetails extends StatelessWidget {
  final Treno treno;
  final String codTreno;
  TrenoDetails(this.treno, this.codTreno);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      CircleAvatar(
        radius: 150,
        backgroundColor: Colors.green,
        child: Text('TRENO LIBERO'),//qui bisognerà interrogare db
      ),
      //bottone valutazione
      //Text(cod.toString()),
      RaisedButton (
        color: Color(0xff9b0014),
        child: Text(
          'Valuta il treno',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        onPressed: () {
          Navigator.push(context,MaterialPageRoute(builder: (context) => ValutazioneTreno(codTreno,SharedPreferences.getInstance())));
        },
      ),
      Expanded(
          child: ListView(
        padding: EdgeInsets.symmetric(vertical: 8),
        children: <Widget>[
          ...(treno.fermate).map((fermata) {
            return ListTile(
              title: Text(fermata.stazione),
              subtitle: Text('Arriva alle ' +
                  formatDate(
                      DateTime.fromMillisecondsSinceEpoch(fermata.programmata),
                      [
                        HH,
                        ':',
                        nn,
                      ])),
              onTap: null,
            );
          }).toList()
        ],
      ))
    ]);
  }
}
