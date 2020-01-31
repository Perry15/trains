import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:trains/models/evaluation.dart';
import 'package:trains/models/location.dart';
import 'package:trains/models/train.dart';
import 'package:trains/models/user.dart';
import 'package:trains/screens/profile.dart';
import 'package:trains/services/database.dart';
import 'package:trains/services/local_database.dart';

///Widget reltivo all'interfaccia per la valutazione di un treno
class EvaluationTable extends StatefulWidget {
  final bool _tutorial;
  final String _trainCode;
  final String _leavingStationCode;
  final DatabaseService _dbService = DatabaseService();
  final LocalDatabaseService _localDbService = LocalDatabaseService();
  EvaluationTable(this._tutorial, [this._trainCode, this._leavingStationCode]);
  @override
  EvaluationTableState createState() => EvaluationTableState();
}

class EvaluationTableState extends State<EvaluationTable> {
  GlobalKey _one = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget._tutorial) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => ShowCaseWidget.of(context).startShowCase([_one]));
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget toReturn = Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(children: [
          SizedBox.shrink(),
          TableCell(
              child: Draggable(
                  data: "Vuoto",
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.green,
                    child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Column(children: [
                          Icon(
                            Icons.sentiment_very_satisfied,
                            color: Colors.green,
                            size: 40.0,
                          ),
                          Text("Vuoto", textAlign: TextAlign.center)
                        ])),
                  ),
                  feedback: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.green,
                      child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          child: Column(children: [
                            Icon(
                              Icons.sentiment_very_satisfied,
                              color: Colors.green,
                              size: 40.0,
                            ),
                            Text("Vuoto", textAlign: TextAlign.center)
                          ]))))),
          SizedBox.shrink(),
        ]),
        TableRow(children: [
          TableCell(
              child: Draggable(
                  data: "Quasi vuoto",
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.yellow,
                    child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Column(children: [
                          Icon(
                            Icons.sentiment_satisfied,
                            color: Colors.yellow,
                            size: 40.0,
                          ),
                          Text("Quasi vuoto", textAlign: TextAlign.center)
                        ])),
                  ),
                  feedback: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.yellow,
                      child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          child: Column(children: [
                            Icon(
                              Icons.sentiment_satisfied,
                              color: Colors.yellow,
                              size: 40.0,
                            ),
                            Text("Quasi vuoto", textAlign: TextAlign.center)
                          ]))))),
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
            if (widget._trainCode != null &&
                widget._leavingStationCode != null) {
              save(data, context);
            } else {
              Navigator.pop(context);
            }
          })),
          TableCell(
              child: Draggable(
                  data: "Quasi pieno",
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.orange,
                    child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Column(children: [
                          Icon(
                            Icons.sentiment_dissatisfied,
                            color: Colors.orange,
                            size: 40.0,
                          ),
                          Text("Quasi pieno", textAlign: TextAlign.center)
                        ])),
                  ),
                  feedback: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.orange,
                      child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          child: Column(children: [
                            Icon(
                              Icons.sentiment_dissatisfied,
                              color: Colors.orange,
                              size: 40.0,
                            ),
                            Text("Quasi pieno", textAlign: TextAlign.center)
                          ])))))
        ]),
        TableRow(children: [
          SizedBox.shrink(),
          TableCell(
            child: Draggable(
                data: "Pieno",
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.red,
                  child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Column(children: [
                        Icon(
                          Icons.sentiment_very_dissatisfied,
                          color: Colors.red,
                          size: 40.0,
                        ),
                        Text("Pieno", textAlign: TextAlign.center)
                      ])),
                ),
                feedback: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.red,
                    child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Column(children: [
                          Icon(
                            Icons.sentiment_very_dissatisfied,
                            color: Colors.red,
                            size: 40.0,
                          ),
                          Text("Pieno", textAlign: TextAlign.center)
                        ])))),
          ),
          SizedBox.shrink(),
        ])
      ],
    );
    if (widget._tutorial) {
      return Showcase(
        key: _one,
        description: "trascina un cerchio al centro per votare",
        child: toReturn,
      );
    }
    return toReturn;
  }

  ///funzione che salva i dati relativi alla valutazione eseguita
  void save(data, context) async {
    Map<String, dynamic> evaluation = new Map();
    evaluation['id'] = (await widget._dbService.insertEvaluation(
            data.toString(), widget._trainCode, widget._leavingStationCode))
        .documentID;
    evaluation['traincode'] = widget._trainCode;
    evaluation['location'] = widget._leavingStationCode;
    evaluation['vote'] = data.toString();
    evaluation['timestamp'] = DateTime.now().toString();
    widget._localDbService.insertEvaluation(Evaluation.fromMap(evaluation));
    Map<String, dynamic> train = new Map();
    train['code'] = widget._trainCode;
    widget._localDbService.insertTrain(Train.fromMap(train));
    Map<String, dynamic> location = new Map();
    location['code'] = widget._leavingStationCode;
    widget._localDbService.insertLocation(Location.fromMap(location));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('uid') ?? "";
    if (uid != "") {
      widget._dbService.updateUserFromLocal(uid);
    }
    if (uid == "") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Profile(true, false)),
        (Route<dynamic> route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Profile(true, true)),
        (Route<dynamic> route) => false,
      );
    }
  }
}
