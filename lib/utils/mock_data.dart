import '../models/product.dart';
import '../models/category.dart';

class MockData {
  static List<Product> get products => [
    // Burgers
    Product(
      id: '1',
      name: 'Double Burger',
      description: 'Delicious double beef burger with cheese',
      price: 12.99,
      imageUrl: 'assets/images/burgers/hamburguer1.png',
      category: ProductCategory.burger.key,
      availableQuantity: 11,
    ),
    Product(
      id: '2',
      name: 'Classic Burger',
      description: 'Traditional beef burger with lettuce and tomato',
      price: 9.99,
      imageUrl: 'assets/images/burgers/hamburguer2.png',
      category: ProductCategory.burger.key,
      availableQuantity: 15,
    ),
    Product(
      id: '3',
      name: 'Chicken Burger',
      description: 'Crispy chicken breast burger',
      price: 11.49,
      imageUrl: 'assets/images/burgers/hamburguer3.png',
      category: ProductCategory.burger.key,
      availableQuantity: 8,
    ),
    Product(
      id: '4',
      name: 'Veggie Burger',
      description: 'Plant-based burger with fresh vegetables',
      price: 10.99,
      imageUrl: 'assets/images/burgers/hamburguer4.png',
      category: ProductCategory.burger.key,
      availableQuantity: 12,
    ),
    Product(
      id: '5',
      name: 'BBQ Bacon Burger',
      description: 'Smoky BBQ burger with crispy bacon',
      price: 14.99,
      imageUrl: 'assets/images/burgers/hamburguer5.png',
      category: ProductCategory.burger.key,
      availableQuantity: 20,
    ),
    Product(
      id: '6',
      name: 'Mushroom Swiss Burger',
      description: 'Beef burger with sautéed mushrooms and Swiss cheese',
      price: 13.49,
      imageUrl: 'assets/images/burgers/hamburguer6.png',
      category: ProductCategory.burger.key,
      availableQuantity: 18,
    ),
    Product(
      id: '7',
      name: 'Spicy Jalapeño Burger',
      description: 'Hot and spicy burger with jalapeños',
      price: 15.99,
      imageUrl: 'assets/images/burgers/hamburguer7.png',
      category: ProductCategory.burger.key,
      availableQuantity: 14,
    ),
    Product(
      id: '8',
      name: 'Fish Burger',
      description: 'Crispy fish fillet burger with tartar sauce',
      price: 12.99,
      imageUrl: 'assets/images/burgers/hamburguer8.png',
      category: ProductCategory.burger.key,
      availableQuantity: 16,
    ),
  ];
}
