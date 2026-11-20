import 'package:material_ui/material_ui.dart';
import 'services/api_service.dart';
import 'services/database_helper.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/item_viewmodel.dart';
import 'views/login_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final apiService = ApiService();
  final dbHelper = DatabaseHelper();

  runApp(
    MvvmConvencionalApp(
      authViewModel: AuthViewModel(apiService, dbHelper),
      itemViewModel: ItemViewModel(apiService, dbHelper),
    ),
  );
}

/// Raíz de la aplicación Condición B (MVVM Convencional).
class MvvmConvencionalApp extends StatelessWidget {
  final AuthViewModel authViewModel;
  final ItemViewModel itemViewModel;

  const MvvmConvencionalApp({
    super.key,
    required this.authViewModel,
    required this.itemViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prototipo MVVM Convencional',
      home: LoginView(
        authViewModel: authViewModel,
        itemViewModel: itemViewModel,
      ),
    );
  }
}
