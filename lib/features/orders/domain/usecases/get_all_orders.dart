import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/domain/use_cases/base_use_case.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

/// Use case para obter todos os pedidos
class GetAllOrders extends UseCase<List<OrderEntity>, NoParams> 
    with UseCaseLogging {
  final OrderRepository repository;

  GetAllOrders(this.repository);

  @override
  Future<Either<Failure, List<OrderEntity>>> call(NoParams params) async {
    logExecution('GetAllOrders', params);

    try {
      final result = await repository.getAllOrders();
      
      result.fold(
        (failure) => logError('GetAllOrders', failure),
        (orders) => logSuccess('GetAllOrders', '${orders.length} pedidos encontrados'),
      );
      
      return result;
    } catch (e) {
      final failure = UnknownFailure(message: e.toString());
      logError('GetAllOrders', failure);
      return Left(failure);
    }
  }
}
