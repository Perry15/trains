import 'package:flutter/material.dart';
import 'package:trains/screens/home.dart';
import 'package:trains/services/auth.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Home(),
    );
  }
}
