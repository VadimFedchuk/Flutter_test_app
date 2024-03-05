import 'package:flutter/material.dart';
import 'package:flutter_test_app/model/color_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Defines a constant for the database table name to ensure consistency
/// in its usage.
const String tableName = "colors";

/// DBProvider class follows the Singleton pattern to ensure only one instance
/// is created throughout the app.
class DBProvider {
  DBProvider._();
  /// Static final variable that holds the single instance of DBProvider.
  static final DBProvider db = DBProvider._();

  /// Asynchronous method to initialize the database.
  /// This method will return a Database instance for CRUD operations.
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

  /// Asynchronous method to add a color entry to the database.
  /// Accepts a ColorModel instance and returns an integer ID
  /// of the inserted row.
  Future<int> addColorToDB(ColorModel color) async {
    final Database db = await DBProvider.db.initDB();
    return db.insert(
        tableName, color.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,);
  }

  /// Asynchronous method to retrieve all color entries from the database.
  /// Returns a list of ColorModel instances constructed from the database rows.
  Future<List<ColorModel>> getColorsFromDB() async {
    final db = await initDB();
    final List<Map<String, Object?>> queryResult = await db.query(tableName);
    return queryResult.map(ColorModel.fromMap).toList();
  }

  /// Asynchronous method to delete all color entries from the database.
  /// Returns a boolean indicating the success of the operation.
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
