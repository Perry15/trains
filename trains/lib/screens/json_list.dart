import 'package:flutter/material.dart';
import 'package:trains/models/viaggiatreno.dart';

class JsonList extends StatelessWidget {
  final Partenze jsonList;

  JsonList(this.jsonList);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ...(jsonList.partenze).map((jsonItem) {
          return Container(
              width: double.infinity,
              child: RaisedButton(
                child: Text(jsonItem.toString()),
                onPressed: null,
              ));
        }).toList()
      ],
    );
  }
}
