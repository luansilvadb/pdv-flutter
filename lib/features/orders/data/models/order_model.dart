import '../../domain/entities/order_entity.dart';
import '../../../cart/data/models/cart_item_model.dart';
import '../../../../shared/domain/value_objects/money.dart';

/// Model para OrderEntity seguindo padrão Clean Architecture
class OrderModel extends OrderEntity {
  OrderModel({
    required super.id,
    required super.items,
    required super.subtotal,
    required super.tax,
    required super.total,
    super.discount,
    super.status,
    required super.paymentMethod,
    super.customerName,
    super.customerPhone,
    super.notes,
    super.createdAt,
    super.updatedAt,
  });
  /// Cria um OrderModel a partir de um mapa (JSON)
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      items: (json['items'] as List<dynamic>)
          .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>).toEntity())
          .toList(),
      subtotal: Money((json['subtotal'] as num).toDouble()),
      tax: Money((json['tax'] as num).toDouble()),
      total: Money((json['total'] as num).toDouble()),
      discount: json['discount'] != null
          ? Money((json['discount'] as num).toDouble())
          : Money.zero,
      status: OrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.name == json['paymentMethod'],
      ),
      customerName: json['customerName'] as String?,
      customerPhone: json['customerPhone'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Converte OrderModel para mapa (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => CartItemModel.fromEntity(item).toJson()).toList(),
      'subtotal': subtotal.value,
      'tax': tax.value,
      'total': total.value,
      'discount': discount.value,
      'status': status.name,
      'paymentMethod': paymentMethod.name,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Cria um OrderModel a partir de OrderEntity
  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      id: entity.id,
      items: entity.items,
      subtotal: entity.subtotal,
      tax: entity.tax,
      total: entity.total,
      discount: entity.discount,
      status: entity.status,
      paymentMethod: entity.paymentMethod,
      customerName: entity.customerName,
      customerPhone: entity.customerPhone,
      notes: entity.notes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Converte para OrderEntity
  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      items: items,
      subtotal: subtotal,
      tax: tax,
      total: total,
      discount: discount,
      status: status,
      paymentMethod: paymentMethod,
      customerName: customerName,
      customerPhone: customerPhone,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  String toString() => 'OrderModel('
      'id: $id, '
      'itemCount: $itemCount, '
      'total: $total, '
      'status: $status, '
      'paymentMethod: $paymentMethod'
      ')';
}
