import 'package:flutter_news/src/models/item_model.dart' as prefix0;
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import '../models/item_model.dart';


class NewsDbProvider {
  Database db;


  void init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory(); // directory on our mobile device
    final path = join(documentsDirectory.path, 'items.db');
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version) {
        // only invoked if the database doesn't exist
        newDb.execute(
          """
            CREATE TABLE Items
            (
              id INTEGER PRIMARY KEY,
              type TEXT,
              by TEXT,
              time INTEGER,
              text TEXT,
              parent INTEGER,
              kids BLOB,
              dead INTEGER,
              deleted INTEGER,
              title: TEXT,
              decendants INTEGER
            )
          """
        );
      }
    );
  }

  Future<ItemModel> fetchItem(int id) async {
    final maps = await db.query(
      "Items",
      columns: null, // gives all the columns otherwise can give a list [columnName]
      where: "id=?", // question mark gets replaced by first entry in whereArgs list
      whereArgs: [id],
    );

    if(maps.length > 0) {
      return ItemModel.fromDb(maps.first);
    }
    return null;
  }

  Future<int> addItem(ItemModel item) {
    db.insert("Items", item.toMap());
  }
}