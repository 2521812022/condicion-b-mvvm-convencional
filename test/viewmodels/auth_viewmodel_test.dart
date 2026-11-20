import 'package:condicion_b_mvvm_convencional/services/api_service.dart';
import 'package:condicion_b_mvvm_convencional/viewmodels/auth_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_database_helper.dart';

void main() {
  late AuthViewModel viewModel;

  setUp(() {
    viewModel = AuthViewModel(ApiService(), FakeDatabaseHelper());
  });

  test('Debe autenticar con credenciales válidas', () async {
    final ok = await viewModel.login('usuario_prueba', 'clave123');
    expect(ok, isTrue);
    expect(viewModel.session!.token, 'mock_jwt_token_mvvm_001');
  });

  test('Debe rechazar usuario o contraseña vacíos', () async {
    final ok = await viewModel.login('', '123');
    expect(ok, isFalse);
    expect(viewModel.errorMessage, isNotNull);
  });

  test('Debe rechazar credenciales inválidas', () async {
    final ok = await viewModel.login('otro_usuario', 'incorrecta');
    expect(ok, isFalse);
    expect(viewModel.session, isNull);
    expect(viewModel.errorMessage, isNotNull);
  });

  test('Debe limpiar la sesión al cerrar sesión', () async {
    await viewModel.login('usuario_prueba', 'clave123');
    await viewModel.logout();
    expect(viewModel.session, isNull);
  });
}