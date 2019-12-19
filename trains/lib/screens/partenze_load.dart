import 'package:flutter/material.dart';

import 'package:trains/models/viaggiatreno.dart';
import 'package:trains/screens/partenze_list.dart';

class PartenzeLoad extends StatelessWidget {
  final Future<Partenze> partenze;

  PartenzeLoad(this.partenze);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child:FutureBuilder<Partenze>(
            future: partenze,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return PartenzeList(snapshot.data);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Container();
            },
          ));
  }
}
