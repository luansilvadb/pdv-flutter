import 'package:equatable/equatable.dart';
import '../../domain/entities/order_entity.dart';

/// Estado do processo de checkout
class CheckoutState extends Equatable {
  final bool isLoading;
  final String? error;
  final OrderEntity? completedOrder;
  final PaymentMethod paymentMethod;
  final double? changeFor;

  const CheckoutState({
    this.isLoading = false,
    this.error,
    this.completedOrder,
    this.paymentMethod = PaymentMethod.cash,
    this.changeFor,
  });

  CheckoutState copyWith({
    bool? isLoading,
    String? error,
    OrderEntity? completedOrder,
    PaymentMethod? paymentMethod,
    double? changeFor,
  }) {
    return CheckoutState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      completedOrder: completedOrder ?? this.completedOrder,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      changeFor: changeFor ?? this.changeFor,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        error,
        completedOrder,
        paymentMethod,
        changeFor,
      ];
}
