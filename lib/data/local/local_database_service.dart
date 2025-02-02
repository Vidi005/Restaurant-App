import 'package:restaurant_app/data/model/restaurant_list.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabaseService {
  static const _databaseName = 'restaurant-app.db';
  static const _tableName = 'restaurant';
  static const _version = 1;

  Future createTables(Database database) async {
    await database.execute('''
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY NOT NULL UNIQUE,
        name TEXT,
        description TEXT,
        pictureId TEXT,
        city TEXT,
        rating REAL
      )
    ''');
  }

  Future<Database> _initializeDb() async => openDatabase(
        _databaseName,
        version: _version,
        onCreate: (database, version) async => await createTables(database),
      );

  Future insertItem(RestaurantList restaurant) async {
    final db = await _initializeDb();
    final id = await db.rawInsert(
        "INSERT INTO $_tableName VALUES('${restaurant.id}', '${restaurant.name}', '${restaurant.description}', '${restaurant.pictureId}', '${restaurant.city}', ${restaurant.rating})");
    return id;
  }

  Future getAllItems() async {
    final db = await _initializeDb();
    final result = await db.rawQuery('SELECT * FROM $_tableName');
    return result.map((e) => RestaurantList.fromJson(e)).toList();
  }

  Future getItemById(id) async {
    final db = await _initializeDb();
    final result =
        await db.rawQuery("SELECT * FROM $_tableName WHERE id = '$id' LIMIT 1");
    return result.map((e) => RestaurantList.fromJson(e)).first;
  }

  Future deleteItemById(id) async {
    final db = await _initializeDb();
    return await db.rawDelete("DELETE FROM $_tableName WHERE id = '$id'");
  }
}
