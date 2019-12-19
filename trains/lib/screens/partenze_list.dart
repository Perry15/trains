import 'package:flutter/material.dart';

import 'package:trains/screens/treno_load.dart';
import 'package:trains/models/viaggiatreno.dart';
import 'package:trains/services/viaggiatreno.dart';

class PartenzeList extends StatelessWidget {
  final Partenze partenzeList;

  PartenzeList(this.partenzeList);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        child: ListView(
      padding: EdgeInsets.symmetric(vertical: 8),
      children: <Widget>[
        ...(partenzeList.partenze).map((partenza) {
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
                    builder: (context) => TrenoLoad(fetchTreno(
                        toSearch:
                            partenza.codOrigine + '/' + partenza.numeroTreno))),
              );
            },
            trailing: Icon(Icons.keyboard_arrow_right),
          );
        }).toList()
      ],
    ));
  }
}
