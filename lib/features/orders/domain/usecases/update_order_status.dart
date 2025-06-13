import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/domain/use_cases/base_use_case.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

/// Use case para atualizar o status de um pedido
class UpdateOrderStatus extends UseCase<OrderEntity, UpdateOrderStatusParams> 
    with UseCaseLogging {
  final OrderRepository repository;

  UpdateOrderStatus(this.repository);

  @override
  Future<Either<Failure, OrderEntity>> call(UpdateOrderStatusParams params) async {
    try {
      final result = await repository.updateOrderStatus(
        params.orderId, 
        params.status,
      );
      
      result.fold(
        (failure) => logError('UpdateOrderStatus', failure),
        (order) => logSuccess('UpdateOrderStatus', 'Status atualizado: ${order.id}'),
      );
      
      return result;
    } catch (e) {
      final failure = UnknownFailure(message: e.toString());
      logError('UpdateOrderStatus', failure);
      return Left(failure);
    }
  }
}

/// Parâmetros para atualizar status do pedido
class UpdateOrderStatusParams extends Equatable {
  final String orderId;
  final String status;

  const UpdateOrderStatusParams({
    required this.orderId,
    required this.status,
  });

  @override
  List<Object> get props => [orderId, status];

  @override
  String toString() => 'UpdateOrderStatusParams(orderId: $orderId, status: $status)';
}
