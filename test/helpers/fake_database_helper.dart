import 'package:condicion_b_mvvm_convencional/services/database_helper.dart';
import 'package:sqflite/sqflite.dart';

/// Doble de prueba: evita el plugin nativo de SQLite en pruebas unitarias.
class FakeDatabaseHelper extends DatabaseHelper {
  @override
  Future<Database?> get database async => null;
}