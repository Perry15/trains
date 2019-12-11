import 'package:flutter/material.dart';
import 'package:trains/screens/home.dart';
import 'package:trains/services/auth.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(//tutto quello racchiuso nello stream può ottenere info sullo stream
      value: AuthService().user,
      child: MaterialApp(
        home: Home(),//ottiene info sullo user se loggato mostra home altrimenti authenticate
      ),
    );
  }
}

