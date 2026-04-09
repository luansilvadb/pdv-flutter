import 'dart:convert';
import '../../../../core/storage/local_storage.dart';
import '../models/promotion_model.dart';
import '../../../../core/errors/exceptions.dart';

abstract class PromotionsLocalDataSource {
  Future<List<PromotionModel>> getPromotions();
  Future<void> savePromotion(PromotionModel promotion);
}

class PromotionsLocalDataSourceImpl implements PromotionsLocalDataSource {
  final LocalStorage localStorage;
  static const String promotionsKey = 'cached_promotions';

  PromotionsLocalDataSourceImpl({required this.localStorage});

  @override
  Future<List<PromotionModel>> getPromotions() async {
    try {
      final promosString = await localStorage.retrieve<String>(promotionsKey);
      if (promosString == null || promosString.isEmpty) return [];

      final promosList = json.decode(promosString) as List<dynamic>;
      return promosList
          .map((json) => PromotionModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException(message: 'Erro ao carregar promoções: $e');
    }
  }

  @override
  Future<void> savePromotion(PromotionModel promotion) async {
    try {
      final promos = await getPromotions();
      promos.removeWhere((p) => p.id == promotion.id);
      promos.add(promotion);

      final promosJson = promos.map((p) => p.toJson()).toList();
      await localStorage.store(promotionsKey, json.encode(promosJson));
    } catch (e) {
      throw CacheException(message: 'Erro ao salvar promoção: $e');
    }
  }
}
