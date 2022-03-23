import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

import '../constants/db_constants.dart';

class DBHelper {
  static Future<sql.Database> database(String table) async {
    final databasePathDir = await sql.getDatabasesPath();
    String finalPath = path.join(databasePathDir, dbName);

    return await sql.openDatabase(
      finalPath,
      //! this is when creating the database itself so create all your tables here
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE $transactionsTableName (id TEXT PRIMARY KEY,title TEXT, description TEXT,amount TEXT, createdAt TEXT, transactionType TEXT, ratioToTotal TEXT )');

        return await db.execute(
            'CREATE TABLE $quickActionsTableName (id TEXT PRIMARY KEY,title TEXT, description TEXT,amount TEXT, createdAt TEXT, transactionType TEXT, ratioToTotal TEXT )');
      },
      version: 1,
    );
  }

  static Future<void> insert(
    String table,
    Map<String, dynamic> data,
  ) async {
    final db = await DBHelper.database(table);

    await db.insert(
      table,
      data,
      //? this line is for replacing the data if the id already exists
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database(table);
    return db.query(table);
  }

  static Future<void> deleteById(String id, String table) async {
    final db = await DBHelper.database(table);
    return db.execute("DELETE FROM $table WHERE id='$id'");
  }
}
