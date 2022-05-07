import 'package:smart_wallet/constants/models_properties_constants.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

import '../constants/db_constants.dart';

class DBHelper {
  static Future<sql.Database> database(String table) async {
    final databasePathDir = await sql.getDatabasesPath();

    String finalPath = path.join(databasePathDir, dbName);

    return sql.openDatabase(
      finalPath,
      //? this is when creating the database itself so create all your tables here
      onCreate: (db, version) async {
        //* creating transactions table
        await db.execute(
            'CREATE TABLE $transactionsTableName ($idString TEXT PRIMARY KEY,$titleString TEXT, $descriptionString TEXT,$amountString TEXT, $createdAtString TEXT, $transactionTypeString TEXT, $ratioToTotalString TEXT, $profileIdString TEXT, $syncFlagString TEXT, $deletedString TEXT , $userIdString TEXT )');
        //* creating profiles table
        await db.execute(
            'CREATE TABLE $profilesTableName ($idString TEXT PRIMARY KEY,$nameString TEXT, $incomeString TEXT, $outcomeString TEXT, $createdAtString TEXT, $lastActivatedDateString TEXT , $syncFlagString TEXT, $deletedString TEXT, $userIdString TEXT)');
        //* creating debts table
        await db.execute(
            'CREATE TABLE $debtsTableName ($idString TEXT PRIMARY KEY,$titleString TEXT,$amountString TEXT, $createdAtString TEXT, $fullfillingProfileIdString TEXT,$borrowingProfileIdString TEXT, $syncFlagString TEXT, $deletedString TEXT, $fulfilledString TEXT, $userIdString TEXT)');
        //* creating quick actions table
        return db.execute(
            'CREATE TABLE $quickActionsTableName ($idString TEXT PRIMARY KEY,$titleString TEXT, $descriptionString TEXT,$amountString TEXT, $createdAtString TEXT, $transactionTypeString TEXT,  $isFavoriteString TEXT, $profileIdString TEXT , $quickActionIndexString TEXT,$syncFlagString TEXT, $deletedString TEXT , $userIdString TEXT)');
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
    return await db.query(table);
  }

  static Future<List<Map<String, dynamic>>> getDataWhere(
      String table, String check, String profileId) async {
    final db = await DBHelper.database(table);
    return db.query(table, where: '$check = ?', whereArgs: [profileId]);
  }

  static Future<void> deleteDatabase(String dbName) async {
    final databasePathDir = await sql.getDatabasesPath();
    String finalPath = path.join(databasePathDir, dbName);
    return sql.deleteDatabase(finalPath);
  }

  static Future<void> deleteById(String id, String table) async {
    final db = await DBHelper.database(table);
    return db.execute("DELETE FROM $table WHERE id='$id'");
  }
}
