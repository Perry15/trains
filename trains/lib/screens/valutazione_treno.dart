import 'package:flutter/material.dart';
import 'package:trains/screens/table_valutazione.dart';

class ValutazioneTreno extends StatelessWidget {
  final String treno;

  ValutazioneTreno(this.treno);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('Vota'),
          backgroundColor: Color(0xff9b0014),
          elevation: 0.0,
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Vota il treno " + treno),
              SizedBox(height: 20),
              TableValutazione()
            ]));
  }
}
