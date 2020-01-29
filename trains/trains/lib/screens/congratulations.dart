import 'package:flutter/material.dart';
import 'dart:async';
import 'package:trains/screens/profile.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

class Congratulations extends StatefulWidget {
  final bool _login;
  Congratulations(this._login);
  @override
  State<StatefulWidget> createState() {
    return CongratulationsState();
  }
}

class CongratulationsState extends State<Congratulations> {
  ConfettiController _controllerTopCenter;
  @override
  void initState() {
    super.initState();
    _controllerTopCenter = ConfettiController(duration: Duration(seconds: 4));
    _controllerTopCenter.play();
    loadData();
  }

  @override
  void dispose() {
    _controllerTopCenter.dispose();
    super.dispose();
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 5), onDoneLoading);
  }

  onDoneLoading() async {
    if (widget._login)
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Profile(false, false)));
    else
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Profile(false, true)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff9b0014),
      body: Center(
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          overflow: Overflow.visible,
          children: <Widget>[
            Positioned.fill(
              top: MediaQuery.of(context).size.height / 3.5,
              child: Image.asset(
                "assets/iconTrains.png",
                fit: BoxFit.fitWidth,
                alignment: Alignment.center,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _controllerTopCenter,
                blastDirection: pi / 2,
                maxBlastForce: 10,
                minBlastForce: 5,
                emissionFrequency: 0.05,
                numberOfParticles: 25,
                colors: [
                  Colors.blue,
                  Colors.red,
                  Colors.green,
                  Colors.yellow,
                  Colors.orange,
                  Colors.purple
                ],
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 4,
              child: Text(
                "CONGRATULAZIONI!!!\n\nHai valutato!!!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 12,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
