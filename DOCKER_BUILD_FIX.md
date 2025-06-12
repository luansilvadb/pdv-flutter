# 🐳 Correção do Erro de Build Docker - pubspec.lock

## 📋 Problema Identificado

O erro de build Docker estava ocorrendo porque:

```
ERROR: failed to solve: failed to compute cache key: failed to calculate checksum of ref ebcd6842-0029-4580-adc7-fac041759ed5::d6bj0fo9t7ivn9jg6joj23q9f: "/pubspec.lock": not found
```

### 🔍 Causas Raiz

1. **`.dockerignore` excluindo `pubspec.lock`**: Na linha 171, o arquivo estava sendo explicitamente ignorado
2. **Dockerfiles dependendo de `pubspec.lock`**: Ambos os Dockerfiles tentavam copiar o arquivo mesmo quando não disponível
3. **Abordagem não robusta**: O build falhava completamente sem o arquivo

## ✅ Soluções Implementadas

### 1. **Correção do `.dockerignore`**
```diff
# .dockerignore (linha 171)
- pubspec.lock
```
**Removido** `pubspec.lock` da lista de arquivos ignorados para permitir sua inclusão no contexto Docker.

### 2. **Dockerfile de Produção (Dockerfile)**
```diff
# Linha 54-55
- COPY pubspec.yaml pubspec.lock ./
+ COPY pubspec.yaml ./
