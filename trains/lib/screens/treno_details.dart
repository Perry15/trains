import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

import 'package:trains/models/viaggiatreno.dart';

class TrenoDetails extends StatelessWidget {
  final Treno treno;

  TrenoDetails(this.treno);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      CircleAvatar(
        radius: 150,
        backgroundColor: Colors.green,
        child: Text('TRENO LIBERO'),
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
