import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/inventory_item.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../../../../core/services/dependency_injection.dart';

class InventoryNotifier extends StateNotifier<AsyncValue<List<InventoryItem>>> {
  final InventoryRepository _repository;

  InventoryNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadInventory();
  }

  Future<void> loadInventory() async {
    state = const AsyncValue.loading();
    try {
      final items = await _repository.getInventory();
      state = AsyncValue.data(items);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> decrementStock(String productId, double quantity) async {
    final item = await _repository.getInventoryItemByProductId(productId);
    if (item != null) {
      final updatedItem = item.copyWith(
        currentQuantity: item.currentQuantity - quantity,
      );
      await _repository.updateInventoryItem(updatedItem);
      await loadInventory();
    }
  }

  Future<void> restock(String productId, double quantity) async {
    final item = await _repository.getInventoryItemByProductId(productId);
    if (item != null) {
      final updatedItem = item.copyWith(
        currentQuantity: item.currentQuantity + quantity,
        lastRestock: DateTime.now(),
      );
      await _repository.updateInventoryItem(updatedItem);
      await loadInventory();
    }
  }
}

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  return sl<InventoryRepository>();
});

final inventoryProvider = StateNotifierProvider<InventoryNotifier, AsyncValue<List<InventoryItem>>>((ref) {
  return InventoryNotifier(ref.watch(inventoryRepositoryProvider));
});
