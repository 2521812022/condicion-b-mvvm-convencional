import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import '../models/item_dto.dart';
import '../services/api_service.dart';
import '../services/database_helper.dart';

/// ViewModel de elementos convencional: acopla estado, llamadas Dio, parseo y SQLite.
class ItemViewModel extends ChangeNotifier {
  final ApiService _apiService;
  final DatabaseHelper _dbHelper;

  List<ItemDto> items = [];
  ItemDto? selectedItem;
  bool isLoading = false;
  String? errorMessage;

  ItemViewModel(this._apiService, this._dbHelper);

  Future<void> loadItems() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.dio.get<List<dynamic>>('/items');
      if (response.statusCode == 200 && response.data != null) {
        items = response.data!
            .map((e) => ItemDto.fromMap(e as Map<String, dynamic>))
            .toList();
        final db = await _dbHelper.database;
        if (db != null) {
          for (final item in items) {
            await db.insert(
              'items',
              item.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }
        }
      }
    } catch (_) {
      final db = await _dbHelper.database;
      if (db != null) {
        final rows = await db.query('items');
        items = rows.map(ItemDto.fromMap).toList();
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadDetail(String id) async {
    if (id.trim().isEmpty) {
      errorMessage = 'El ID del elemento no puede estar vacío.';
      notifyListeners();
      return;
    }
    isLoading = true;
    notifyListeners();

    final response = await _apiService.dio.get<Map<String, dynamic>>('/items/$id');
    if (response.statusCode == 200 && response.data != null) {
      selectedItem = ItemDto.fromMap(response.data!);
    } else {
      errorMessage = 'No se encontró el elemento.';
    }
    isLoading = false;
    notifyListeners();
  }
}
