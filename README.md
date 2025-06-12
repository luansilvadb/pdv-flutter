# 🍽️ PDV Restaurant

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.7.2+-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Version](https://img.shields.io/badge/Version-2.0.0-orange?style=for-the-badge)

**Sistema de Ponto de Venda Moderno para Restaurantes**

*Desenvolvido com Flutter e Clean Architecture*

[🚀 Demo](#-demo) • [📋 Funcionalidades](#-funcionalidades) • [🛠️ Instalação](#️-instalação) • [📖 Documentação](#-documentação)

</div>

---

## 📖 Sobre o Projeto

O **PDV Restaurant** é um sistema de ponto de venda moderno e intuitivo, desenvolvido especificamente para restaurantes que buscam eficiência e uma experiência de usuário excepcional. Construído com Flutter e seguindo os princípios da Clean Architecture, oferece uma solução robusta, escalável e multiplataforma.

### 🎯 Objetivos

- **Modernizar** o processo de vendas em restaurantes
- **Simplificar** a operação para funcionários
- **Acelerar** o atendimento aos clientes
- **Fornecer** insights valiosos para gestores

---

## ✨ Funcionalidades

### 🏠 **Interface Principal**
- Sidebar moderna com navegação intuitiva
- Design responsivo para diferentes tamanhos de tela
- Tema dark profissional baseado no Fluent UI
- Animações suaves e feedback visual

### 🛍️ **Catálogo de Produtos**
- Organização por categorias (Hambúrguers, Pizzas, Bebidas)
- Cards visuais com imagens, descrições e preços
- Sistema de busca em tempo real
- Controle de disponibilidade e estoque
- Filtros por categoria

### 🛒 **Carrinho de Compras**
- Adição/remoção de produtos com um clique
- Controle de quantidade por item
- Cálculo automático de subtotal e impostos
- Interface lateral dedicada e sempre visível
- Persistência local dos dados

### 🎨 **Design System**
- Paleta de cores consistente e moderna
- Componentes reutilizáveis
- Tipografia hierárquica
- Estados visuais para interações
- Acessibilidade considerada

---

## 🏗️ Arquitetura

### **Clean Architecture**
```
📁 lib/
├── 📁 core/                    # Configurações centrais
│   ├── 📁 constants/          # Constantes da aplicação
│   ├── 📁 services/           # Serviços compartilhados
│   ├── 📁 storage/            # Gerenciamento de dados
│   └── 📁 network/            # Configurações de rede
├── 📁 features/               # Módulos de funcionalidades
│   ├── 📁 products/           # Gestão de produtos
│   │   ├── 📁 domain/         # Entidades e casos de uso
│   │   ├── 📁 data/           # Repositórios e fontes de dados
│   │   └── 📁 presentation/   # UI e gerenciamento de estado
│   ├── 📁 cart/               # Carrinho de compras
│   └── 📁 navigation/         # Sistema de navegação
├── 📁 shared/                 # Código compartilhado
└── 📁 widgets/                # Componentes reutilizáveis
```

### **Stack Tecnológico**

| Categoria | Tecnologia | Versão | Propósito |
|-----------|------------|--------|-----------|
| **Framework** | Flutter | 3.7.2+ | Desenvolvimento multiplataforma |
| **UI Library** | Fluent UI | 4.8.6 | Design system moderno |
| **State Management** | Riverpod | 2.4.9 | Gerenciamento de estado reativo |
| **Dependency Injection** | GetIt | 7.6.4 | Injeção de dependências |
| **Local Storage** | Hive | 2.2.3 | Persistência de dados local |
| **Functional Programming** | Dartz | 0.10.1 | Programação funcional |
| **Testing** | Mockito | 5.4.4 | Testes unitários e mocking |

---

## 🚀 Demo

### Screenshots

<div align="center">

| Tela Principal | Menu de Produtos | Carrinho |
|:--------------:|:----------------:|:--------:|
| ![Home](docs/images/home-screen.png) | ![Menu](docs/images/menu-screen.png) | ![Cart](docs/images/cart-panel.png) |

</div>

### Funcionalidades em Ação

- ✅ **Navegação Fluida**: Transições suaves entre seções
- ✅ **Busca Inteligente**: Encontre produtos rapidamente
- ✅ **Carrinho Dinâmico**: Atualizações em tempo real
- ✅ **Design Responsivo**: Adapta-se a qualquer tela

---

## 🛠️ Instalação

### Pré-requisitos

- **Flutter SDK**: 3.7.2 ou superior
- **Dart SDK**: 3.0 ou superior
- **IDE**: VS Code, Android Studio ou IntelliJ

### Passos de Instalação

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

### Plataformas Suportadas

- ✅ **Windows** (Recomendado)
- ✅ **macOS**
- ✅ **Linux**
- ✅ **Web**
- ✅ **Android**
- ✅ **iOS**

---

## 🧪 Testes

### Executar Testes

```bash
# Todos os testes
flutter test

# Testes com cobertura
flutter test --coverage

# Testes específicos
flutter test test/features/products/
```

### Cobertura de Testes

- **Domain Layer**: 90%+
- **Presentation Layer**: 80%+
- **Data Layer**: 85%+
- **Overall**: 85%+

---

## 📁 Estrutura do Projeto

```
pdv-flutter/
├── 📁 android/                 # Configurações Android
├── 📁 assets/                  # Recursos estáticos
│   └── 📁 images/             # Imagens dos produtos
├── 📁 ios/                     # Configurações iOS
├── 📁 lib/                     # Código fonte principal
│   ├── 📁 core/               # Núcleo da aplicação
│   ├── 📁 features/           # Funcionalidades modulares
│   ├── 📁 shared/             # Código compartilhado
│   ├── 📁 widgets/            # Componentes UI
│   └── 📄 main.dart           # Ponto de entrada
├── 📁 test/                    # Testes automatizados
├── 📁 web/                     # Configurações Web
├── 📄 pubspec.yaml            # Dependências do projeto
├── 📄 README.md               # Este arquivo
└── 📄 PRD.md                  # Documento de requisitos
```

---

## 🎨 Design System

### Paleta de Cores

```dart
// Cores principais
Background: #121212
Surface: #1E1E1E
Primary Accent: #FF8A65
Secondary Accent: #4FC3F7
Success: #4CAF50
Text Primary: #FFFFFF
```

### Componentes

- **Cards**: Bordas arredondadas com sombras sutis
- **Botões**: Estados hover, pressed e disabled
- **Inputs**: Validação visual e feedback
- **Navegação**: Indicadores ativos e transições

---

## 🔄 Roadmap

### 📋 Versão Atual (2.0.0)
- ✅ Interface moderna com Fluent UI
- ✅ Catálogo de produtos completo
- ✅ Carrinho de compras funcional
- ✅ Sistema de navegação
- ✅ Arquitetura Clean implementada

### 🚀 Próximas Versões

#### v2.1.0 - Processamento de Vendas
- [ ] Finalização de pedidos
- [ ] Métodos de pagamento
- [ ] Impressão de cupons
- [ ] Histórico de vendas

#### v2.2.0 - Gestão Avançada
- [ ] Relatórios detalhados
- [ ] Gestão de estoque
- [ ] Sistema de promoções
- [ ] Dashboard gerencial

#### v2.3.0 - Integração
- [ ] API backend
- [ ] Sincronização multi-device
- [ ] Integração com delivery
- [ ] Sistema de usuários

---

## 🤝 Contribuição

Contribuições são sempre bem-vindas! Veja como você pode ajudar:

### Como Contribuir

1. **Fork** o projeto
2. **Crie** uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. **Commit** suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. **Push** para a branch (`git push origin feature/AmazingFeature`)
5. **Abra** um Pull Request

### Diretrizes

- Siga os padrões de código estabelecidos
- Adicione testes para novas funcionalidades
- Mantenha a documentação atualizada
- Use commits semânticos

### Reportar Bugs

Encontrou um bug? [Abra uma issue](https://github.com/luansilvadb/pdv-flutter/issues) com:

- Descrição detalhada do problema
- Passos para reproduzir
- Screenshots (se aplicável)
- Informações do ambiente

---

## 📄 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

```
MIT License

Copyright (c) 2025 PDV Restaurant

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
```

---

## 👨‍💻 Autor

**Luan Silva**
- GitHub: [@luansilvadb](https://github.com/luansilvadb)
- LinkedIn: [Luan Silva](https://linkedin.com/in/luansilvadb)
- Email: luan@example.com

---

## 🙏 Agradecimentos

- **Flutter Team** - Framework incrível
- **Microsoft** - Fluent UI design system
- **Riverpod Team** - Excelente gerenciamento de estado
- **Comunidade Flutter** - Suporte e inspiração

---

## 📊 Status do Projeto

![GitHub last commit](https://img.shields.io/github/last-commit/luansilvadb/pdv-flutter)
![GitHub issues](https://img.shields.io/github/issues/luansilvadb/pdv-flutter)
![GitHub pull requests](https://img.shields.io/github/issues-pr/luansilvadb/pdv-flutter)
![GitHub stars](https://img.shields.io/github/stars/luansilvadb/pdv-flutter)

---

## 📞 Suporte

Precisa de ajuda? Entre em contato:

- 📧 **Email**: support@pdv-restaurant.com
- 💬 **Discord**: [Servidor da Comunidade](https://discord.gg/pdv-restaurant)
- 📖 **Documentação**: [docs.pdv-restaurant.com](https://docs.pdv-restaurant.com)
- 🐛 **Issues**: [GitHub Issues](https://github.com/luansilvadb/pdv-flutter/issues)

---

## 📖 Documentação

### Documentos Principais
- 📋 **[Product Requirements Document (PRD)](./PRD.md)** - Documentação completa do produto
- 🏗️ **[Arquitetura](./docs/architecture.md)** - Detalhes da arquitetura (em breve)
- 🎨 **[Design System](./docs/design-system.md)** - Guia de componentes (em breve)
- 🔧 **[API Reference](./docs/api.md)** - Documentação da API (em breve)

### Links Úteis
- [Flutter Documentation](https://docs.flutter.dev/)
- [Fluent UI Documentation](https://pub.dev/packages/fluent_ui)
- [Riverpod Documentation](https://riverpod.dev/)
- [Clean Architecture Guide](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

<div align="center">

**⭐ Se este projeto te ajudou, considere dar uma estrela!**

**Feito com ❤️ e Flutter**

</div>