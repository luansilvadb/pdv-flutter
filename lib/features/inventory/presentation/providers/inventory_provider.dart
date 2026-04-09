import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/dependency_injection.dart';
import '../../../../shared/domain/use_cases/base_use_case.dart';
import '../../domain/entities/inventory_item.dart';
import '../../domain/use_cases/get_inventory_items.dart';
import '../../domain/use_cases/update_inventory_stock.dart';
import 'inventory_state.dart';

class InventoryNotifier extends StateNotifier<InventoryState> {
  final GetInventoryItems _getInventoryItems;
  final UpdateInventoryStock _updateInventoryStock;

  InventoryNotifier({
    required GetInventoryItems getInventoryItems,
    required UpdateInventoryStock updateInventoryStock,
  })  : _getInventoryItems = getInventoryItems,
        _updateInventoryStock = updateInventoryStock,
        super(const InventoryState()) {
    loadInventory();
  }

  Future<void> loadInventory() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _getInventoryItems(NoParams());
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.message),
      (items) => state = state.copyWith(isLoading: false, items: items),
    );
  }

  Future<void> updateStock(String productId, double quantity) async {
    final result = await _updateInventoryStock(UpdateInventoryParams(
      productId: productId,
      quantity: quantity,
    ));
    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (updatedItem) {
        final newItems = state.items.map((item) {
          return item.productId == productId ? updatedItem : item;
        }).toList();
        state = state.copyWith(items: newItems);
      },
    );
  }
}

final inventoryProvider = StateNotifierProvider<InventoryNotifier, InventoryState>((ref) {
  return InventoryNotifier(
    getInventoryItems: sl<GetInventoryItems>(),
    updateInventoryStock: sl<UpdateInventoryStock>(),
  );
});

final lowStockItemsProvider = Provider((ref) {
  final inventory = ref.watch(inventoryProvider);
  return inventory.items.where((item) => item.status == InventoryStatus.LOW_STOCK).toList();
});
