import 'package:hive_flutter/hive_flutter.dart';
import '../models/promotion_model.dart';

abstract class PromotionLocalDataSource {
  Future<List<PromotionModel>> getPromotions();
  Future<void> savePromotion(PromotionModel promotion);
  Future<void> deletePromotion(String id);
}

class PromotionLocalDataSourceImpl implements PromotionLocalDataSource {
  final Box _box;
  static const String _boxName = 'promotions_box';

  PromotionLocalDataSourceImpl(this._box);

  static Future<PromotionLocalDataSourceImpl> init() async {
    final box = await Hive.openBox(_boxName);
    return PromotionLocalDataSourceImpl(box);
  }

  @override
  Future<List<PromotionModel>> getPromotions() async {
    return _box.values
        .map((e) => PromotionModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<void> savePromotion(PromotionModel promotion) async {
    await _box.put(promotion.id, promotion.toJson());
  }

  @override
  Future<void> deletePromotion(String id) async {
    await _box.delete(id);
  }
}
