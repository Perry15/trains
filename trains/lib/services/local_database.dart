import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:trains/models/evaluation.dart';

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
  }

  Future<Evaluation> insertEvaluation(Evaluation evaluation) async {
    var dbClient = await db;
    evaluation.id = await dbClient.insert('evaluations', evaluation.toMap());
    return evaluation;
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

  Future<int> deleteEvaluation(int id) async {
    var dbClient = await db;
    return await dbClient.delete(
      'evaluations',
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
