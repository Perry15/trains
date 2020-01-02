import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:trains/models/evaluation.dart';
import 'package:trains/models/location.dart';
import 'package:trains/models/train.dart';
import 'package:trains/screens/valutatore.dart';
import 'package:trains/services/database.dart';
import 'package:trains/screens/login.dart';
import 'package:trains/services/local_database.dart';

class TableValutazione extends StatefulWidget {
  final bool _tutorial;
  final String _trainCode;
  final DatabaseService _dbService = DatabaseService();
  final LocalDatabaseService _localDbService = LocalDatabaseService();
  TableValutazione(this._tutorial, this._trainCode);

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
            save(data);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Login(true)),
              (Route<dynamic> route) => false,
            );
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

  void save(data) async {
    Map<String, dynamic> evaluation = new Map();
    evaluation['id'] = (await widget._dbService
            .insertEvaluation(data.toString(), widget._trainCode))
        .documentID;
    evaluation['traincode'] = widget._trainCode;
    evaluation['vote'] = data.toString();
    widget._localDbService.insertEvaluation(Evaluation.fromMap(evaluation));
    Map<String, dynamic> train = new Map();
    train['code'] = widget._trainCode;
    widget._localDbService.insertTrain(Train.fromMap(train));
    Map<String, dynamic> location = new Map();
    location['code'] =
        widget._trainCode.substring(0, widget._trainCode.indexOf("/"));
    widget._localDbService.insertLocation(Location.fromMap(location));
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
