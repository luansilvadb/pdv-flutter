# Technical Specification: Métodos de Pagamento

## Overview
Ajustar a UI para que o usuário possa selecionar o `PaymentMethod` (enum de `order_entity.dart`: cash, credit, debit, pix).

## Components
1. **Domain**: `PaymentMethod` enum com `displayName`.
2. **State Management**: Um Riverpod Provider para o método de pagamento selecionado atual durante a sessão de checkout.
3. **UI Component**: Um Group de Radio Buttons ou Grid de botões representando cada método.

## Concurrency / Rules
- Se o método for `cash`, exibir input opcional para "Troco para".
- O campo é obrigatório para prosseguir no `CreateOrder`.

## Sequence
```
User -> UI: Seleciona PIX
UI -> CheckoutNotifier: updatePaymentMethod(PaymentMethod.pix)
CheckoutNotifier -> State: rebuild UI
```