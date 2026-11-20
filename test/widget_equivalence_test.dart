import 'package:condicion_b_mvvm_convencional/models/item_dto.dart';
import 'package:condicion_b_mvvm_convencional/services/api_service.dart';
import 'package:condicion_b_mvvm_convencional/services/database_helper.dart';
import 'package:condicion_b_mvvm_convencional/viewmodels/auth_viewmodel.dart';
import 'package:condicion_b_mvvm_convencional/viewmodels/item_viewmodel.dart';
import 'package:condicion_b_mvvm_convencional/views/login_view.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

class _StubAuthViewModel extends AuthViewModel {
  _StubAuthViewModel() : super(ApiService(), DatabaseHelper());
  @override
  Future<bool> login(String username, String password) async => true;
}

class _StubItemViewModel extends ItemViewModel {
  _StubItemViewModel() : super(ApiService(), DatabaseHelper());
  @override
  Future<void> loadItems() async {
    items = const [
      ItemDto(id: '1', title: 'Elemento 1', description: 'Desc 1', category: 'Cat A'),
    ];
    notifyListeners();
  }
}

void main() {
  testWidgets('Equivalencia funcional: Login navega al listado', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginView(
          authViewModel: _StubAuthViewModel(),
          itemViewModel: _StubItemViewModel(),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('search_field')), findsOneWidget);
    expect(find.text('Elemento 1'), findsOneWidget);
  });
}
