import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/planet.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'planets.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE planets(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, distance REAL, size REAL, nickname TEXT)',
        );
      },
      version: 1,
    );
  }

  static Future<int> insertPlanet(Planet planet) async {
    final db = await DBHelper.database();
    return await db.insert('planets', planet.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Planet>> fetchPlanets() async {
    final db = await DBHelper.database();
    final List<Map<String, dynamic>> maps = await db.query('planets');
    return List.generate(maps.length, (i) => Planet.fromMap(maps[i]));
  }

  static Future<int> updatePlanet(Planet planet) async {
    final db = await DBHelper.database();
    return await db.update('planets', planet.toMap(), where: 'id = ?', whereArgs: [planet.id]);
  }

  static Future<void> deletePlanet(int id) async {
    final db = await DBHelper.database();
    await db.delete('planets', where: 'id = ?', whereArgs: [id]);
  }
}