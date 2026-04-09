import '../entities/promotion.dart';

abstract class PromotionRepository {
  Future<List<Promotion>> getActivePromotions();
  Future<void> savePromotion(Promotion promotion);
  Future<void> deletePromotion(String id);
}
