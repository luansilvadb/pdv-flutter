import 'package:equatable/equatable.dart';

/// Entity pura do produto seguindo princípios Clean Architecture
/// Sem dependências externas, representa a regra de negócio central
class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String categoryId;
  final bool isAvailable;
  final int availableQuantity;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categoryId,
    required this.isAvailable,
    required this.availableQuantity,
  });

  /// Cria uma cópia da entidade com valores opcionalmente alterados
  ProductEntity copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? categoryId,
    bool? isAvailable,
    int? availableQuantity,
  }) {
    return ProductEntity(
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

  @override
  String toString() {
    return 'ProductEntity(id: $id, name: $name, description: $description, '
        'price: $price, imageUrl: $imageUrl, categoryId: $categoryId, '
        'isAvailable: $isAvailable, availableQuantity: $availableQuantity)';
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    imageUrl,
    categoryId,
    isAvailable,
    availableQuantity,
  ];
}
