import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/domain/use_cases/base_use_case.dart';
import '../entities/inventory_item.dart';
import '../repositories/inventory_repository.dart';

class UpdateInventoryStock extends UseCase<InventoryItem, UpdateInventoryParams> {
  final InventoryRepository repository;

  UpdateInventoryStock(this.repository);

  @override
  Future<Either<Failure, InventoryItem>> call(UpdateInventoryParams params) {
    return repository.updateQuantity(params.productId, params.quantity);
  }
}

class UpdateInventoryParams {
  final String productId;
  final double quantity;

  UpdateInventoryParams({required this.productId, required this.quantity});
}
