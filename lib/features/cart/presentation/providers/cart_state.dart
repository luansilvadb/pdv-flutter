import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_entity.dart';

/// Estados base para o carrinho
abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial do carrinho
class CartInitial extends CartState {
  const CartInitial();
}

/// Estado de carregamento do carrinho
class CartLoading extends CartState {
  const CartLoading();
}

/// Estado de carrinho carregado com sucesso
class CartLoaded extends CartState {
  final CartEntity cart;

  const CartLoaded(this.cart);

  @override
  List<Object?> get props => [cart];

  @override
  String toString() => 'CartLoaded(cart: $cart)';
}

/// Estado de erro no carrinho
class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'CartError(message: $message)';
}

/// Estado específico para operações de adicionar item
class CartItemAdding extends CartState {
  final String productId;

  const CartItemAdding(this.productId);

  @override
  List<Object?> get props => [productId];

  @override
  String toString() => 'CartItemAdding(productId: $productId)';
}

/// Estado específico para operações de remover item
class CartItemRemoving extends CartState {
  final String productId;

  const CartItemRemoving(this.productId);

  @override
  List<Object?> get props => [productId];

  @override
  String toString() => 'CartItemRemoving(productId: $productId)';
}

/// Estado específico para operações de atualizar quantidade
class CartItemUpdating extends CartState {
  final String productId;
  final int newQuantity;

  const CartItemUpdating(this.productId, this.newQuantity);

  @override
  List<Object?> get props => [productId, newQuantity];

  @override
  String toString() =>
      'CartItemUpdating(productId: $productId, newQuantity: $newQuantity)';
}

/// Estado de limpeza do carrinho
class CartClearing extends CartState {
  const CartClearing();
}

/// Estado de carrinho limpo com sucesso
class CartCleared extends CartState {
  const CartCleared();
}
