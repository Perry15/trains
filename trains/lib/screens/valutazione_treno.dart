import 'package:flutter/material.dart';

class ValutazioneTreno extends StatefulWidget {
  @override
  _ValutazioneTrenoState createState() => _ValutazioneTrenoState();
}

class _ValutazioneTrenoState extends State<ValutazioneTreno> {
  double _startX, _startY, _updateX, _updateY;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('Home'),
          backgroundColor: Color(0xff9b0014),
          elevation: 0.0,
        ),
        body:
            /*GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragStart: (event) {
              _startX = event.globalPosition.dx;
            },
            onHorizontalDragUpdate: (event) {
              _updateX = event.globalPosition.dx - _startX;
            },
            onHorizontalDragEnd: (event) {
              if (_updateX <= -65) {}
              if (_updateX >= 65) {}
            },
            onVerticalDragStart: (event) {},
            onVerticalDragUpdate: (event) {},
            onVerticalDragEnd: (event) {},
            child:*/
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              Text("Valuta il treno"),
              SizedBox(height: 20),
              Table(
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
                          child: Text('Vuoto'),
                        ),
                        feedback: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.green,
                          child: Text('Vuoto'),
                        ),
                      ),
                    ),
                    SizedBox.shrink(),
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: Draggable(
                        data: "Quasi vuoto",
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.yellow,
                          child: Text('Quasi vuoto'),
                        ),
                        feedback: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.yellow,
                          child: Text('Quasi vuoto'),
                        ),
                      ),
                    ),
                    TableCell(
                        child: DragTarget(builder: (context,
                            List<String> candidateData, rejectedData) {
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
                        child: Draggable(
                      data: "Quasi pieno",
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.orange,
                        child: Text('Quasi pieno'),
                      ),
                      feedback: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.orange,
                        child: Text('Quasi pieno'),
                      ),
                    ))
                  ]),
                  TableRow(children: [
                    SizedBox.shrink(),
                    TableCell(
                        child: Draggable(
                      data: "Pieno",
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.red,
                        child: Text('Pieno'),
                      ),
                      feedback: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.red,
                        child: Text('Pieno'),
                      ),
                    )),
                    SizedBox.shrink(),
                  ])
                ],
              )
            ]));
  }
}
