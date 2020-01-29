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
    if (partenzeList.partenze.length > 0) {
      return ListView.builder(
        itemCount: partenzeList.partenze.length,
        itemBuilder: (context, index) {
          Partenza partenza = partenzeList.partenze[index];
          DateTime now = DateTime.now();
          return ListTile(
            leading: ExcludeSemantics(
              child: CircleAvatar(
                child: Text(
                  partenza.compOrarioPartenza,
                  softWrap: false,
                ),
                radius: 30,
              ),
            ),
            title: Text(partenza.destinazione),
            subtitle: Text(partenza.compTipologiaTreno +
                ' ' +
                partenza.numeroTreno +
                _isInRitardo(DateTime.parse(now.year.toString() +
                    '-' +
                    (now.month < 10
                        ? '0' + now.month.toString()
                        : now.month.toString()) +
                    '-' +
                    now.day.toString() +
                    ' ' +
                    partenza.compOrarioPartenza +
                    ':00'))),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TrenoLoad(
                        fetchTreno(
                            toSearch: partenza.codOrigine +
                                '/' +
                                partenza.numeroTreno),
                        partenza.codOrigine + '/' + partenza.numeroTreno,
                        stazPartenza)),
              );
            },
            trailing: Icon(Icons.keyboard_arrow_right),
          );
        },
      );
    }
    return Text(
        'Purtroppo Rino e gli altri treni\nsono in viaggio.\n\nRiprova più tardi.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.0,
        ));
  }

  String _isInRitardo(DateTime partenza) {
    DateTime now = DateTime.now();
    if (now.millisecondsSinceEpoch > partenza.millisecondsSinceEpoch) {
      return ', è in ritardo.';
    }
    return '';
  }
}
