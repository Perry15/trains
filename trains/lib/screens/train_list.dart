import 'package:flutter/material.dart';

import 'package:trains/models/viaggiatreno.dart';
import 'package:trains/services/viaggiatreno.dart';

class TrainList extends StatefulWidget {
  @override
  _TrainListState createState() => _TrainListState();
}

class _TrainListState extends State<TrainList> {
  Future<CercaStazioni> cercaStazioni;

  @override
  void initState() {
    super.initState();
    cercaStazioni = fetchCercaStazioni(toSearch: 'padova');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<CercaStazioni>(
            future: cercaStazioni,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.stazioni);
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
