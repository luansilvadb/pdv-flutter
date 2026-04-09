import '../../domain/entities/inventory_item.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasources/inventory_local_datasource.dart';
import '../models/inventory_item_model.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryLocalDataSource _dataSource;

  InventoryRepositoryImpl(this._dataSource);

  @override
  Future<List<InventoryItem>> getInventory() async {
    return await _dataSource.getInventory();
  }

  @override
  Future<InventoryItem?> getInventoryItemByProductId(String productId) async {
    return await _dataSource.getInventoryItemByProductId(productId);
  }

  @override
  Future<void> updateInventoryItem(InventoryItem item) async {
    await _dataSource.saveInventoryItem(InventoryItemModel.fromEntity(item));
  }

  @override
  Future<void> saveInventoryItem(InventoryItem item) async {
    await _dataSource.saveInventoryItem(InventoryItemModel.fromEntity(item));
  }
}
