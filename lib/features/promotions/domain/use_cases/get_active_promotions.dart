import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/domain/use_cases/base_use_case.dart';
import '../entities/promotion.dart';
import '../repositories/promotions_repository.dart';

class GetActivePromotions extends UseCase<List<Promotion>, NoParams> {
  final PromotionsRepository repository;

  GetActivePromotions(this.repository);

  @override
  Future<Either<Failure, List<Promotion>>> call(NoParams params) {
    return repository.getActivePromotions();
  }
}
