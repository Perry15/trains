import 'package:flutter/material.dart';

import 'package:trains/screens/treno_load.dart';
import 'package:trains/models/viaggiatreno.dart';
import 'package:trains/services/viaggiatreno.dart';

class PartenzeList extends StatelessWidget {
  final Partenze partenzeList;
  final String stazPartenza;
  PartenzeList(this.partenzeList, this.stazPartenza);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: partenzeList.partenze.length,
      itemBuilder: (context, index) {
        Partenza partenza = partenzeList.partenze[index];
        return ListTile(
          leading: ExcludeSemantics(
            child: CircleAvatar(
              child: Text(partenza.compOrarioPartenza),
            ),
          ),
          title: Text(partenza.destinazione),
          subtitle:
              Text(partenza.compTipologiaTreno + ' ' + partenza.numeroTreno),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TrenoLoad(
                      fetchTreno(
                          toSearch:
                              partenza.codOrigine + '/' + partenza.numeroTreno),
                      partenza.codOrigine + '/' + partenza.numeroTreno,
                      stazPartenza)),
            );
          },
          trailing: Icon(Icons.keyboard_arrow_right),
        );
      },
    );
  }
}
