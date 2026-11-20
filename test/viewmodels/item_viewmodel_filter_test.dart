import 'package:condicion_b_mvvm_convencional/services/api_service.dart';
import 'package:condicion_b_mvvm_convencional/viewmodels/item_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_database_helper.dart';

void main() {
  late ItemViewModel viewModel;

  setUp(() async {
    viewModel = ItemViewModel(ApiService(), FakeDatabaseHelper());
    await viewModel.loadItems();
  });

  test('Filtra correctamente por título o categoría', () {
    viewModel.filterItems('métricas');
    expect(viewModel.items.length, 1);
    expect(viewModel.items.first.id, '2');
  });

  test('Retorna todos los elementos si la consulta está vacía', () {
    viewModel.filterItems('  ');
    expect(viewModel.items.length, 3);
  });
}