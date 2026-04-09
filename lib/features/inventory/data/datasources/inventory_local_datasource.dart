import 'package:hive_flutter/hive_flutter.dart';
import '../models/inventory_item_model.dart';

abstract class InventoryLocalDataSource {
  Future<List<InventoryItemModel>> getInventory();
  Future<void> saveInventoryItem(InventoryItemModel item);
  Future<InventoryItemModel?> getInventoryItemByProductId(String productId);
}

class InventoryLocalDataSourceImpl implements InventoryLocalDataSource {
  final Box _box;
  static const String _boxName = 'inventory_box';

  InventoryLocalDataSourceImpl(this._box);

  static Future<InventoryLocalDataSourceImpl> init() async {
    final box = await Hive.openBox(_boxName);
    return InventoryLocalDataSourceImpl(box);
  }

  @override
  Future<List<InventoryItemModel>> getInventory() async {
    return _box.values
        .map((e) => InventoryItemModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<void> saveInventoryItem(InventoryItemModel item) async {
    await _box.put(item.productId, item.toJson());
  }

  @override
  Future<InventoryItemModel?> getInventoryItemByProductId(String productId) async {
    final data = _box.get(productId);
    if (data == null) return null;
    return InventoryItemModel.fromJson(Map<String, dynamic>.from(data));
  }
}
