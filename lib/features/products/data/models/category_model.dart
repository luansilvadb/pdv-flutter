import '../../../../core/utils/typedef.dart';
import '../../domain/entities/category_entity.dart';

/// Modelo de dados para CategoryEntity
/// Responsável pela serialização JSON e conversão para Entity
class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.description,
    required super.iconPath,
  });

  /// Cria CategoryModel a partir de JSON
  factory CategoryModel.fromJson(Json json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      iconPath: json['iconPath'] as String,
    );
  }

  /// Converte CategoryModel para JSON
  Json toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconPath': iconPath,
    };
  }

  /// Converte CategoryModel para CategoryEntity (domain)
  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      description: description,
      iconPath: iconPath,
    );
  }

  /// Cria CategoryModel a partir de CategoryEntity
  factory CategoryModel.fromEntity(CategoryEntity entity) {
    return CategoryModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      iconPath: entity.iconPath,
    );
  }

  /// Cria CategoryModel a partir do enum ProductCategory (para migração)
  factory CategoryModel.fromProductCategory(dynamic productCategory) {
    // Para compatibilidade com o enum ProductCategory existente
    return CategoryModel(
      id: productCategory.key as String,
      name: productCategory.localizedDisplayName as String,
      description: productCategory.description as String,
      iconPath: 'assets/icons/${productCategory.key}.png', // Caminho padrão
    );
  }

  @override
  CategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    String? iconPath,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
    );
  }
}
