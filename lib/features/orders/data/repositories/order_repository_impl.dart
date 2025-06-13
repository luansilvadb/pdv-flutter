import 'package:dartz/dartz.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_local_data_source.dart';
import '../models/order_model.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';

/// Implementação concreta do repositório de pedidos
class OrderRepositoryImpl implements OrderRepository {
  final OrderLocalDataSource localDataSource;

  OrderRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, OrderEntity>> saveOrder(OrderEntity order) async {
    try {
      final orderModel = OrderModel.fromEntity(order);
      await localDataSource.saveOrder(orderModel);
      return Right(order);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Erro inesperado ao salvar pedido: $e'));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getAllOrders() async {
    try {
      final orderModels = await localDataSource.getAllOrders();
      final orders = orderModels.map((model) => model as OrderEntity).toList();
      return Right(orders);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Erro inesperado ao carregar pedidos: $e'));
    }
  }

  @override
  Future<Either<Failure, OrderEntity?>> getOrderById(String orderId) async {
    try {
      final orderModel = await localDataSource.getOrderById(orderId);
      return Right(orderModel);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Erro inesperado ao buscar pedido: $e'));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrdersByStatus(String status) async {
    try {
      final allOrders = await localDataSource.getAllOrders();
      final filteredOrders = allOrders
          .where((order) => order.status.name == status)
          .map((model) => model as OrderEntity)
          .toList();
      return Right(filteredOrders);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Erro inesperado ao filtrar pedidos: $e'));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrdersByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final allOrders = await localDataSource.getAllOrders();
      final filteredOrders = allOrders
          .where((order) =>
              order.createdAt.isAfter(startDate.subtract(const Duration(days: 1))) &&
              order.createdAt.isBefore(endDate.add(const Duration(days: 1))))
          .map((model) => model as OrderEntity)
          .toList();
      return Right(filteredOrders);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Erro inesperado ao filtrar pedidos por data: $e'));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> updateOrderStatus(
    String orderId,
    String status,
  ) async {
    try {
      final orderModel = await localDataSource.getOrderById(orderId);
      if (orderModel == null) {
        return Left(NotFoundFailure(message: 'Pedido não encontrado'));
      }

      final statusEnum = OrderStatus.values.firstWhere(
        (e) => e.name == status,
        orElse: () => OrderStatus.pending,
      );

      final updatedOrder = orderModel.copyWith(
        status: statusEnum,
        updatedAt: DateTime.now(),
      );

      await localDataSource.saveOrder(OrderModel.fromEntity(updatedOrder));
      return Right(updatedOrder);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Erro inesperado ao atualizar status: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteOrder(String orderId) async {
    try {
      await localDataSource.deleteOrder(orderId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Erro inesperado ao remover pedido: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getOrdersStatistics() async {
    try {
      final statistics = await localDataSource.getOrdersStatistics();
      return Right(statistics);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Erro inesperado ao calcular estatísticas: $e'));
    }
  }
}
