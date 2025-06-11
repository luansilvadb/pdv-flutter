// Exemplo de como usar imagens locais no mock_data.dart
// Descomente e use este código quando tiver as imagens locais

import '../features/products/domain/entities/product_entity.dart';

class MockDataLocal {
  static List<ProductEntity> get products => [
    // Burgers
    ProductEntity(
      id: '1',
      name: 'Double Burger',
      description: 'Delicious double beef burger with cheese',
      price: 12.99,
      imageUrl: 'assets/images/burgers/double_burger.jpg', // Imagem local
      categoryId: 'burgers',
      availableQuantity: 11,
      isAvailable: true,
    ),
    ProductEntity(
      id: '2',
      name: 'Classic Burger',
      description: 'Traditional beef burger with lettuce and tomato',
      price: 9.99,
      imageUrl: 'assets/images/burgers/classic_burger.jpg', // Imagem local
      categoryId: 'burgers',
      availableQuantity: 15,
      isAvailable: true,
    ),
    ProductEntity(
      id: '3',
      name: 'Veggie Burger',
      description: 'Healthy vegetarian burger with fresh vegetables',
      price: 10.99,
      imageUrl: 'assets/images/burgers/veggie_burger.jpg', // Imagem local
      categoryId: 'burgers',
      availableQuantity: 8,
      isAvailable: true,
    ),
    // Adicione mais produtos aqui...
  ];
}
