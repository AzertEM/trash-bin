import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class BinLocation {
  final int id;
  final double longitude;
  final double latitude;
  static final columns = ['id', 'longitude', 'latitude'];
  const BinLocation({
    required this.id,
    required this.longitude,
    required this.latitude
  });

  factory BinLocation.fromMap(Map<dynamic, dynamic> data) {
    return BinLocation(
      id: data['id'],
      longitude: data['longitude'],
      latitude: data['latitude'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'longtitude': longitude,
      'latitude': latitude,
    };
  }
}

class DBprovider {
  DBprovider._();
  static final DBprovider db = DBprovider._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = initDB();
    return _database!;
  }

  initDB() async {
    Directory docDirectory = await getApplicationDocumentsDirectory();
    String path = join(docDirectory.path, 'data.db');

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute('CREATE TABLE binlocation(id INTEGER PRIMARY KEY, longitude FLOAT, latitude FLOAT)');

        await db.execute(
          "INSERT INTO binlocation('id', 'longitude', 'latitude') values (?, ?, ?)",
          [1, 151.190432, -33.89212],
          );
        
        await db.execute(
          "INSERT INTO binlocation('id', 'longitude', 'latitude') values (?, ?, ?)",
          [2, 151.187617, -33.886408],
          );
      }
    );
  }
  Future<List<BinLocation>> getAllBins() async {
    final Database db = await database;

    List <Map> results = await db.query(
      "binlocation", columns: BinLocation.columns, orderBy: "id ASC"
    );

    List<BinLocation> locations = List.empty();
    results.forEach((result) {
      BinLocation location = BinLocation.fromMap(result);
      locations.add(location);
    });

    return locations;
  }
}
