import 'package:flutter/material.dart';

import 'package:trains/models/viaggiatreno.dart';
import 'package:trains/screens/json_list.dart';
import 'package:trains/services/viaggiatreno.dart';

class TrainList extends StatefulWidget {
  @override
  _TrainListState createState() => _TrainListState();
}

class _TrainListState extends State<TrainList> {
  Future<Partenze> partenze;

  @override
  void initState() {
    super.initState();
    partenze = fetchPartenze(
        toSearch: 'S02581/Sat%20dec%2014%202019%2020:58:00%20GMT+0100');
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
          child: FutureBuilder<Partenze>(
            future: partenze,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return JsonList(snapshot.data);
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
