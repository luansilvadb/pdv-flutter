# Technical Specification: Histórico de Vendas

## Overview
Criação da UI e Provider para listar `OrderEntity` usando `GetAllOrders` e `GetOrdersByDateRange`.

## Components
1. **Domain**: `GetAllOrders`, `GetOrdersByDateRange` injetados pelo GetIt.
2. **State Management**: Riverpod `FutureProvider` ou `AsyncNotifier` para buscar os dados baseados num range de datas.
3. **UI**: Tabela/Lista em `Fluent UI` apresentando ID do Pedido, Cliente, Valor Total, Método de Pagamento e Status.

## State Rules
- Ao entrar na tela, carregar pedidos do dia atual (DateRange: start of day -> end of day).
- Permitir filtro por Status (`OrderStatus`).

## Contract/Data
Os dados virão do `OrderLocalDataSource` gerido pelo Hive (configurado em core services).