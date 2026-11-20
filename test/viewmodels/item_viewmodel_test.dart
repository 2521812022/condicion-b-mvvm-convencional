import 'package:condicion_b_mvvm_convencional/services/api_service.dart';
import 'package:condicion_b_mvvm_convencional/viewmodels/item_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_database_helper.dart';

void main() {
  late ItemViewModel viewModel;

  setUp(() {
    viewModel = ItemViewModel(ApiService(), FakeDatabaseHelper());
  });

  test('Debe cargar la lista de elementos', () async {
    await viewModel.loadItems();
    expect(viewModel.items.length, 3);
    expect(viewModel.isLoading, isFalse);
  });

  test('Debe cargar el detalle cuando el ID es válido', () async {
    await viewModel.loadDetail('1');
    expect(viewModel.selectedItem?.id, '1');
  });

  test('Debe reportar error cuando el ID está vacío', () async {
    await viewModel.loadDetail('   ');
    expect(viewModel.errorMessage, isNotNull);
    expect(viewModel.selectedItem, isNull);
  });

  test('Debe reportar error cuando el elemento no existe', () async {
    await viewModel.loadDetail('999');
    expect(viewModel.errorMessage, isNotNull);
  });
}