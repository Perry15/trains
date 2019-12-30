import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trains/screens/table_valutazione.dart';

class ValutazioneTreno extends StatefulWidget {
  final String treno;
  final Future<SharedPreferences> sharedPrefs;

  ValutazioneTreno(this.treno, this.sharedPrefs);

  @override
  _ValutazioneTrenoState createState() => _ValutazioneTrenoState();
}

class _ValutazioneTrenoState extends State<ValutazioneTreno> {
  int _tutorial;

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
              Text("Vota il treno " + widget.treno),
              SizedBox(height: 20),
              FutureBuilder(
                  future: widget.sharedPrefs,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      SharedPreferences prefs = snapshot.data;
                      _tutorial = prefs.getInt('tutorial') ?? 0;
                      if (_tutorial < 3) {
                        _tutorial = _tutorial + 1;
                        prefs.setInt('tutorial', _tutorial);
                        return ShowCaseWidget(
                            builder: Builder(
                                builder: (context) => TableValutazione(true)));
                      }
                      return TableValutazione(false);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    // By default, show a loading spinner.
                    return CircularProgressIndicator();
                  })
            ]));
  }
}
