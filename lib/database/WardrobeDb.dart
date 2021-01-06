import 'dart:async';
import 'dart:io' as io;

import 'package:flutterdemoappwardrobe/model/PhotoVO.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class WardrobeDb {
  static Database _db;
  static const String ID = "id";
  static const String IMAGE_NAME = "image";
  static const String FAVOURITE = "favourite";
  static const String WEAR_ON = "wear_type"; // top 1,Bottom 2
  static const String TABLE_NAME = "MyWardrobe";
  static const String DB_NAME = "cloths.db";

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initialize();
    return _db;
  }

  initialize() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  // single time instantiation
  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE_NAME ($ID INTEGER PRIMARY KEY AUTOINCREMENT, $IMAGE_NAME TEXT,  $FAVOURITE TEXT,  $WEAR_ON TEXT)");
  }

  // close the database
  Future close() async {
    var dBInstance = await db;
    dBInstance.close();
  }

  // save image
  Future<PhotoVO> save(PhotoVO photoVO) async {
    var dbClient = await db;
    photoVO.id = await dbClient.insert(TABLE_NAME, photoVO.toMap());
    print("Inserted photoVO.id");
    print(photoVO.id);
  }

  // get list of photos
  Future<List<PhotoVO>> getList() async {
    var dbClient = await db;
    List<Map> maps = await dbClient
        .query(TABLE_NAME, columns: [ID, IMAGE_NAME, FAVOURITE, WEAR_ON]);
    List<PhotoVO> photos = [];
    if (maps.length > 0) {
      print("map length ${maps.length}");
      for (int i = 0; i < maps.length; i++) {
        photos.add(PhotoVO.fromMap(maps[i]));
      }
    }
    return photos;
  }

  // update Favourite
  Future<int> updateFav(PhotoVO photoVO) async {
    var dbClient = await db;
    var result = await dbClient.update(TABLE_NAME, photoVO.toMap(),
        where: '$ID = ?', whereArgs: [photoVO.id]);
    print("Updated ${photoVO.id}");
    return result;
  }
}
