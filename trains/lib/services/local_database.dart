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
        'CREATE TABLE evaluations (id INTEGER PRIMARY KEY, timestamp DATETIME DEFAULT CURRENT_TIMESTAMP, traincode STRING, vote STRING)');
    await db.execute('CREATE TABLE locations (id STRING PRIMARY KEY)');
    await db.execute('CREATE TABLE trains (id STRING PRIMARY KEY)');
  }

  Future<Evaluation> insertEvaluation(Evaluation evaluation) async {
    var dbClient = await db;
    evaluation.id = await dbClient.insert('evaluations', evaluation.toMap());
    return evaluation;
  }

  Future<Location> insertLocation(Location location) async {
    var dbClient = await db;
    location.id = await dbClient.insert('locations', location.toMap());
    return location;
  }

  Future<Train> insertTrain(Train train) async {
    var dbClient = await db;
    train.id = await dbClient.insert('trains', train.toMap());
    return train;
  }

  Future<List<Evaluation>> getEvaluations() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('evaluations',
        columns: ['id', 'timestamp', 'traincode', 'vote']);
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
    List<Map> maps = await dbClient.query('locations', columns: ['id']);
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
    List<Map> maps = await dbClient.query('trains', columns: ['id']);
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

  Future<int> updateEvaluation(Evaluation evaluation) async {
    var dbClient = await db;
    return await dbClient.update(
      'evaluations',
      evaluation.toMap(),
      where: 'id = ?',
      whereArgs: [evaluation.id],
    );
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
