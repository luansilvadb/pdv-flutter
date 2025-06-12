import '../../../../shared/domain/entities/base_entity.dart';
import '../../../../shared/domain/value_objects/money.dart';
import '../../../../shared/domain/value_objects/quantity.dart';

/// Entity pura do produto seguindo princípios Clean Architecture
/// Sem dependências externas, representa a regra de negócio central
class ProductEntity extends Entity {
  @override
  final String id;
  final String name;
  final String description;
  final double price; // Mantendo double por compatibilidade
  final String imageUrl;
  final String categoryId;
  final bool isAvailable; // Mantendo por compatibilidade
  final int availableQuantity; // Mantendo int por compatibilidade
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categoryId,
    required this.isAvailable,
    required this.availableQuantity,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  /// Getters que retornam Value Objects para nova arquitetura
  Money get priceAsMoney => Money(price);
  Quantity get quantityAsQuantity => Quantity(availableQuantity);

  /// Verifica se o produto está com estoque baixo
  bool get isLowStock => availableQuantity <= 5 && availableQuantity > 0;

  /// Verifica se o produto está sem estoque
  bool get isOutOfStock => availableQuantity == 0;

  /// Preço formatado para exibição
  String get formattedPrice => priceAsMoney.formatted;

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
    DateTime? createdAt,
    DateTime? updatedAt,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// Atualiza a quantidade disponível
  ProductEntity updateQuantity(int newQuantity) {
    return copyWith(
      availableQuantity: newQuantity,
      isAvailable: newQuantity > 0,
      updatedAt: DateTime.now(),
    );
  }

  /// Decrementa a quantidade (para vendas)
  ProductEntity decrementQuantity(int amount) {
    final newQuantity = (availableQuantity - amount).clamp(
      0,
      availableQuantity,
    );
    return copyWith(
      availableQuantity: newQuantity,
      isAvailable: newQuantity > 0,
      updatedAt: DateTime.now(),
    );
  }

  /// Incrementa a quantidade (para reposição de estoque)
  ProductEntity incrementQuantity(int amount) {
    final newQuantity = availableQuantity + amount;
    return copyWith(
      availableQuantity: newQuantity,
      isAvailable: newQuantity > 0,
      updatedAt: DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'ProductEntity(id: $id, name: $name, description: $description, '
        'price: $price, imageUrl: $imageUrl, categoryId: $categoryId, '
        'isAvailable: $isAvailable, availableQuantity: $availableQuantity, '
        'createdAt: $createdAt, updatedAt: $updatedAt)';
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
    createdAt,
    updatedAt,
  ];
}
