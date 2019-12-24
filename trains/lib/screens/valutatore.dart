import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Valutatore extends StatelessWidget {
  static String assetName = 'assets/fingerprint.svg';
  final Widget fingerprint = SvgPicture.asset(
    assetName,
    semanticsLabel: 'Fingerprint',
    fit: BoxFit.contain,
    height: 40,
  );
  final String voto;
  final MaterialColor color;

  Valutatore(this.voto, this.color);

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
                fingerprint,
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
                  fingerprint,
                  Text(voto, textAlign: TextAlign.center)
                ]))));
  }
}
