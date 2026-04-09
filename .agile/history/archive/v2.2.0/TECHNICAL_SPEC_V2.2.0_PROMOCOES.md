# TECHNICAL SPEC - Sistema de Promoções (v2.2.0)

## 1. Visão Geral
Motor de regras para aplicação de descontos, combos e promoções temporais.

## 2. Tipos de Promoção
- **Percentual:** X% de desconto no item ou subtotal.
- **Fixo:** Desconto de R$ Y.
- **Leve Pague:** Compre 3, leve 1 grátis.
- **Combo:** Preço especial para conjunto de itens (Ex: Burger + Batata + Refri).

## 3. Contrato de Promoção
```yaml
Promotion:
  id: "promo_001"
  name: "Happy Hour"
  type: "PERCENTAGE"
  value: 0.15
  conditions:
    start_time: "17:00"
    end_time: "20:00"
    days_of_week: [1, 2, 3, 4, 5]
    min_subtotal: 50.0
```

## 4. Aplicação de Regras
- O `CartProvider` deve verificar promoções ativas a cada alteração no carrinho.
- Prioridade de promoções: Promoção de item > Promoção de subtotal.

## 5. BDD
- **Given** uma promoção de 10% para pedidos acima de R$ 100
- **When** o carrinho atingir R$ 110
- **Then** o desconto de R$ 11 deve ser aplicado automaticamente.
