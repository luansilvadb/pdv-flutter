import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';

import 'package:pdv_restaurant/features/cart/domain/entities/cart_entity.dart';
import 'package:pdv_restaurant/features/cart/domain/entities/cart_item_entity.dart';
import 'package:pdv_restaurant/features/cart/domain/repositories/cart_repository.dart';
import 'package:pdv_restaurant/features/cart/domain/usecases/add_to_cart.dart';
import 'package:pdv_restaurant/features/cart/domain/usecases/get_cart.dart';
import 'package:pdv_restaurant/features/cart/domain/usecases/remove_from_cart.dart';
import 'package:pdv_restaurant/features/cart/domain/usecases/update_cart_item_quantity.dart';
import 'package:pdv_restaurant/features/cart/domain/usecases/clear_cart.dart';

import 'package:pdv_restaurant/features/products/domain/repositories/product_repository.dart';
import 'package:pdv_restaurant/core/errors/failures.dart';

import 'cart_integration_test.mocks.dart';

// Gera os mocks
@GenerateMocks([CartRepository, ProductRepository])
void main() {
  late MockCartRepository mockCartRepository;
  late MockProductRepository mockProductRepository;
  late AddToCart addToCart;
  late GetCart getCart;
  late RemoveFromCart removeFromCart;
  late UpdateCartItemQuantity updateQuantity;
  late ClearCart clearCart;

  // Service locator para testes
  final sl = GetIt.instance;

  setUpAll(() {
    // Garante que o service locator está limpo
    if (sl.isRegistered<CartRepository>()) {
      sl.unregister<CartRepository>();
    }
    if (sl.isRegistered<ProductRepository>()) {
      sl.unregister<ProductRepository>();
    }
  });

  setUp(() {
    // Cria mocks
    mockCartRepository = MockCartRepository();
    mockProductRepository = MockProductRepository();

    // Registra mocks no service locator
    sl.registerLazySingleton<CartRepository>(() => mockCartRepository);
    sl.registerLazySingleton<ProductRepository>(() => mockProductRepository);

    // Inicializa use cases
    addToCart = AddToCart(mockCartRepository);
    getCart = GetCart(mockCartRepository);
    removeFromCart = RemoveFromCart(mockCartRepository);
    updateQuantity = UpdateCartItemQuantity(mockCartRepository);
    clearCart = ClearCart(mockCartRepository);
  });

  tearDown(() {
    // Limpa registros após cada teste
    if (sl.isRegistered<CartRepository>()) {
      sl.unregister<CartRepository>();
    }
    if (sl.isRegistered<ProductRepository>()) {
      sl.unregister<ProductRepository>();
    }
  });

  group('Cart Integration Tests', () {
    test('should start with empty cart', () async {
      // Arrange
      final emptyCart = CartEntity(
        id: 'test_cart',
        items: const [],
        createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
      );

      when(
        mockCartRepository.getCart(),
      ).thenAnswer((_) async => Right(emptyCart));

      // Act
      final result = await getCart();

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (cart) {
        expect(cart.isEmpty, true);
        expect(cart.itemCount, 0);
        expect(cart.totalAmount, 0.0);
      });

      verify(mockCartRepository.getCart()).called(1);
    });

    test('should add product to cart successfully', () async {
      // Arrange
      const productId = 'test_product_1';
      const quantity = 2;
      const price = 10.0;

      const cartItem = CartItemEntity(
        id: 'item_1',
        productId: productId,
        productName: 'Test Product',
        productPrice: price,
        productImageUrl: 'test_image.png',
        quantity: quantity,
      );

      final updatedCart = CartEntity(
        id: 'test_cart',
        items: const [cartItem],
        createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
      );

      when(
        mockCartRepository.addItem(productId: productId, quantity: quantity),
      ).thenAnswer((_) async => Right(updatedCart));

      // Act
      final result = await addToCart(
        AddToCartParams(productId: productId, quantity: quantity),
      );

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure: ${failure.message}'),
        (cart) {
          expect(cart.items.length, 1);
          expect(cart.itemCount, quantity);
          expect(cart.containsProduct(productId), true);

          final item = cart.findItemByProductId(productId);
          expect(item, isNotNull);
          expect(item!.quantity, quantity);
          expect(item.productId, productId);
        },
      );

      verify(
        mockCartRepository.addItem(productId: productId, quantity: quantity),
      ).called(1);
    });

    test('should increment quantity when adding existing product', () async {
      // Arrange
      const productId = 'test_product_2';
      const additionalQuantity = 2;
      const finalQuantity = 3;
      const price = 15.0;

      const cartItem = CartItemEntity(
        id: 'item_2',
        productId: productId,
        productName: 'Test Product 2',
        productPrice: price,
        productImageUrl: 'test_image.png',
        quantity: finalQuantity,
      );

      final updatedCart = CartEntity(
        id: 'test_cart',
        items: const [cartItem],
        createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
      );

      when(
        mockCartRepository.addItem(
          productId: productId,
          quantity: additionalQuantity,
        ),
      ).thenAnswer((_) async => Right(updatedCart));

      // Act
      final result = await addToCart(
        AddToCartParams(productId: productId, quantity: additionalQuantity),
      );

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (cart) {
        expect(cart.items.length, 1);
        expect(cart.itemCount, finalQuantity);

        final item = cart.findItemByProductId(productId);
        expect(item!.quantity, finalQuantity);
      });

      verify(
        mockCartRepository.addItem(
          productId: productId,
          quantity: additionalQuantity,
        ),
      ).called(1);
    });

    test('should update product quantity successfully', () async {
      // Arrange
      const productId = 'test_product_3';
      const newQuantity = 5;
      const price = 20.0;

      const cartItem = CartItemEntity(
        id: 'item_3',
        productId: productId,
        productName: 'Test Product 3',
        productPrice: price,
        productImageUrl: 'test_image.png',
        quantity: newQuantity,
      );

      final updatedCart = CartEntity(
        id: 'test_cart',
        items: const [cartItem],
        createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
      );

      when(
        mockCartRepository.updateQuantity(
          productId: productId,
          quantity: newQuantity,
        ),
      ).thenAnswer((_) async => Right(updatedCart));

      // Act
      final result = await updateQuantity(
        UpdateQuantityParams(productId: productId, newQuantity: newQuantity),
      );

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (cart) {
        final item = cart.findItemByProductId(productId);
        expect(item!.quantity, newQuantity);
        expect(cart.itemCount, newQuantity);
      });

      verify(
        mockCartRepository.updateQuantity(
          productId: productId,
          quantity: newQuantity,
        ),
      ).called(1);
    });

    test('should remove product when quantity is set to 0', () async {
      // Arrange
      const productId = 'test_product_4';
      const newQuantity = 0;

      final emptyCart = CartEntity(
        id: 'test_cart',
        items: const [],
        createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
      );

      when(
        mockCartRepository.updateQuantity(
          productId: productId,
          quantity: newQuantity,
        ),
      ).thenAnswer((_) async => Right(emptyCart));

      // Act
      final result = await updateQuantity(
        UpdateQuantityParams(productId: productId, newQuantity: newQuantity),
      );

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (cart) {
        expect(cart.items.length, 0);
        expect(cart.isEmpty, true);
        expect(cart.containsProduct(productId), false);
      });

      verify(
        mockCartRepository.updateQuantity(
          productId: productId,
          quantity: newQuantity,
        ),
      ).called(1);
    });

    test('should remove product completely', () async {
      // Arrange
      const productId1 = 'test_product_5';
      const productId2 = 'test_product_6';
      const price = 25.0;

      const cartItem2 = CartItemEntity(
        id: 'item_6',
        productId: productId2,
        productName: 'Test Product 6',
        productPrice: price,
        productImageUrl: 'test_image.png',
        quantity: 3,
      );

      final updatedCart = CartEntity(
        id: 'test_cart',
        items: const [cartItem2],
        createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
      );

      when(
        mockCartRepository.removeItem(productId1),
      ).thenAnswer((_) async => Right(updatedCart));

      // Act
      final result = await removeFromCart(
        RemoveFromCartParams(productId: productId1),
      );

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (cart) {
        expect(cart.items.length, 1);
        expect(cart.containsProduct(productId1), false);
        expect(cart.containsProduct(productId2), true);
        expect(cart.itemCount, 3);
      });

      verify(mockCartRepository.removeItem(productId1)).called(1);
    });

    test('should clear cart successfully', () async {
      // Arrange
      final emptyCart = CartEntity(
        id: 'test_cart',
        items: const [],
        createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
      );

      when(
        mockCartRepository.clearCart(),
      ).thenAnswer((_) async => const Right(unit));
      when(
        mockCartRepository.getCart(),
      ).thenAnswer((_) async => Right(emptyCart));

      // Act
      final clearResult = await clearCart();
      final getResult = await getCart();

      // Assert
      expect(clearResult.isRight(), true);
      expect(getResult.isRight(), true);

      getResult.fold((failure) => fail('Should not return failure'), (cart) {
        expect(cart.isEmpty, true);
        expect(cart.items.length, 0);
        expect(cart.itemCount, 0);
        expect(cart.totalAmount, 0.0);
      });

      verify(mockCartRepository.clearCart()).called(1);
      verify(mockCartRepository.getCart()).called(1);
    });

    test('should validate negative quantity', () async {
      // Arrange
      const productId = 'test_product_negative';
      const negativeQuantity = -1;

      // Não precisamos mockar o repositório porque a validação é feita no use case

      // Act
      final result = await addToCart(
        AddToCartParams(productId: productId, quantity: negativeQuantity),
      );

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure.message, contains('maior que zero'));
      }, (cart) => fail('Should return failure for negative quantity'));

      // Verifica que o repositório NÃO foi chamado porque a validação falhou antes
      verifyNever(
        mockCartRepository.addItem(
          productId: anyNamed('productId'),
          quantity: anyNamed('quantity'),
        ),
      );
    });

    test('should handle repository error gracefully', () async {
      // Arrange
      const productId = 'test_product_error';
      const quantity = 1;

      when(
        mockCartRepository.addItem(productId: productId, quantity: quantity),
      ).thenAnswer(
        (_) async =>
            const Left(StorageFailure(message: 'Erro no armazenamento')),
      );

      // Act
      final result = await addToCart(
        AddToCartParams(productId: productId, quantity: quantity),
      );

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure.message, contains('armazenamento'));
      }, (cart) => fail('Should return failure for storage error'));

      verify(
        mockCartRepository.addItem(productId: productId, quantity: quantity),
      ).called(1);
    });

    test('should handle multiple products correctly', () async {
      // Arrange
      const products = [('product_A', 2), ('product_B', 1), ('product_C', 4)];

      final cartItems = [
        const CartItemEntity(
          id: 'item_a',
          productId: 'product_A',
          productName: 'Product A',
          productPrice: 10.0,
          productImageUrl: 'image_a.png',
          quantity: 2,
        ),
        const CartItemEntity(
          id: 'item_b',
          productId: 'product_B',
          productName: 'Product B',
          productPrice: 15.0,
          productImageUrl: 'image_b.png',
          quantity: 1,
        ),
        const CartItemEntity(
          id: 'item_c',
          productId: 'product_C',
          productName: 'Product C',
          productPrice: 8.0,
          productImageUrl: 'image_c.png',
          quantity: 4,
        ),
      ];

      final multiItemCart = CartEntity(
        id: 'test_cart',
        items: cartItems,
        createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
      );

      when(
        mockCartRepository.getCart(),
      ).thenAnswer((_) async => Right(multiItemCart));

      // Act
      final result = await getCart();

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (cart) {
        expect(cart.items.length, 3);
        expect(cart.itemCount, 7); // 2 + 1 + 4

        for (final (productId, expectedQuantity) in products) {
          expect(cart.containsProduct(productId), true);
          final item = cart.findItemByProductId(productId);
          expect(item!.quantity, expectedQuantity);
        }
      });

      verify(mockCartRepository.getCart()).called(1);
    });
  });
}
