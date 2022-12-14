import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseSqflite {
  openDB() async {
    try {
      final database = await openDatabase(
        join(await getDatabasesPath(), 'fatigue_test.db'),
        onCreate: (db, version) async {
          await db.execute(
            '''CREATE TABLE user(
            name TEXT,
            nik TEXT PRIMARY KEY, 
          unit TEXT,
          account_type TEXT
          )''',
          );
          await db.execute('''CREATE TABLE test(
          id_test INTEGER PRIMARY KEY AUTOINCREMENT, 
          test_number INTEGER,
          sleep_date DATETIME,
          wakeup_date DATETIME,
          date_created DATETIME,
          result_test INTEGER,
          rate_test INTEGER, 
          status_test TEXT,
          nik_user TEXT,
          FOREIGN KEY(nik_user) REFERENCES user(nik)
          )''');
        },
        version: 1,
      );
      return database;
    } catch (e) {
      log(e.toString());
    }
  }
}
