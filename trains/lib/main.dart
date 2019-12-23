import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:trains/screens/valutazione_treno.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Container(child: ValutazioneTreno()));
  }
}
