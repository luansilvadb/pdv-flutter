import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice => product.price * quantity;

  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}

class Order {
  final String id;
  final List<CartItem> items;
  final DateTime createdAt;
  final double subtotal;
  final double tax;
  final double total;

  Order({
    required this.id,
    required this.items,
    required this.createdAt,
    required this.subtotal,
    required this.tax,
    required this.total,
  });

  static Order fromCartItems(List<CartItem> items) {
    final subtotal = items.fold(0.0, (sum, item) => sum + item.totalPrice);
    final tax = subtotal * 0.1; // 10% tax
    final total = subtotal + tax;

    return Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: items,
      createdAt: DateTime.now(),
      subtotal: subtotal,
      tax: tax,
      total: total,
    );
  }
}
