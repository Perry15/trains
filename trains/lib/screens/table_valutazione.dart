import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

import 'package:trains/screens/valutatore.dart';

class TableValutazione extends StatefulWidget {
  @override
  _TableValutazioneState createState() => _TableValutazioneState();
}

class _TableValutazioneState extends State<TableValutazione> {
  GlobalKey _one = GlobalKey();
  GlobalKey _two = GlobalKey();
  GlobalKey _three = GlobalKey();
  GlobalKey _four = GlobalKey();

  @override
  void initState() {
    super.initState();
    //Start showcase view after current widget frames are drawn.
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        ShowCaseWidget.of(context).startShowCase([_one, _two, _three, _four]));
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(children: [
          SizedBox.shrink(),
          TableCell(
            child: Showcase(
              key: _one,
              description: 'Trascinalo al centro se il treno è vuoto...',
              child: Valutatore("Vuoto", Colors.green),
            ),
          ),
          SizedBox.shrink(),
        ]),
        TableRow(children: [
          TableCell(
            child: Showcase(
              key: _two,
              description: '...trascina questo se ci sono posti liberi...',
              child: Valutatore("Quasi vuoto", Colors.yellow),
            ),
          ),
          TableCell(
              child: DragTarget(
                  builder: (context, List<String> candidateData, rejectedData) {
            return CircleAvatar(
              radius: 75,
              backgroundColor: Colors.pink,
              child: Text('Vota'),
            );
          }, onWillAccept: (data) {
            return true;
          }, onAccept: (data) {
            print(data.toString());
          })),
          TableCell(
              child: Showcase(
            key: _three,
            description: '...questo se il treno è affollato...',
            child: Valutatore("Quasi pieno", Colors.orange),
          ))
        ]),
        TableRow(children: [
          SizedBox.shrink(),
          TableCell(
              child: Showcase(
            key: _four,
            description: '...o questo se non ci si può sedere.',
            child: Valutatore("Pieno", Colors.red),
          )),
          SizedBox.shrink(),
        ])
      ],
    );
  }
}
