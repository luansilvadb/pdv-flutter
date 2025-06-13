import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/domain/use_cases/base_use_case.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

/// Use case para obter pedidos por período
class GetOrdersByDateRange extends UseCase<List<OrderEntity>, GetOrdersByDateRangeParams> 
    with UseCaseLogging {
  final OrderRepository repository;

  GetOrdersByDateRange(this.repository);

  @override
  Future<Either<Failure, List<OrderEntity>>> call(GetOrdersByDateRangeParams params) async {
    logExecution('GetOrdersByDateRange', params);

    try {
      final result = await repository.getOrdersByDateRange(
        params.startDate, 
        params.endDate,
      );
      
      result.fold(
        (failure) => logError('GetOrdersByDateRange', failure),
        (orders) => logSuccess('GetOrdersByDateRange', '${orders.length} pedidos encontrados'),
      );
      
      return result;
    } catch (e) {
      final failure = UnknownFailure(message: e.toString());
      logError('GetOrdersByDateRange', failure);
      return Left(failure);
    }
  }
}

/// Parâmetros para buscar pedidos por período
class GetOrdersByDateRangeParams extends Equatable {
  final DateTime startDate;
  final DateTime endDate;

  const GetOrdersByDateRangeParams({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [startDate, endDate];

  @override
  String toString() => 'GetOrdersByDateRangeParams(startDate: $startDate, endDate: $endDate)';
}
