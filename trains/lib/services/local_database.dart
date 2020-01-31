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
        'CREATE TABLE evaluations (id STRING PRIMARY KEY, timestamp STRING DEFAULT CURRENT_TIMESTAMP, traincode STRING, vote STRING, location STRING)');
    await db.execute('CREATE TABLE locations (code STRING PRIMARY KEY)');
    await db.execute('CREATE TABLE trains (code STRING PRIMARY KEY)');
  }

  Future<Evaluation> insertEvaluation(Evaluation evaluation) async {
    var dbClient = await db;
    await dbClient.rawInsert("INSERT OR REPLACE INTO evaluations(id,location,timestamp,traincode,vote) VALUES ('"+evaluation.id+"','"+evaluation.location+"','"+evaluation.timestamp+"','"+evaluation.traincode+"','"+evaluation.vote+"');");
    return evaluation;
  }

  Future<Location> insertLocation(Location location) async {
    var dbClient = await db;
    await dbClient.rawInsert("INSERT OR REPLACE INTO locations(code) VALUES ('"+location.code+"');");
    return location;
  }

  Future<Train> insertTrain(Train train) async {
    var dbClient = await db;
    await dbClient.rawInsert("INSERT OR REPLACE INTO trains(code) VALUES ('"+train.code+"');");
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

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
