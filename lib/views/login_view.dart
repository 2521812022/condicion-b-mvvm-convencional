import 'package:material_ui/material_ui.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/item_viewmodel.dart';
import 'item_list_view.dart';

/// Vista funcional de login en arquitectura MVVM convencional.
class LoginView extends StatefulWidget {
  final AuthViewModel authViewModel;
  final ItemViewModel itemViewModel;

  const LoginView({
    super.key,
    required this.authViewModel,
    required this.itemViewModel,
  });

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _userController = TextEditingController(text: 'usuario_prueba');
  final _passController = TextEditingController(text: 'clave123');

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final ok = await widget.authViewModel.login(
      _userController.text,
      _passController.text,
    );
    if (ok && mounted) {
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => ItemListView(
            authViewModel: widget.authViewModel,
            itemViewModel: widget.itemViewModel,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login - MVVM Convencional')),
      body: ListenableBuilder(
        listenable: widget.authViewModel,
        builder: (context, _) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  key: const Key('username_field'),
                  controller: _userController,
                  decoration: const InputDecoration(labelText: 'Usuario'),
                ),
                TextField(
                  key: const Key('password_field'),
                  controller: _passController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Contraseña'),
                ),
                const SizedBox(height: 16),
                if (widget.authViewModel.errorMessage != null)
                  Text(
                    widget.authViewModel.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ElevatedButton(
                  key: const Key('login_button'),
                  onPressed: widget.authViewModel.isLoading ? null : _submit,
                  child: Text(widget.authViewModel.isLoading ? 'Cargando...' : 'Ingresar'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
