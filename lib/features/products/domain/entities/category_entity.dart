import 'package:equatable/equatable.dart';

/// Entity pura da categoria seguindo princípios Clean Architecture
/// Representa as categorias de produtos no domínio da aplicação
class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String iconPath;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
  });

  /// Cria uma cópia da entidade com valores opcionalmente alterados
  CategoryEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? iconPath,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
    );
  }

  @override
  String toString() {
    return 'CategoryEntity(id: $id, name: $name, description: $description, iconPath: $iconPath)';
  }

  @override
  List<Object?> get props => [id, name, description, iconPath];
}
