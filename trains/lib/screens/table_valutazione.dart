import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:trains/screens/valutatore.dart';

class TableValutazione extends StatefulWidget {
  final bool _tutorial;

  TableValutazione(this._tutorial);

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
    if (widget._tutorial) {
      WidgetsBinding.instance.addPostFrameCallback((_) =>
          ShowCaseWidget.of(context)
              .startShowCase([_one, _two, _three, _four]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(children: [
          SizedBox.shrink(),
          TableCell(
            child: _getTutorial('Vuoto', Colors.green, _one,
                'Trascinalo al centro se il treno è vuoto...'),
          ),
          SizedBox.shrink(),
        ]),
        TableRow(children: [
          TableCell(
            child: _getTutorial(
              "Quasi vuoto",
              Colors.yellow,
              _two,
              '...trascina questo se ci sono posti liberi...',
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
              child: _getTutorial(
            "Quasi pieno",
            Colors.orange,
            _three,
            '...questo se il treno è affollato...',
          ))
        ]),
        TableRow(children: [
          SizedBox.shrink(),
          TableCell(
              child: _getTutorial(
            "Pieno",
            Colors.red,
            _four,
            '...o questo se non ci si può sedere.',
          )),
          SizedBox.shrink(),
        ])
      ],
    );
  }

  Widget _getTutorial(
      String value, MaterialColor color, GlobalKey key, String description) {
    if (widget._tutorial) {
      return Showcase(
        key: key,
        description: description,
        child: Valutatore(value, color),
      );
    }
    return Valutatore(value, color);
  }
}
