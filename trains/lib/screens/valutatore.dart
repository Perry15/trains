import 'package:flutter/material.dart';

class Valutatore extends StatelessWidget {
  static String assetName = 'assets/fingerprint.svg';
  final String voto;
  final MaterialColor color;
  final IconData icon;

  Valutatore(this.voto, this.color, this.icon);

  @override
  Widget build(BuildContext context) {
    return Draggable(
        data: voto,
        child: CircleAvatar(
          radius: 50,
          backgroundColor: color,
          child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: Column(children: [
                Icon(
                  icon,
                  color: color,
                  size: 40.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                ),
                Text(voto, textAlign: TextAlign.center)
              ])),
        ),
        feedback: CircleAvatar(
            radius: 50,
            backgroundColor: color,
            child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: Column(children: [
                  Icon(
                    icon,
                    color: color,
                    size: 40.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  ),
                  Text(voto, textAlign: TextAlign.center)
                ]))));
  }
}
