import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/inventory_item.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasources/inventory_local_datasource.dart';
import '../models/inventory_item_model.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryLocalDataSource localDataSource;

  InventoryRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<InventoryItem>>> getInventory() async {
    try {
      final inventory = await localDataSource.getInventory();
      return Right(inventory);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, InventoryItem>> updateQuantity(String productId, double quantity) async {
    try {
      final inventory = await localDataSource.getInventory();
      final itemIndex = inventory.indexWhere((i) => i.productId == productId);

      if (itemIndex == -1) {
        return Left(CacheFailure(message: 'Item não encontrado no inventário'));
      }

      final updatedItem = InventoryItemModel(
        id: inventory[itemIndex].id,
        productId: inventory[itemIndex].productId,
        productName: inventory[itemIndex].productName,
        currentQuantity: quantity,
        minQuantity: inventory[itemIndex].minQuantity,
        unit: inventory[itemIndex].unit,
        lastRestock: DateTime.now(),
        createdAt: inventory[itemIndex].createdAt,
        updatedAt: DateTime.now(),
      );

      await localDataSource.saveInventoryItem(updatedItem);
      return Right(updatedItem);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> decrementStock(String productId, double quantity) async {
    try {
      final inventory = await localDataSource.getInventory();
      final itemIndex = inventory.indexWhere((i) => i.productId == productId);

      if (itemIndex != -1) {
        final currentItem = inventory[itemIndex];
        final newQuantity = (currentItem.currentQuantity - quantity).clamp(0.0, double.infinity);

        final updatedItem = InventoryItemModel(
          id: currentItem.id,
          productId: currentItem.productId,
          productName: currentItem.productName,
          currentQuantity: newQuantity,
          minQuantity: currentItem.minQuantity,
          unit: currentItem.unit,
          lastRestock: currentItem.lastRestock,
          createdAt: currentItem.createdAt,
          updatedAt: DateTime.now(),
        );

        await localDataSource.saveInventoryItem(updatedItem);
      }
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}
