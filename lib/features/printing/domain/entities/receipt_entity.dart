import 'package:equatable/equatable.dart';
import '../../../orders/domain/entities/order_entity.dart';

/// Entity que representa um cupom fiscal
class ReceiptEntity extends Equatable {
  final String id;
  final String receiptNumber;
  final OrderEntity order;
  final DateTime issuedAt;
  final String? establishmentName;
  final String? establishmentAddress;
  final String? establishmentPhone;
  final String? establishmentCnpj;

  const ReceiptEntity({
    required this.id,
    required this.receiptNumber,
    required this.order,
    required this.issuedAt,
    this.establishmentName,
    this.establishmentAddress,
    this.establishmentPhone,
    this.establishmentCnpj,
  });

  /// Cria um cupom fiscal a partir de um pedido
  factory ReceiptEntity.fromOrder({
    required OrderEntity order,
    String? establishmentName,
    String? establishmentAddress,
    String? establishmentPhone,
    String? establishmentCnpj,
  }) {
    final receiptId = 'receipt_${DateTime.now().millisecondsSinceEpoch}';
    final receiptNumber = 'CF${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    
    return ReceiptEntity(
      id: receiptId,
      receiptNumber: receiptNumber,
      order: order,
      issuedAt: DateTime.now(),
      establishmentName: establishmentName ?? 'PDV Restaurant',
      establishmentAddress: establishmentAddress ?? 'Rua das Flores, 123 - Centro',
      establishmentPhone: establishmentPhone ?? '(11) 99999-9999',
      establishmentCnpj: establishmentCnpj ?? '12.345.678/0001-90',
    );
  }

  @override
  List<Object?> get props => [
    id,
    receiptNumber,
    order,
    issuedAt,
    establishmentName,
    establishmentAddress,
    establishmentPhone,
    establishmentCnpj,
  ];

  @override
  String toString() => 'ReceiptEntity(id: $id, receiptNumber: $receiptNumber)';
}
