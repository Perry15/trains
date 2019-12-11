import 'package:flutter/material.dart';
import 'package:trains/screens/home.dart';
import 'package:trains/services/auth.dart';
import './screens/trains.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return TrainList();
  }
}
