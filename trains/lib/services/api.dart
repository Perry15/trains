import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:trains/models/cerca_stazioni.dart';

Future<CercaStazioni> fetchCercaStazioni({toSearch}) async {
  final response = await http.get(
      'http://www.viaggiatreno.it/viaggiatrenonew/resteasy/viaggiatreno/cercaStazione/' +
          toSearch);

  if (response.statusCode == 200) {
    return CercaStazioni.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load post');
  }
}
