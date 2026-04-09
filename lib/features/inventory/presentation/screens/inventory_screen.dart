import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/inventory_provider.dart';
import '../../domain/entities/inventory_item.dart';
import '../../../../core/constants/app_constants.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventoryAsync = ref.watch(inventoryProvider);

    return ScaffoldPage(
      header: PageHeader(
        title: const Text('Gestão de Estoque'),
        commandBar: CommandBar(
          mainAxisAlignment: MainAxisAlignment.end,
          primaryItems: [
            CommandBarButton(
              icon: const Icon(FluentIcons.refresh),
              label: const Text('Atualizar'),
              onPressed: () => ref.read(inventoryProvider.notifier).loadInventory(),
            ),
          ],
        ),
      ),
      content: inventoryAsync.when(
        data: (items) => ListView.builder(
          padding: const EdgeInsets.all(AppSizes.paddingMedium),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text('Produto ID: ${item.productId}'),
                subtitle: Text('Quantidade: ${item.currentQuantity} ${item.unit.name.toUpperCase()}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildStatusBadge(item.status),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(FluentIcons.edit),
                      onPressed: () => _showEditStockDialog(context, ref, item),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: ProgressRing()),
        error: (e, st) => Center(child: Text('Erro: $e')),
      ),
    );
  }

  Widget _buildStatusBadge(InventoryStatus status) {
    Color color;
    String label;
    switch (status) {
      case InventoryStatus.inStock:
        color = AppColors.success;
        label = 'EM ESTOQUE';
        break;
      case InventoryStatus.lowStock:
        color = AppColors.warning;
        label = 'BAIXO';
        break;
      case InventoryStatus.outOfStock:
        color = AppColors.error;
        label = 'SEM ESTOQUE';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showEditStockDialog(BuildContext context, WidgetRef ref, InventoryItem item) {
    final controller = TextEditingController(text: item.currentQuantity.toString());
    showDialog(
      context: context,
      builder: (context) => ContentDialog(
        title: const Text('Ajustar Estoque'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Produto: ${item.productId}'),
            const SizedBox(height: 16),
            InfoLabel(
              label: 'Nova Quantidade',
              child: TextBox(
                controller: controller,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        actions: [
          Button(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          FilledButton(
            child: const Text('Salvar'),
            onPressed: () {
              final newQty = double.tryParse(controller.text);
              if (newQty != null) {
                final diff = newQty - item.currentQuantity;
                if (diff > 0) {
                  ref.read(inventoryProvider.notifier).restock(item.productId, diff);
                } else if (diff < 0) {
                  ref.read(inventoryProvider.notifier).decrementStock(item.productId, diff.abs());
                }
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
