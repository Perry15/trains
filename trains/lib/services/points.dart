import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:trains/services/database.dart';
import 'package:trains/services/local_database.dart';

class Points {
  final LocalDatabaseService local = LocalDatabaseService();
  final DatabaseService remote = DatabaseService();

  Future<double> getLevel() async {
    int x = await getLocationsPoints() +
        await getTrainsPoints() +
        await getEvaluationsPoints();
    double level = 2 + sqrt(((x - 40) / 5));
    if (level < 2) level = level.truncate().toDouble() + 1;
    if (level.isNaN) {
      print("LEVEL: $level");
      level = 2;
    }
    return level;
  }

  Future<int> getTrainsPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int trainsPoints = 0;
    List<String> localTrains =
        ((await local.getTrains()).map((train) => train.code).toList());
    String uid = prefs.getString('uid') ?? "";
    if (uid != "") {
      List<dynamic> remoteTrains = await remote.getUserTrains(uid);
      remoteTrains.forEach((train) => {
            if (!localTrains.contains(train)) {trainsPoints += 10}
          });
    }
    localTrains.forEach((train) => {trainsPoints += 10});
    return trainsPoints;
  }

  Future<int> getEvaluationsPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int evaluationsPoints = 0;
    List<String> localEvaluations = ((await local.getEvaluations())
        .map((evaluation) => evaluation.id)
        .toList());
    String uid = prefs.getString('uid') ?? "";
    if (uid != "") {
      List<dynamic> remoteEvaluations = await remote.getUserEvaluations(uid);
      remoteEvaluations.forEach((evaluation) => {
            if (!localEvaluations.contains(evaluation))
              {evaluationsPoints += 10}
          });
    }
    localEvaluations.forEach((train) => {evaluationsPoints += 10});
    return evaluationsPoints;
  }

  Future<int> getLocationsPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int locationsPoints = 0;
    List<String> localLocations = ((await local.getLocations())
        .map((location) => location.code)
        .toList());
    String uid = prefs.getString('uid') ?? "";
    if (uid != "") {
      List<dynamic> remoteLocations = await remote.getUserLocations(uid);
      remoteLocations.forEach((location) => {
            if (!localLocations.contains(location)) {locationsPoints += 20}
          });
    }
    localLocations.forEach((train) => {locationsPoints += 20});
    return locationsPoints;
  }
}
