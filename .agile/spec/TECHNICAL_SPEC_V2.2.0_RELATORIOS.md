# TECHNICAL SPEC - Relatórios Detalhados (v2.2.0)

## 1. Visão Geral
Implementação de um motor de relatórios para análise de desempenho de vendas, produtos mais vendidos e fluxo financeiro.

## 2. Contratos de Dados (Schema)
```json
{
  "Report": {
    "id": "UUID",
    "type": "ENUM(SALES, PRODUCTS, FINANCIAL)",
    "period": {
      "start": "ISO8601",
      "end": "ISO8601"
    },
    "data": [
      {
        "label": "String",
        "value": "Double",
        "count": "Int",
        "percentage": "Double"
      }
    ],
    "totalValue": "Double",
    "totalCount": "Int"
  }
}
```

## 3. Regras de Negócio
- Filtragem por período (Hoje, 7 dias, 30 dias, Customizado).
- Agrupamento por categoria de produto.
- Cálculo de ticket médio por período.
- Exportação (opcional inicial) para CSV/PDF.

## 4. Gerenciamento de Estado (Riverpod)
- `ReportsNotifier`: Gerencia o carregamento e filtragem dos dados.
- `ReportsState`: Armazena os dados processados para exibição em gráficos.

## 5. Casos de Teste (BDD)
- **Given** um período de 7 dias com 10 vendas
- **When** o relatório de vendas for gerado
- **Then** a soma total e o ticket médio devem estar corretos.
