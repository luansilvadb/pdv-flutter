import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/domain/use_cases/base_use_case.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

/// Use case para salvar um novo pedido
class CreateOrder extends UseCase<OrderEntity, OrderEntity> 
    with UseCaseLogging {
  final OrderRepository repository;

  CreateOrder(this.repository);

  @override
  Future<Either<Failure, OrderEntity>> call(OrderEntity order) async {
    logExecution('CreateOrder', order);

    try {
      final result = await repository.saveOrder(order);
      
      result.fold(
        (failure) => logError('CreateOrder', failure),
        (order) => logSuccess('CreateOrder', 'Pedido criado: ${order.id}'),
      );
      
      return result;
    } catch (e) {
      final failure = UnknownFailure(message: e.toString());
      logError('CreateOrder', failure);
      return Left(failure);
    }
  }
}
