import 'dart:convert';
import '../../../../core/storage/local_storage.dart';
import '../models/inventory_item_model.dart';
import '../../../../core/errors/exceptions.dart';

abstract class InventoryLocalDataSource {
  Future<List<InventoryItemModel>> getInventory();
  Future<void> saveInventoryItem(InventoryItemModel item);
}

class InventoryLocalDataSourceImpl implements InventoryLocalDataSource {
  final LocalStorage localStorage;
  static const String inventoryKey = 'cached_inventory';

  InventoryLocalDataSourceImpl({required this.localStorage});

  @override
  Future<List<InventoryItemModel>> getInventory() async {
    try {
      final inventoryString = await localStorage.retrieve<String>(inventoryKey);
      if (inventoryString == null || inventoryString.isEmpty) return [];

      final inventoryList = json.decode(inventoryString) as List<dynamic>;
      return inventoryList
          .map((itemJson) => InventoryItemModel.fromJson(itemJson as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException(message: 'Erro ao carregar inventário: $e');
    }
  }

  @override
  Future<void> saveInventoryItem(InventoryItemModel item) async {
    try {
      final inventory = await getInventory();
      inventory.removeWhere((i) => i.productId == item.productId);
      inventory.add(item);

      final inventoryJson = inventory.map((i) => i.toJson()).toList();
      await localStorage.store(inventoryKey, json.encode(inventoryJson));
    } catch (e) {
      throw CacheException(message: 'Erro ao salvar item de inventário: $e');
    }
  }
}
