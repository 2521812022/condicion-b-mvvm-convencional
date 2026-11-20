import 'package:material_ui/material_ui.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/item_viewmodel.dart';
import 'item_detail_view.dart';
import 'login_view.dart';

/// Vista de listado con filtro de búsqueda en MVVM convencional.
class ItemListView extends StatefulWidget {
  final AuthViewModel authViewModel;
  final ItemViewModel itemViewModel;

  const ItemListView({
    super.key,
    required this.authViewModel,
    required this.itemViewModel,
  });

  @override
  State<ItemListView> createState() => _ItemListViewState();
}

class _ItemListViewState extends State<ItemListView> {
  @override
  void initState() {
    super.initState();
    widget.itemViewModel.loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado - MVVM'),
        actions: [
          IconButton(
            key: const Key('logout_button'),
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await widget.authViewModel.logout();
              if (context.mounted) {
                await Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (_) => LoginView(
                      authViewModel: widget.authViewModel,
                      itemViewModel: widget.itemViewModel,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              key: const Key('search_field'),
              onChanged: widget.itemViewModel.filterItems,
              decoration: const InputDecoration(
                labelText: 'Buscar por título o categoría',
              ),
            ),
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: widget.itemViewModel,
              builder: (context, _) {
                if (widget.itemViewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                final items = widget.itemViewModel.items;
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      key: Key('item_tile_${item.id}'),
                      title: Text(item.title),
                      subtitle: Text(item.category),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => ItemDetailView(
                            itemId: item.id,
                            itemViewModel: widget.itemViewModel,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
