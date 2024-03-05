import 'package:flutter/material.dart';
import 'package:flutter_test_app/model/color_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String tableName = "colors";

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  Future<Database> initDB() async {
    final String path = await getDatabasesPath();

    return openDatabase(
      join(path, '$tableName.db'),
      onCreate: (database, version) async {
        await database.execute("""
            CREATE TABLE $tableName(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                color TEXT NOT NULL
            )
        """);
      },
      version: 1,
    );
  }

  Future<int> addColorToDB(ColorModel color) async {
    final Database db = await DBProvider.db.initDB();
    return db.insert(
        tableName, color.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,);
  }

  Future<List<ColorModel>> getColorsFromDB() async {
    final db = await initDB();
    final List<Map<String, Object?>> queryResult = await db.query(tableName);
    return queryResult.map(ColorModel.fromMap).toList();
  }

  Future<bool> deleteColorsFromDB() async {
    final db = await initDB();
    try {
      await db.rawDelete("DELETE FROM $tableName");
      return true;
    } catch (error) {
      debugPrint("Something went wrong when deleting an item: $error");
      return false;
    }
  }
}
