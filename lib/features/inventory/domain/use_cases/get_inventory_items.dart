import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/domain/use_cases/base_use_case.dart';
import '../entities/inventory_item.dart';
import '../repositories/inventory_repository.dart';

class GetInventoryItems extends UseCase<List<InventoryItem>, NoParams> {
  final InventoryRepository repository;

  GetInventoryItems(this.repository);

  @override
  Future<Either<Failure, List<InventoryItem>>> call(NoParams params) {
    return repository.getInventory();
  }
}
