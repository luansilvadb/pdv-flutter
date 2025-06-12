# 🍽️ PDV Restaurant

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.7.2+-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Version](https://img.shields.io/badge/Version-2.0.0-blue?style=for-the-badge)

**Sistema de Ponto de Venda moderno e intuitivo para restaurantes**

*Desenvolvido com Flutter e Clean Architecture*

[📋 Ver PRD](./PRD.md) • [🚀 Começar](#-começando) • [📖 Documentação](#-documentação) • [🤝 Contribuir](#-contribuindo)

</div>

---

## 🎯 Sobre o Projeto

O **PDV Restaurant** é um sistema de Ponto de Venda (Point of Sale) moderno, desenvolvido em Flutter com foco na experiência do usuário e performance. Projetado especificamente para restaurantes, oferece uma interface intuitiva e funcionalidades essenciais para gestão de pedidos e vendas.

### ✨ Principais Características

- 🎨 **Interface Moderna**: Design baseado no Fluent UI com tema dark profissional
- 🏗️ **Arquitetura Limpa**: Implementação seguindo Clean Architecture principles
- 📱 **Multi-plataforma**: Funciona em Desktop, Mobile e Web
- ⚡ **Performance**: Otimizado para uso em ambiente de alta demanda
- 🔄 **Estado Reativo**: Gerenciamento de estado com Riverpod
- 💾 **Persistência Local**: Armazenamento offline com Hive

---

## 🖼️ Screenshots

<div align="center">

### 🏠 Tela Principal
*Interface principal com navegação lateral e dashboard*

### 🛒 Sistema de Pedidos
*Catálogo de produtos com carrinho integrado*

### 📊 Painel de Controle
*Visão geral de vendas e métricas*

</div>

---

## 🚀 Funcionalidades

### ✅ Implementadas (v2.0)

- **🧭 Sistema de Navegação**
  - Sidebar moderna com 5 seções principais
  - Navegação fluida entre telas
  - Indicadores visuais de seção ativa

- **📦 Catálogo de Produtos**
  - Categorização inteligente (Hambúrguers, Pizzas, Bebidas)
  - Cards informativos com preços e disponibilidade
  - Sistema de busca por nome
  - Filtros por categoria

- **🛒 Carrinho de Compras**
  - Painel lateral dedicado
  - Adição/remoção de produtos
  - Controle de quantidades
  - Cálculo automático com impostos
  - Validação de estoque

- **🎨 Interface Responsiva**
  - Design adaptável para diferentes tamanhos de tela
  - Animações suaves e feedback visual
  - Tema dark profissional
  - Componentes acessíveis

### 🔄 Roadmap

#### v2.1 (Q1 2025)
- 📋 Histórico de Pedidos
- 🎁 Sistema de Promoções
- 📊 Relatórios Básicos

#### v2.2 (Q2 2025)
- ⚙️ Configurações Avançadas
- 🖨️ Integração com Impressoras
- 📈 Analytics Detalhados

#### v2.3 (Q3 2025)
- 🌐 API e Sincronização em Nuvem
- 👥 Sistema de Usuários
- 🏪 Gestão Multi-loja

---

## 🛠️ Tecnologias

### Core
- **[Flutter](https://flutter.dev/)** `3.7.2+` - Framework de desenvolvimento
- **[Dart](https://dart.dev/)** - Linguagem de programação
- **[Fluent UI](https://pub.dev/packages/fluent_ui)** `4.8.6` - Design system

### Estado e Arquitetura
- **[Riverpod](https://pub.dev/packages/riverpod)** `2.4.9` - Gerenciamento de estado
- **[GetIt](https://pub.dev/packages/get_it)** `7.6.4` - Injeção de dependência
- **[Dartz](https://pub.dev/packages/dartz)** `0.10.1` - Programação funcional

### Persistência e Dados
- **[Hive](https://pub.dev/packages/hive)** `2.2.3` - Banco de dados local
- **[Connectivity Plus](https://pub.dev/packages/connectivity_plus)** `5.0.2` - Status de conectividade

### Utilitários
- **[Intl](https://pub.dev/packages/intl)** `0.20.2` - Internacionalização
- **[Logger](https://pub.dev/packages/logger)** `2.0.2` - Sistema de logs
- **[Equatable](https://pub.dev/packages/equatable)** `2.0.5` - Comparação de objetos

---

## 🏗️ Arquitetura

O projeto segue os princípios da **Clean Architecture**, garantindo separação de responsabilidades e facilidade de manutenção.

```
lib/
├── 🎯 core/                 # Configurações centrais
│   ├── constants/          # Constantes da aplicação
│   ├── services/           # Serviços compartilhados
│   ├── storage/            # Configuração de storage
│   └── utils/              # Utilitários gerais
├── 🎪 features/            # Funcionalidades por domínio
│   ├── cart/              # 🛒 Carrinho de compras
│   │   ├── data/          # Repositórios e data sources
│   │   ├── domain/        # Entidades e use cases
│   │   └── presentation/  # UI e providers
│   ├── navigation/        # 🧭 Sistema de navegação
│   └── products/          # 📦 Catálogo de produtos
├── 🔗 shared/             # Código compartilhado
│   ├── domain/            # Entidades base e value objects
│   └── infrastructure/    # Implementações técnicas
├── 🧩 widgets/            # Componentes reutilizáveis
└── 📱 screens/            # Telas principais
```

### Camadas da Arquitetura

1. **🎯 Domain Layer**: Entidades, use cases e interfaces
2. **📊 Data Layer**: Implementação de repositórios e data sources
3. **🎨 Presentation Layer**: UI, widgets e gerenciamento de estado

---

## 🚀 Começando

### Pré-requisitos

- **Flutter SDK** `3.7.2` ou superior
- **Dart SDK** `3.0.0` ou superior
- **IDE**: VS Code, Android Studio ou IntelliJ

### Instalação

1. **Clone o repositório**
   ```bash
   git clone https://github.com/luansilvadb/pdv-flutter.git
   cd pdv-flutter
   ```

2. **Instale as dependências**
   ```bash
   flutter pub get
   ```

3. **Execute o projeto**
   ```bash
   flutter run
   ```

### Configuração do Ambiente

1. **Verifique a instalação do Flutter**
   ```bash
   flutter doctor
   ```

2. **Configure o dispositivo/emulador**
   ```bash
   flutter devices
   ```

3. **Execute em modo debug**
   ```bash
   flutter run --debug
   ```

---

## 🧪 Testes

### Executar Testes

```bash
# Todos os testes
flutter test

# Testes com cobertura
flutter test --coverage

# Testes específicos
flutter test test/features/cart/
```

### Estrutura de Testes

```
test/
├── features/           # Testes por feature
│   ├── cart/          # Testes do carrinho
│   └── products/      # Testes de produtos
├── unit/              # Testes unitários
├── integration/       # Testes de integração
└── widget/            # Testes de widgets
```

---

## 📖 Documentação

- 📋 **[Product Requirements Document (PRD)](./PRD.md)** - Documentação completa do produto
- 🏗️ **[Arquitetura](./docs/architecture.md)** - Detalhes da arquitetura (em breve)
- 🎨 **[Design System](./docs/design-system.md)** - Guia de componentes (em breve)
- 🔧 **[API Reference](./docs/api.md)** - Documentação da API (em breve)

---

## 🤝 Contribuindo

Contribuições são sempre bem-vindas! Veja como você pode ajudar:

### Como Contribuir

1. **Fork** o projeto
2. **Crie** uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. **Commit** suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. **Push** para a branch (`git push origin feature/AmazingFeature`)
5. **Abra** um Pull Request

### Diretrizes

- Siga os padrões de código estabelecidos
- Escreva testes para novas funcionalidades
- Mantenha a documentação atualizada
- Use commits semânticos (feat, fix, docs, etc.)

### Reportar Bugs

Use as [Issues do GitHub](https://github.com/luansilvadb/pdv-flutter/issues) para reportar bugs ou sugerir melhorias.

---

## 📊 Status do Projeto

### Métricas de Qualidade

- ✅ **Cobertura de Testes**: 75%+
- ✅ **Performance**: < 100ms para interações
- ✅ **Arquitetura**: Clean Architecture implementada
- ✅ **Responsividade**: Suporte a múltiplas resoluções

### Roadmap de Desenvolvimento

- [x] **v2.0** - Sistema base com carrinho e catálogo
- [ ] **v2.1** - Histórico e promoções (Q1 2025)
- [ ] **v2.2** - Configurações e analytics (Q2 2025)
- [ ] **v2.3** - API e multi-loja (Q3 2025)

---

## 📄 Licença

Este projeto está licenciado sob a **MIT License** - veja o arquivo [LICENSE](LICENSE) para detalhes.

---

## 👨‍💻 Autor

**Luan Silva**
- GitHub: [@luansilvadb](https://github.com/luansilvadb)
- LinkedIn: [Luan Silva](https://linkedin.com/in/luansilvadb)

---

## 🙏 Agradecimentos

- **Flutter Team** pela excelente framework
- **Microsoft** pelo Fluent Design System
- **Comunidade Flutter** pelas bibliotecas e suporte
- **Contribuidores** que ajudam a melhorar o projeto

---

<div align="center">

**⭐ Se este projeto te ajudou, considere dar uma estrela!**

*Desenvolvido com ❤️ e Flutter*

</div>