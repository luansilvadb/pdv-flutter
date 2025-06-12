import 'package:flutter_test/flutter_test.dart';
import 'package:pdv_restaurant/features/cart/domain/entities/cart_entity.dart';
import 'package:pdv_restaurant/shared/domain/value_objects/quantity.dart';
import 'package:pdv_restaurant/shared/domain/value_objects/money.dart';

/// Testes básicos de integração do carrinho
/// Versão simplificada para garantir que as entidades funcionem corretamente
void main() {
  group('Cart Integration Tests - Basic', () {
    test('should create empty cart successfully', () {
      // Arrange & Act
      final emptyCart = CartEntity.empty();

      // Assert
      expect(emptyCart.isEmpty, true);
      expect(emptyCart.itemCount, 0);
      expect(emptyCart.totalAmount, 0.0);
      expect(emptyCart.items, isEmpty);
    });

    test('should create cart with correct totals', () {
      // Arrange
      final cart = CartEntity(
        id: 'test_cart',
        items: [],
        subtotal: const Money(100.0),
        tax: const Money(10.0),
        total: const Money(110.0),
      );

      // Assert
      expect(cart.subtotal.value, 100.0);
      expect(cart.tax.value, 10.0);
      expect(cart.total.value, 110.0);
      expect(cart.totalAmount, 110.0);
    });

    test('should work with Quantity value objects', () {
      // Arrange
      const quantity1 = Quantity(5);
      const quantity2 = Quantity(0);
      const quantity3 = Quantity(3);

      // Assert
      expect(quantity1.value, 5);
      expect(quantity1.isAvailable, true);
      expect(quantity1.isLow, true); // <= 5

      expect(quantity2.value, 0);
      expect(quantity2.isEmpty, true);
      expect(quantity2.isAvailable, false);

      expect(quantity3.value, 3);
      expect(quantity3.isPositive, true);
      expect(quantity3.isLow, true);
    });

    test('should work with Money value objects', () {
      // Arrange
      const money1 = Money(10.50);
      const money2 = Money(0.0);

      // Assert
      expect(money1.value, 10.50);
      expect(money1.isPositive, true);
      expect(money1.formatted, contains('R\$'));

      expect(money2.value, 0.0);
      expect(money2.isZero, true);
    });

    test('should validate quantity operations', () {
      // Arrange
      const qty1 = Quantity(5);
      const qty2 = Quantity(3);

      // Act & Assert
      final sum = qty1 + qty2;
      expect(sum.value, 8);

      final incremented = qty1.increment();
      expect(incremented.value, 6);

      final decremented = qty1.decrement();
      expect(decremented.value, 4);
    });

    test('should validate money operations', () {
      // Arrange
      const money1 = Money(10.0);
      const money2 = Money(5.0);

      // Act & Assert
      final sum = money1 + money2;
      expect(sum.value, 15.0);

      final difference = money1 - money2;
      expect(difference.value, 5.0);

      final product = money1 * 2;
      expect(product.value, 20.0);
    });
  });
}
