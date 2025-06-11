// Exemplo de como usar imagens locais no mock_data.dart
// Descomente e use este código quando tiver as imagens locais

import '../models/product.dart';
import '../models/category.dart';

class MockDataLocal {
  static List<Product> get products => [
    // Burgers
    Product(
      id: '1',
      name: 'Double Burger',
      description: 'Delicious double beef burger with cheese',
      price: 12.99,
      imageUrl: 'assets/images/burgers/double_burger.jpg', // Imagem local
      category: ProductCategory.burger.key,
      availableQuantity: 11,
    ),
    Product(
      id: '2',
      name: 'Classic Burger',
      description: 'Traditional beef burger with lettuce and tomato',
      price: 9.99,
      imageUrl: 'assets/images/burgers/classic_burger.jpg', // Imagem local
      category: ProductCategory.burger.key,
      availableQuantity: 15,
    ),
    // Adicione mais produtos aqui...
  ];
}
