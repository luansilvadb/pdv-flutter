import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/dependency_injection.dart';
import '../../../../shared/domain/use_cases/base_use_case.dart';
import '../../domain/entities/promotion.dart';
import '../../domain/use_cases/get_active_promotions.dart';

class PromotionsNotifier extends StateNotifier<List<Promotion>> {
  final GetActivePromotions _getActivePromotions;

  PromotionsNotifier({required GetActivePromotions getActivePromotions})
      : _getActivePromotions = getActivePromotions,
        super([]) {
    loadActivePromotions();
  }

  Future<void> loadActivePromotions() async {
    final result = await _getActivePromotions(NoParams());
    result.fold(
      (failure) => null, // Silently fail for now
      (promos) => state = promos,
    );
  }
}

final promotionsProvider = StateNotifierProvider<PromotionsNotifier, List<Promotion>>((ref) {
  return PromotionsNotifier(getActivePromotions: sl<GetActivePromotions>());
});
