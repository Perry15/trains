import 'package:flutter/material.dart';
import 'package:trains/screens/destination.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Color(0xff9b0014),
        elevation: 0.0,
      ),
      body: Center(
        child: RaisedButton(
          color: Color(0xff9b0014),
          child: Text(
            'Cerca destinazione',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Destination()),
            );
          },
        ),
      ),
    );
  }
}
