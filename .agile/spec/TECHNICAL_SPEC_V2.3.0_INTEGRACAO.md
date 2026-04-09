# TECHNICAL SPEC - Integração Backend (v2.3.0)

## 1. Visão Geral
Conexão do PDV com um servidor centralizado para sincronização de dados e persistência remota.

## 2. API Schema (REST)
```yaml
POST /api/v1/orders:
  body: OrderSchema
  response: 201 Created

GET /api/v1/products:
  response: List<ProductSchema>
```

## 3. Estratégia de Offline-First
- Uso de Hive como cache primário.
- Background worker para sincronizar ordens pendentes quando houver conexão.
