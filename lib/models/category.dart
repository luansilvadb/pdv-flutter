enum ProductCategory {
  burger('Burger', 'burger'),
  noodles('Noodles', 'noodles'),
  drinks('Drinks', 'drinks'),
  desserts('Desserts', 'desserts');

  const ProductCategory(this.displayName, this.key);

  final String displayName;
  final String key;
}

// Extension com métodos úteis para o ProductCategory
extension ProductCategoryExtension on ProductCategory {
  String get localizedDisplayName {
    switch (this) {
      case ProductCategory.burger:
        return 'Burgers';
      case ProductCategory.noodles:
        return 'Massas';
      case ProductCategory.drinks:
        return 'Bebidas';
      case ProductCategory.desserts:
        return 'Sobremesas';
    }
  }

  String get description {
    switch (this) {
      case ProductCategory.burger:
        return 'Deliciosos hambúrgueres artesanais';
      case ProductCategory.noodles:
        return 'Massas frescas e saborosas';
      case ProductCategory.drinks:
        return 'Bebidas refrescantes e especiais';
      case ProductCategory.desserts:
        return 'Sobremesas irresistíveis';
    }
  }
}
