import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/promotion.dart';

abstract class PromotionsRepository {
  Future<Either<Failure, List<Promotion>>> getActivePromotions();
  Future<Either<Failure, void>> savePromotion(Promotion promotion);
}
