# PDV Restaurant - Flutter Web

Sistema PDV moderno para restaurantes desenvolvido em Flutter Web com arquitetura Clean.

## 🚀 Tecnologias

- **Flutter Web** - Framework principal
- **Dart** - Linguagem de programação
- **Riverpod** - Gerenciamento de estado
- **Clean Architecture** - Padrão arquitetural


## 📱 Características

- ✅ **Flutter Web App** - SPA responsiva
- ✅ **PWA Ready** - Progressive Web App
- ✅ **CanvasKit Renderer** - Performance otimizada
- ✅ **Clean Architecture** - Código organizado e testável
- ✅ **Responsive Design** - Funciona em desktop e mobile

## 🛠️ Desenvolvimento

### Pré-requisitos

- Flutter SDK >=3.7.2
- Dart SDK
- Chrome (para desenvolvimento)

### Comandos

```bash
# Instalar dependências
flutter pub get

# Executar em modo desenvolvimento
flutter run -d chrome

# Build para produção
flutter build web --release
```

## 🌐 Deploy

Para fazer deploy do projeto:










```bash
# Build para produção
flutter build web --release --tree-shake-icons --source-maps

# O diretório build/web contém os arquivos para deploy
```

## 📁 Estrutura do Projeto

```
lib/
├── core/           # Configurações e utilitários centrais
├── features/       # Funcionalidades organizadas por domínio
│   ├── cart/       # Carrinho de compras
│   ├── products/   # Produtos e categorias
│   └── navigation/ # Navegação
├── screens/        # Telas principais
└── widgets/        # Componentes reutilizáveis
```

## 🎯 Funcionalidades

- 📋 **Catálogo de Produtos** - Visualização organizada por categorias
- 🛒 **Carrinho de Compras** - Adição/remoção de itens
- 💰 **Cálculo Automático** - Subtotal, desconto e total
- 🎨 **Interface Moderna** - Design clean e intuitivo
- 📱 **Responsivo** - Funciona em desktop e mobile

## 🔧 Tecnologias Utilizadas

### Frontend
- **Flutter Web** - Framework UI
- **Fluent UI** - Biblioteca de componentes
- **Riverpod** - State management
- **Go Router** - Navegação

### Arquitetura
- **Clean Architecture** - Separação de responsabilidades
- **Domain-Driven Design** - Modelagem orientada ao domínio
- **Dependency Injection** - Inversão de dependências

### Qualidade
- **Flutter Lints** - Análise estática
- **Very Good Analysis** - Regras rigorosas
- **Unit Tests** - Testes automatizados

## 📊 Performance

- ⚡ **Tree Shaking** - Remoção de código não utilizado
- 🎯 **Code Splitting** - Carregamento otimizado
- 🗜️ **Asset Optimization** - Compressão de recursos
- 📈 **Lighthouse Score** - Métricas de performance monitoradas

## 🤝 Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua feature
3. Commit suas mudanças
4. Push para a branch
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.
