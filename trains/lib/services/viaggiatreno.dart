import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:trains/models/viaggiatreno.dart';

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

Future<Partenze> fetchPartenze({toSearch}) async {
  final response = await http.get(
      'http://www.viaggiatreno.it/viaggiatrenonew/resteasy/viaggiatreno/partenze/' +
          toSearch);

  if (response.statusCode == 200) {
    return Partenze.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load stations');
  }
}

Future<Treno> fetchTreno({toSearch}) async {
  final response = await http.get(
      'http://www.viaggiatreno.it/viaggiatrenonew/resteasy/viaggiatreno/andamentoTreno/' +
          toSearch);

  if (response.statusCode == 200) {
    return Treno.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load train details');
  }
}
