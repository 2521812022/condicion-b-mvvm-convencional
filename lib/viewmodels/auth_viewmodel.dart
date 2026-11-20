import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import '../models/user_session.dart';
import '../services/api_service.dart';
import '../services/database_helper.dart';

/// ViewModel de autenticación convencional: mezcla validación, estado, Dio y SQLite.
class AuthViewModel extends ChangeNotifier {
  final ApiService _apiService;
  final DatabaseHelper _dbHelper;

  UserSession? session;
  bool isLoading = false;
  String? errorMessage;

  AuthViewModel(this._apiService, this._dbHelper);

  Future<bool> login(String username, String password) async {
    if (username.trim().isEmpty || password.trim().isEmpty) {
      errorMessage = 'Usuario y contraseña requeridos.';
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: {'username': username.trim(), 'password': password},
      );

      if (response.statusCode == 200 && response.data != null) {
        session = UserSession.fromMap(response.data!);
        _apiService.authToken = session!.token;
        final db = await _dbHelper.database;
        if (db != null) {
          await db.insert(
            'session',
            session!.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
        return true;
      }

      errorMessage = 'Credenciales inválidas (use usuario_prueba / clave123).';
      return false;
    } catch (e) {
      errorMessage = 'Error al iniciar sesión: $e';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _apiService.authToken = null;
    final db = await _dbHelper.database;
    if (db != null) {
      await db.delete('session');
    }
    session = null;
    notifyListeners();
  }
}
