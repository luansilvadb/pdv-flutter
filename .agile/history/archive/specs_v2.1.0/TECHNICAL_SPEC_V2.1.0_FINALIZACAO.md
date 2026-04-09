# Technical Specification: Finalização de Pedidos

## Overview
Implementar o caso de uso de checkout onde os itens do carrinho são convertidos em uma `OrderEntity` usando `CreateOrder`.

## Components
1. **Domain**: `OrderEntity` (existente) modelando os dados de checkout (produtos, valores, cliente, pagamento).
2. **UseCase**: `CreateOrder` injetado pelo GetIt (`sl<CreateOrder>()`), gerenciado através de Riverpod StateNotifier/AsyncNotifier para gerenciar UI.
3. **UI**: Tela de checkout (Carrinho -> Pagamento) apresentando dados dos itens, campos de observação, cliente, etc.

## BDD Scenarios
**Scenario**: Checkout de carrinho vazio
Given o carrinho está vazio
When o usuário clica em finalizar pedido
Then o sistema bloqueia e emite um erro de validação.

**Scenario**: Checkout de carrinho com itens
Given o carrinho tem 2 produtos
And o método de pagamento selecionado é PIX
When o usuário clica em finalizar pedido
Then `CreateOrder` é executado gerando um ID de pedido
And `Cart` é limpo
And UI navega para a confirmação.

## API / State Model
```dart
class CheckoutState {
  final bool isLoading;
  final String? error;
  final OrderEntity? completedOrder;
}
```
