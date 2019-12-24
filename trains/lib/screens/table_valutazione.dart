import 'package:flutter/material.dart';
import 'package:trains/screens/valutatore.dart';

class TableValutazione extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(children: [
          SizedBox.shrink(),
          TableCell(
            child: Valutatore("Vuoto", Colors.green),
          ),
          SizedBox.shrink(),
        ]),
        TableRow(children: [
          TableCell(
            child: Valutatore("Quasi vuoto", Colors.yellow),
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
            child: Valutatore("Quasi pieno", Colors.orange),
          )
        ]),
        TableRow(children: [
          SizedBox.shrink(),
          TableCell(
            child: Valutatore("Pieno", Colors.red),
          ),
          SizedBox.shrink(),
        ])
      ],
    );
  }
}
