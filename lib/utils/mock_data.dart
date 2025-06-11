import '../features/products/domain/entities/product_entity.dart';
import '../features/products/domain/entities/category_entity.dart';

class MockData {
  static List<ProductEntity> get products => [
    ProductEntity(
      id: '1',
      name: 'Hambúrguer Clássico',
      description: 'Hambúrguer artesanal com queijo, alface e tomate',
      price: 25.90,
      categoryId: 'hamburgers',
      imageUrl: 'assets/images/burgers/hamburguer1.png',
      isAvailable: true,
      availableQuantity: 10,
    ),
    ProductEntity(
      id: '2',
      name: 'Pizza Margherita',
      description:
          'Pizza tradicional com molho de tomate, mussarela e manjericão',
      price: 32.50,
      categoryId: 'pizzas',
      imageUrl: 'assets/images/burgers/hamburguer2.png',
      isAvailable: true,
      availableQuantity: 8,
    ),
    ProductEntity(
      id: '3',
      name: 'Coca-Cola 350ml',
      description: 'Refrigerante gelado',
      price: 5.00,
      categoryId: 'drinks',
      imageUrl: 'assets/images/burgers/hamburguer3.png',
      isAvailable: true,
      availableQuantity: 20,
    ),
    ProductEntity(
      id: '4',
      name: 'Hambúrguer Bacon',
      description: 'Hambúrguer com bacon crocante e queijo cheddar',
      price: 28.90,
      categoryId: 'hamburgers',
      imageUrl: 'assets/images/burgers/hamburguer4.png',
      isAvailable: true,
      availableQuantity: 7,
    ),
    ProductEntity(
      id: '5',
      name: 'Pizza Calabresa',
      description: 'Pizza com calabresa, cebola e azeitonas',
      price: 35.00,
      categoryId: 'pizzas',
      imageUrl: 'assets/images/burgers/hamburguer5.png',
      isAvailable: true,
      availableQuantity: 6,
    ),
    ProductEntity(
      id: '6',
      name: 'Suco de Laranja',
      description: 'Suco natural de laranja 300ml',
      price: 8.50,
      categoryId: 'drinks',
      imageUrl: 'assets/images/burgers/hamburguer6.png',
      isAvailable: true,
      availableQuantity: 15,
    ),
    ProductEntity(
      id: '7',
      name: 'Hambúrguer Vegetariano',
      description: 'Hambúrguer de grão-de-bico com vegetais',
      price: 26.90,
      categoryId: 'hamburgers',
      imageUrl: 'assets/images/burgers/hamburguer7.png',
      isAvailable: true,
      availableQuantity: 5,
    ),
    ProductEntity(
      id: '8',
      name: 'Pizza Portuguesa',
      description: 'Pizza com presunto, ovos, ervilha e cebola',
      price: 38.50,
      categoryId: 'pizzas',
      imageUrl: 'assets/images/burgers/hamburguer8.png',
      isAvailable: true,
      availableQuantity: 4,
    ),
  ];

  static List<CategoryEntity> get categories => [
    CategoryEntity(
      id: 'hamburgers',
      name: 'Hambúrguers',
      description: 'Deliciosos hambúrguers artesanais',
      iconPath: 'assets/icons/hamburger.png',
    ),
    CategoryEntity(
      id: 'pizzas',
      name: 'Pizzas',
      description: 'Pizzas tradicionais e especiais',
      iconPath: 'assets/icons/pizza.png',
    ),
    CategoryEntity(
      id: 'drinks',
      name: 'Bebidas',
      description: 'Refrigerantes, sucos e bebidas geladas',
      iconPath: 'assets/icons/drink.png',
    ),
  ];
}
