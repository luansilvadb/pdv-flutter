import '../../domain/entities/promotion.dart';
import '../../domain/repositories/promotion_repository.dart';
import '../datasources/promotion_local_datasource.dart';
import '../models/promotion_model.dart';

class PromotionRepositoryImpl implements PromotionRepository {
  final PromotionLocalDataSource _dataSource;

  PromotionRepositoryImpl(this._dataSource);

  @override
  Future<List<Promotion>> getActivePromotions() async {
    return await _dataSource.getPromotions();
  }

  @override
  Future<void> savePromotion(Promotion promotion) async {
    await _dataSource.savePromotion(PromotionModel.fromEntity(promotion));
  }

  @override
  Future<void> deletePromotion(String id) async {
    await _dataSource.deletePromotion(id);
  }
}
