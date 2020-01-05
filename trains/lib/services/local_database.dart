import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:trains/models/evaluation.dart';
import 'package:trains/models/location.dart';
import 'package:trains/models/train.dart';

class LocalDatabaseService {
  static Database _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    String path = join(await getDatabasesPath(), 'evaluations.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE evaluations (id STRING PRIMARY KEY, timestamp DATETIME DEFAULT CURRENT_TIMESTAMP, traincode STRING, vote STRING, location STRING)');
    await db.execute('CREATE TABLE locations (code STRING PRIMARY KEY)');
    await db.execute('CREATE TABLE trains (code STRING PRIMARY KEY)');
  }

  Future<Evaluation> insertEvaluation(Evaluation evaluation) async {
    var dbClient = await db;
    await dbClient.insert('evaluations', evaluation.toMap());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int evaluationsPoints = prefs.getInt('evaluationsPoints') ?? 0;
    prefs.setInt('evaluationsPoints', evaluationsPoints + 10);
    return evaluation;
  }

  Future<Location> insertLocation(Location location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int locationsPoints = prefs.getInt('locationsPoints') ?? 0;
    List<Location> locations = await getLocations();
    if (!locations.contains(location.code))
      prefs.setInt('locationsPoints', locationsPoints + 20);
    var dbClient = await db;
    var id = await dbClient.update('locations', location.toMap());
    if (id == 0) await dbClient.insert('locations', location.toMap());
    return location;
  }

  Future<Train> insertTrain(Train train) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int trainsPoints = prefs.getInt('trainsPoints') ?? 0;
    List<Train> trains = await getTrains();
    if (!trains.contains(train.code))
      prefs.setInt('trainsPoints', trainsPoints + 10);
    var dbClient = await db;
    var id = await dbClient.update('trains', train.toMap());
    if (id == 0) await dbClient.insert('trains', train.toMap());
    return train;
  }

  Future<List<Evaluation>> getEvaluations() async {
    var dbClient = await db;
    List<Map> maps = await dbClient
        .query('evaluations', columns: ['id', 'traincode', 'vote', 'location']);
    List<Evaluation> evaluations = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        evaluations.add(Evaluation.fromMap(maps[i]));
      }
    }
    return evaluations;
  }

  Future<List<Location>> getLocations() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('locations', columns: ['code']);
    List<Location> locations = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        locations.add(Location.fromMap(maps[i]));
      }
    }
    return locations;
  }

  Future<List<Train>> getTrains() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('trains', columns: ['code']);
    List<Train> trains = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        trains.add(Train.fromMap(maps[i]));
      }
    }
    return trains;
  }

  Future<int> deleteEvaluation(int id) async {
    var dbClient = await db;
    return await dbClient.delete(
      'evaluations',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteLocation(int id) async {
    var dbClient = await db;
    return await dbClient.delete(
      'locations',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTrain(int id) async {
    var dbClient = await db;
    return await dbClient.delete(
      'trains',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<double> updateLevel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int locationsPoints = prefs.getInt('locationsPoints') ?? 0;
    int trainsPoints = prefs.getInt('trainsPoints') ?? 0;
    int evaluationsPoints = prefs.getInt('evaluationsPoints') ?? 0;
    int x = locationsPoints + trainsPoints + evaluationsPoints;
    double level = prefs.getDouble('level') ?? 0;
    if (level < 2)
      level = level + 1;
    else
      level = 2 + sqrt(((x - 40) / 5));
    prefs.setDouble('level', level);
    return level;
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
