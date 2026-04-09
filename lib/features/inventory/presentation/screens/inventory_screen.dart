import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/inventory_provider.dart';
import '../../domain/entities/inventory_item.dart';
import '../../../../core/constants/app_constants.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(inventoryProvider.notifier).loadInventory());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(inventoryProvider);

    return ScaffoldPage(
      header: PageHeader(
        title: const Text('Gestão de Estoque'),
        commandBar: Button(
          child: const Text('Atualizar'),
          onPressed: () => ref.read(inventoryProvider.notifier).loadInventory(),
        ),
      ),
      content: state.isLoading
        ? const Center(child: ProgressRing())
        : ListView.builder(
            itemCount: state.items.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final item = state.items[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Icon(
                    item.status == InventoryStatus.OUT_OF_STOCK
                      ? FluentIcons.error
                      : item.status == InventoryStatus.LOW_STOCK
                        ? FluentIcons.warning
                        : FluentIcons.check_mark,
                    color: item.status == InventoryStatus.OUT_OF_STOCK
                      ? AppColors.error
                      : item.status == InventoryStatus.LOW_STOCK
                        ? AppColors.warning
                        : AppColors.success,
                  ),
                  title: Text(item.productName),
                  subtitle: Text('Quantidade: ${item.currentQuantity} ${item.unit.toString().split('.').last}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(FluentIcons.add),
                        onPressed: () {
                          ref.read(inventoryProvider.notifier).updateStock(item.productId, item.currentQuantity + 1);
                        },
                      ),
                      IconButton(
                        icon: const Icon(FluentIcons.remove),
                        onPressed: () {
                          ref.read(inventoryProvider.notifier).updateStock(item.productId, (item.currentQuantity - 1).clamp(0, double.infinity));
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }
}
