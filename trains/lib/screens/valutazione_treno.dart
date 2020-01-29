import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trains/screens/evaluation_table.dart';

///Widget per valutare un treno
///Le prime 3 volte fa vedere un tutorial
///Il tutorial può essere richiamato dal menu laterale
class ValutazioneTreno extends StatelessWidget {
  final String trainCode;
  final String leavingStationCode;
  final Future<SharedPreferences> sharedPrefs;

  ValutazioneTreno([this.leavingStationCode, this.trainCode, this.sharedPrefs]);

  @override
  Widget build(BuildContext context) {
    if (this.leavingStationCode != null &&
        this.trainCode != null &&
        this.sharedPrefs != null) {
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
                Text("Vota il treno " + trainCode),
                SizedBox(height: 20),
                FutureBuilder(
                    future: sharedPrefs,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        SharedPreferences prefs = snapshot.data;
                        int tutorial = prefs.getInt('tutorial') ?? 0;
                        if (tutorial < 3) {
                          tutorial = tutorial + 1;
                          prefs.setInt('tutorial', tutorial);
                          return ShowCaseWidget(
                              builder: Builder(
                                  builder: (context) => EvaluationTable(
                                      true, trainCode, leavingStationCode)));
                        }
                        return EvaluationTable(
                            false, trainCode, leavingStationCode);
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return CircularProgressIndicator();
                    })
              ]));
    } else {
      return Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('Tutorial valutazione'),
          backgroundColor: Color(0xff9b0014),
          elevation: 0.0,
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 16),
              ShowCaseWidget(
                  builder:
                      Builder(builder: (context) => EvaluationTable(true))),
              SizedBox(height: MediaQuery.of(context).size.height / 16),
              Text("Vota per continuare",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0))
            ]),
      );
    }
  }
}
