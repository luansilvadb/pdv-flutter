# TECHNICAL SPEC - Dashboard Gerencial (v2.2.0)

## 1. Visão Geral
Tela centralizadora com indicadores chave de desempenho (KPIs) em tempo real.

## 2. Indicadores (KPIs)
- **Faturamento do Dia:** Total bruto vendido hoje.
- **Pedidos Ativos:** Quantidade de pedidos em processamento.
- **Ticket Médio:** Valor médio das vendas do período.
- **Alertas de Estoque:** Quantidade de itens em nível crítico.

## 3. Interface (UI/UX) - Fluent UI
- Uso de `Expander` para detalhes de KPIs.
- Gráficos de linha para tendência de vendas (`fl_chart`).
- Cartões informativos com gradientes dinâmicos conforme status (Ex: Vermelho para estoque baixo).

## 4. Concorrência e Performance
- O dashboard deve assinar (watch) os providers de Pedidos e Estoque.
- Cálculos pesados devem ser executados em Isolate caso a lista de pedidos seja extensa (> 1000 itens).

## 5. Tratamento de Erros
- Fallback visual caso os dados de histórico não possam ser carregados.
- Notificações in-app (InfoBar) para alertas críticos.
