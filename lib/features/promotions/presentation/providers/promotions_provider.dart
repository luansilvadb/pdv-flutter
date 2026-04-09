import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/promotion.dart';
import '../../domain/repositories/promotion_repository.dart';
import '../../../../core/services/dependency_injection.dart';

class PromotionsNotifier extends StateNotifier<AsyncValue<List<Promotion>>> {
  final PromotionRepository _repository;

  PromotionsNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadPromotions();
  }

  Future<void> loadPromotions() async {
    state = const AsyncValue.loading();
    try {
      final promotions = await _repository.getActivePromotions();
      state = AsyncValue.data(promotions);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addPromotion(Promotion promotion) async {
    await _repository.savePromotion(promotion);
    await loadPromotions();
  }

  Future<void> removePromotion(String id) async {
    await _repository.deletePromotion(id);
    await loadPromotions();
  }
}

final promotionsProvider = StateNotifierProvider<PromotionsNotifier, AsyncValue<List<Promotion>>>((ref) {
  return PromotionsNotifier(sl<PromotionRepository>());
});
