import 'package:flutter/material.dart';
//import 'package:trains/screens/home.dart';
import 'package:trains/screens/login.dart';
import 'package:trains/services/auth.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';
import 'package:flutter/services.dart';


void main(){
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(//tutto quello racchiuso nello stream può ottenere info sullo stream
      value: AuthService().user,
      child: MaterialApp(
        home: //Home(),//commentato per andare subito al login
        Login(),
      ),
    );
  }
}

/*RIEPILOGO SPESE FATTE
Travestimento: 34.82
Stampe Papiri A0 (1 a colori 3 b/n): 18
smartbox: 59.9
sopressa e cotechino: 5.94+12.7=18.7
caricatura: 35
valigia: 169
coriandoli e varie: 7.8
TOTALE: 343.22*/
