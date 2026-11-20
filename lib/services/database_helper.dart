import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Helper directo de SQLite utilizado por los ViewModels en MVVM convencional.
/// Retorna null en plataformas sin sqflite nativo (ej. Web/Desktop sin FFI).
class DatabaseHelper {
  Database? _db;

  Future<Database?> get database async {
    if (kIsWeb) {
      return null;
    }
    if (_db != null) {
      return _db;
    }
    try {
      final path = join(await getDatabasesPath(), 'prototipo_mvvm.db');
      _db = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute(
            'CREATE TABLE session(user_id TEXT PRIMARY KEY, username TEXT, token TEXT)',
          );
          await db.execute(
            'CREATE TABLE items(id TEXT PRIMARY KEY, title TEXT, description TEXT, category TEXT)',
          );
        },
      );
      return _db;
    } catch (_) {
      return null;
    }
  }
}
