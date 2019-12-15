import 'package:flutter/material.dart';

import 'package:trains/models/viaggiatreno.dart';
import 'package:trains/screens/treno_details.dart';
import 'package:trains/services/viaggiatreno.dart';

class TrenoLoad extends StatefulWidget {
  @override
  _TrenoLoadState createState() => _TrenoLoadState();
}

class _TrenoLoadState extends State<TrenoLoad> {
  Future<Treno> treno;

  @override
  void initState() {
    super.initState();
    treno = fetchTreno(toSearch: 'S02593/2738');
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
          child: FutureBuilder<Treno>(
            future: treno,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return TrenoDetails(snapshot.data);
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
