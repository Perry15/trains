import 'package:flutter/material.dart';

import 'package:trains/models/viaggiatreno.dart';
import 'package:trains/screens/treno_details.dart';

class TrenoLoad extends StatelessWidget {
  final Future<Treno> _treno;
  final String _codTreno;
  final String _stazPartenza;
  TrenoLoad(this._treno, this._codTreno, this._stazPartenza);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text('Stato del treno'),
        backgroundColor: Color(0xff9b0014),
      ),
      body: Center(
        child: FutureBuilder<Treno>(
          future: _treno,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return TrenoDetails(snapshot.data, _codTreno, _stazPartenza);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
