import '../entities/inventory_item.dart';

abstract class InventoryRepository {
  Future<List<InventoryItem>> getInventory();
  Future<InventoryItem?> getInventoryItemByProductId(String productId);
  Future<void> updateInventoryItem(InventoryItem item);
  Future<void> saveInventoryItem(InventoryItem item);
}
