import '../../../../core/utils/typedef.dart';
import '../../domain/entities/product_entity.dart';

/// Modelo de dados que extends ProductEntity
/// Responsável pela serialização JSON e conversão para Entity
class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.imageUrl,
    required super.categoryId,
    required super.isAvailable,
    required super.availableQuantity,
  });

  /// Cria ProductModel a partir de JSON
  factory ProductModel.fromJson(Json json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      categoryId: json['categoryId'] as String,
      isAvailable: json['isAvailable'] as bool? ?? true,
      availableQuantity: json['availableQuantity'] as int,
    );
  }

  /// Converte ProductModel para JSON
  Json toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'categoryId': categoryId,
      'isAvailable': isAvailable,
      'availableQuantity': availableQuantity,
    };
  }

  /// Converte ProductModel para ProductEntity (domain)
  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      name: name,
      description: description,
      price: price,
      imageUrl: imageUrl,
      categoryId: categoryId,
      isAvailable: isAvailable,
      availableQuantity: availableQuantity,
    );
  }

  /// Cria ProductModel a partir de ProductEntity
  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      imageUrl: entity.imageUrl,
      categoryId: entity.categoryId,
      isAvailable: entity.isAvailable,
      availableQuantity: entity.availableQuantity,
    );
  }

  /// Cria ProductModel a partir do modelo antigo (para migração)
  factory ProductModel.fromLegacyProduct(dynamic legacyProduct) {
    return ProductModel(
      id: legacyProduct.id as String,
      name: legacyProduct.name as String,
      description: legacyProduct.description as String,
      price: (legacyProduct.price as num).toDouble(),
      imageUrl: legacyProduct.imageUrl as String,
      categoryId: legacyProduct.category as String,
      isAvailable: legacyProduct.availableQuantity > 0,
      availableQuantity: legacyProduct.availableQuantity as int,
    );
  }

  @override
  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? categoryId,
    bool? isAvailable,
    int? availableQuantity,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      categoryId: categoryId ?? this.categoryId,
      isAvailable: isAvailable ?? this.isAvailable,
      availableQuantity: availableQuantity ?? this.availableQuantity,
    );
  }
}
