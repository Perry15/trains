import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

import 'package:trains/services/viaggiatreno.dart';
import 'package:trains/screens/partenze_load.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return PartenzeLoad(fetchPartenze(
        toSearch: 'S02581/' +
            formatDate(DateTime.now(), [
              D,
              ' ',
              M,
              ' ',
              d,
              ' ',
              yyyy,
              ' ',
              HH,
              ':',
              nn,
              ':',
              ss,
              ' ',
              z
            ])));
  }
}
