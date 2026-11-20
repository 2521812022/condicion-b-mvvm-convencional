import 'package:material_ui/material_ui.dart';
import '../viewmodels/item_viewmodel.dart';

/// Vista de detalle en MVVM convencional.
class ItemDetailView extends StatefulWidget {
  final String itemId;
  final ItemViewModel itemViewModel;

  const ItemDetailView({
    super.key,
    required this.itemId,
    required this.itemViewModel,
  });

  @override
  State<ItemDetailView> createState() => _ItemDetailViewState();
}

class _ItemDetailViewState extends State<ItemDetailView> {
  @override
  void initState() {
    super.initState();
    widget.itemViewModel.loadDetail(widget.itemId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del Elemento')),
      body: ListenableBuilder(
        listenable: widget.itemViewModel,
        builder: (context, _) {
          if (widget.itemViewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final item = widget.itemViewModel.selectedItem;
          if (item == null) {
            return Center(
              child: Text(widget.itemViewModel.errorMessage ?? 'Sin datos'),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID: ${item.id}'),
                Text('Título: ${item.title}'),
                Text('Categoría: ${item.category}'),
                const SizedBox(height: 8),
                Text(item.description),
              ],
            ),
          );
        },
      ),
    );
  }
}
