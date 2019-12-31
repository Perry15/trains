import 'package:flutter/material.dart';

import 'package:trains/models/viaggiatreno.dart';
import 'package:trains/screens/treno_details.dart';

class TrenoLoad extends StatelessWidget {
  final Future<Treno> _treno;
  final String _codTreno;
  TrenoLoad(this._treno, this._codTreno);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('Fetch Data Example'),
          backgroundColor: Color(0xff9b0014),
        ),
        body: Center(
          child: FutureBuilder<Treno>(
            future: _treno,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return TrenoDetails(snapshot.data,_codTreno);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
