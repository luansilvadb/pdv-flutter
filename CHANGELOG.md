# Changelog

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
e este projeto adere ao [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planejado
- Finalização de pedidos
- Sistema de pagamento
- Impressão de cupons
- Histórico de vendas

## [2.0.0] - 2025-06-12

### Adicionado
- ✨ Interface moderna com Fluent UI
- 🏗️ Arquitetura Clean implementada
- 🛍️ Catálogo completo de produtos
- 🛒 Sistema de carrinho de compras
- 🧭 Navegação lateral moderna
- 🎨 Design system consistente
- 📱 Suporte multiplataforma
- 🔄 Gerenciamento de estado com Riverpod
- 💾 Persistência local com Hive
- 🧪 Estrutura de testes implementada

### Funcionalidades Principais
- **Sistema de Navegação**: Sidebar com 5 seções (Home, Menu, Histórico, Promoções, Configurações)
- **Catálogo de Produtos**: Organização por categorias (Hambúrguers, Pizzas, Bebidas)
- **Carrinho de Compras**: Adição/remoção de produtos, controle de quantidade, cálculo automático
- **Interface Responsiva**: Design adaptável para diferentes tamanhos de tela
- **Busca e Filtros**: Sistema de busca por nome e filtros por categoria

### Técnico
- **Framework**: Flutter 3.7.2+
- **UI Library**: Fluent UI 4.8.6
- **State Management**: Riverpod 2.4.9
- **Dependency Injection**: GetIt 7.6.4
- **Local Storage**: Hive 2.2.3
- **Functional Programming**: Dartz 0.10.1
- **Testing**: Mockito 5.4.4

### Arquitetura
- Implementação da Clean Architecture
- Separação em camadas (Domain, Data, Presentation)
- Modularização por features
- Injeção de dependências
- Padrão Repository
- Use Cases para lógica de negócio

## [1.0.0] - 2025-01-01

### Adicionado
- 🎯 Projeto inicial
- 📋 Estrutura básica do Flutter
- 🏗️ Configuração inicial da arquitetura
- 📱 Configuração para múltiplas plataformas

---

## Tipos de Mudanças

- `Adicionado` para novas funcionalidades
- `Alterado` para mudanças em funcionalidades existentes
- `Depreciado` para funcionalidades que serão removidas
- `Removido` para funcionalidades removidas
- `Corrigido` para correções de bugs
- `Segurança` para vulnerabilidades

## Links

- [Unreleased]: https://github.com/luansilvadb/pdv-flutter/compare/v2.0.0...HEAD
- [2.0.0]: https://github.com/luansilvadb/pdv-flutter/compare/v1.0.0...v2.0.0
- [1.0.0]: https://github.com/luansilvadb/pdv-flutter/releases/tag/v1.0.0