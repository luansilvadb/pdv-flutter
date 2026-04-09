import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/inventory_item.dart';

abstract class InventoryRepository {
  Future<Either<Failure, List<InventoryItem>>> getInventory();
  Future<Either<Failure, InventoryItem>> updateQuantity(String productId, double quantity);
  Future<Either<Failure, void>> decrementStock(String productId, double quantity);
}
