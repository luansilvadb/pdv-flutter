import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/promotion.dart';
import '../../domain/repositories/promotions_repository.dart';
import '../datasources/promotions_local_datasource.dart';
import '../models/promotion_model.dart';

class PromotionsRepositoryImpl implements PromotionsRepository {
  final PromotionsLocalDataSource localDataSource;

  PromotionsRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Promotion>>> getActivePromotions() async {
    try {
      final promos = await localDataSource.getPromotions();
      return Right(promos.where((p) => p.isActive()).toList());
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> savePromotion(Promotion promotion) async {
    try {
      final model = PromotionModel(
        id: promotion.id,
        name: promotion.name,
        type: promotion.type,
        value: promotion.value,
        daysOfWeek: promotion.daysOfWeek,
        startTime: promotion.startTime,
        endTime: promotion.endTime,
        minSubtotal: promotion.minSubtotal,
        applicableProductIds: promotion.applicableProductIds,
        buyQuantity: promotion.buyQuantity,
        getQuantity: promotion.getQuantity,
        comboItems: promotion.comboItems,
        createdAt: promotion.createdAt,
        updatedAt: promotion.updatedAt,
      );
      await localDataSource.savePromotion(model);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}
