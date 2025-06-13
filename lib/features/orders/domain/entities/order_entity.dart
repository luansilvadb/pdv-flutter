import '../../../../shared/domain/entities/base_entity.dart';
import '../../../../shared/domain/value_objects/money.dart';
import '../../../cart/domain/entities/cart_item_entity.dart';

/// Enum para o status do pedido
enum OrderStatus {
  pending('Pendente'),
  processing('Processando'),
  completed('Concluído'),
  cancelled('Cancelado');

  const OrderStatus(this.displayName);
  final String displayName;
}

/// Enum para o método de pagamento
enum PaymentMethod {
  cash('Dinheiro'),
  credit('Cartão de Crédito'),
  debit('Cartão de Débito'),
  pix('PIX');

  const PaymentMethod(this.displayName);
  final String displayName;
}

/// Entity do pedido seguindo princípios Clean Architecture
class OrderEntity extends Entity {
  @override
  final String id;
  final List<CartItemEntity> items;
  final Money subtotal;
  final Money tax;
  final Money total;
  final Money discount;
  final OrderStatus status;
  final PaymentMethod paymentMethod;
  final String? customerName;
  final String? customerPhone;
  final String? notes;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  OrderEntity({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    this.discount = Money.zero,
    this.status = OrderStatus.pending,
    required this.paymentMethod,
    this.customerName,
    this.customerPhone,
    this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Cria um pedido a partir de um carrinho
  factory OrderEntity.fromCart({
    required String id,
    required List<CartItemEntity> cartItems,
    required Money subtotal,
    required Money tax,
    required Money total,
    required PaymentMethod paymentMethod,
    Money discount = Money.zero,
    String? customerName,
    String? customerPhone,
    String? notes,
  }) {
    return OrderEntity(
      id: id,
      items: cartItems,
      subtotal: subtotal,
      tax: tax,
      total: total,
      discount: discount,
      paymentMethod: paymentMethod,
      customerName: customerName,
      customerPhone: customerPhone,
      notes: notes,
      status: OrderStatus.pending,
    );
  }

  /// Verifica se o pedido está vazio
  bool get isEmpty => items.isEmpty;

  /// Verifica se o pedido tem itens
  bool get isNotEmpty => items.isNotEmpty;

  /// Quantidade total de itens no pedido
  int get itemCount {
    return items.fold(0, (sum, item) => sum + item.quantity.value);
  }

  /// Verifica se o pedido foi finalizado
  bool get isCompleted => status == OrderStatus.completed;

  /// Verifica se o pedido foi cancelado
  bool get isCancelled => status == OrderStatus.cancelled;

  /// Verifica se o pedido pode ser cancelado
  bool get canBeCancelled {
    return status == OrderStatus.pending || status == OrderStatus.processing;
  }

  /// Cria uma cópia do pedido com novos valores
  OrderEntity copyWith({
    String? id,
    List<CartItemEntity>? items,
    Money? subtotal,
    Money? tax,
    Money? total,
    Money? discount,
    OrderStatus? status,
    PaymentMethod? paymentMethod,
    String? customerName,
    String? customerPhone,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderEntity(
      id: id ?? this.id,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      discount: discount ?? this.discount,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        items,
        subtotal,
        tax,
        total,
        discount,
        status,
        paymentMethod,
        customerName,
        customerPhone,
        notes,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() => 'OrderEntity('
      'id: $id, '
      'itemCount: $itemCount, '
      'total: $total, '
      'status: $status, '
      'paymentMethod: $paymentMethod, '
      'createdAt: $createdAt'
      ')';
}
