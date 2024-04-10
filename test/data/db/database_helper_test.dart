import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/model/restaurant.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future main() async {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('Insert, Get, Delete, Get By ID - Favorite', () async {
    String tblFavorite = 'favorites_test';

    var db = await openDatabase(inMemoryDatabasePath, version: 1,
        onCreate: (db, version) async {
      await db.execute('''CREATE TABLE $tblFavorite (
            id TEXT PRIMARY KEY,
            name TEXT,
            description TEXT,
            pictureId TEXT,
            city TEXT,
            rating REAL
           )     
        ''');
    });

    Restaurant restaurant = Restaurant(
      id: "fnfn8mytkpmkfw1e867",
      name: "Makan mudah",
      description: "But I must explain to you how all this mistaken idea",
      pictureId: "22",
      city: "Medan",
      rating: 3.7,
    );

    // Insert
    await db.insert(tblFavorite, restaurant.toJson());

    // Get
    List<Map<String, dynamic>> queryResult = await db.query(tblFavorite);
    expect(queryResult, hasLength(1));

    // Delete
    await db.delete(tblFavorite, where: 'id = ?', whereArgs: [restaurant.id]);

    // Get By ID
    List<Map<String, dynamic>> results = await db.query(
      tblFavorite,
      where: 'id = ?',
      whereArgs: [restaurant.id],
    );
    expect(results, isEmpty); 

    await db.close();
  });

  tearDownAll(() async {
    databaseFactory = null;
  });
}
