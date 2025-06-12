---
layout: default
title: Features
nav_order: 4
description: "Funcionalidades e recursos do PDV Restaurant"
---

# Features
{: .no_toc }

Documentação completa das funcionalidades e recursos disponíveis no PDV Restaurant.
{: .fs-6 .fw-300 }

## Índice
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Visão Geral das Funcionalidades

O PDV Restaurant oferece um conjunto abrangente de funcionalidades para gestão completa de vendas em restaurantes.

### Status das Funcionalidades

| Funcionalidade | Status | Versão | Prioridade |
|:---------------|:-------|:-------|:-----------|
| Sistema de Navegação | ✅ Implementado | v2.0.0 | Alta |
| Catálogo de Produtos | ✅ Implementado | v2.0.0 | Alta |
| Carrinho de Compras | ✅ Implementado | v2.0.0 | Alta |
| Interface Responsiva | ✅ Implementado | v2.0.0 | Alta |
| Histórico de Pedidos | 🔄 Em desenvolvimento | v2.1.0 | Média |
| Sistema de Promoções | 📋 Planejado | v2.1.0 | Média |
| Relatórios e Analytics | 📋 Planejado | v2.2.0 | Baixa |
| Integração com API | 📋 Planejado | v2.3.0 | Baixa |

---

## Funcionalidades Implementadas (v2.0.0)

### 🧭 Sistema de Navegação

**Descrição**: Sistema de navegação principal com sidebar moderna e intuitiva.

#### Características
- **Sidebar responsiva** com 5 seções principais
- **Indicadores visuais** de seção ativa
- **Animações suaves** entre transições
- **Design moderno** com gradientes e sombras

#### Seções Disponíveis
1. **Home** - Dashboard principal
2. **Menu** - Catálogo de produtos
3. **History** - Histórico de pedidos (em desenvolvimento)
4. **Promos** - Sistema de promoções (planejado)
5. **Settings** - Configurações (planejado)

#### Implementação Técnica
```dart
// Navegação com Riverpod
final navigationProvider = StateNotifierProvider<NavigationNotifier, NavigationState>(
  (ref) => NavigationNotifier(),
);

class NavigationNotifier extends StateNotifier<NavigationState> {
  NavigationNotifier() : super(NavigationState(selectedIndex: 0));
  
  void setSelectedIndex(int index) {
    state = state.copyWith(selectedIndex: index);
  }
}
```

#### Como Usar
```dart
// Acessar o estado atual da navegação
final navigationState = ref.watch(navigationProvider);

// Alterar seção ativa
ref.read(navigationProvider.notifier).setSelectedIndex(1);
```

---

### 📦 Catálogo de Produtos

**Descrição**: Sistema completo de gerenciamento e exibição de produtos.

#### Características
- **Categorização automática** por tipo de produto
- **Cards informativos** com todas as informações essenciais
- **Sistema de busca** em tempo real
- **Filtros por categoria** com tabs interativas
- **Controle de estoque** visual
- **Preços formatados** automaticamente

#### Categorias Disponíveis
1. **Hambúrguers** - Hambúrguers artesanais
2. **Pizzas** - Pizzas tradicionais e especiais
3. **Bebidas** - Refrigerantes, sucos e bebidas

#### Estrutura de Produto
```dart
class ProductEntity {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String categoryId;
  final bool isAvailable;
  final int availableQuantity;
  
  // Getters computados
  bool get isLowStock => availableQuantity <= 5 && availableQuantity > 0;
  bool get isOutOfStock => availableQuantity == 0;
  String get formattedPrice => Money(price).formatted;
}
```

#### Funcionalidades de Busca
```dart
// Busca por nome do produto
final searchProvider = StateProvider<String>((ref) => '');

// Filtro por categoria
final categoryFilterProvider = StateProvider<String?>((ref) => null);

// Produtos filtrados
final filteredProductsProvider = Provider<List<ProductEntity>>((ref) {
  final products = ref.watch(productsProvider);
  final searchQuery = ref.watch(searchProvider);
  final categoryFilter = ref.watch(categoryFilterProvider);
  
  return products.where((product) {
    final matchesSearch = product.name.toLowerCase().contains(searchQuery.toLowerCase());
    final matchesCategory = categoryFilter == null || product.categoryId == categoryFilter;
    return matchesSearch && matchesCategory;
  }).toList();
});
```

#### Como Usar
```dart
// Exibir lista de produtos
Consumer(
  builder: (context, ref, child) {
    final products = ref.watch(filteredProductsProvider);
    
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.8,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) => ProductCard(products[index]),
    );
  },
)
```

---

### 🛒 Carrinho de Compras

**Descrição**: Sistema completo de carrinho com todas as funcionalidades essenciais.

#### Características
- **Painel lateral** dedicado e sempre visível
- **Adição/remoção** de produtos
- **Controle de quantidades** com validação
- **Cálculo automático** de subtotal e total
- **Aplicação de impostos** (10% configurável)
- **Validação de estoque** em tempo real
- **Persistência local** com Hive
- **Limite de itens** (máximo 50 itens)

#### Estrutura do Carrinho
```dart
class CartEntity {
  final String id;
  final List<CartItemEntity> items;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Cálculos automáticos
  double get subtotal => items.fold(0, (sum, item) => sum + item.total);
  double get tax => subtotal * AppConstants.taxRate;
  double get total => subtotal + tax;
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  
  // Validações
  bool get isEmpty => items.isEmpty;
  bool get isAtMaxCapacity => totalItems >= AppConstants.maxCartItems;
}

class CartItemEntity {
  final String id;
  final ProductEntity product;
  final int quantity;
  
  double get total => product.price * quantity;
}
```

#### Use Cases Disponíveis
```dart
// Adicionar produto ao carrinho
class AddToCart {
  Future<Either<Failure, CartEntity>> call(
    String productId,
    int quantity,
  ) async {
    // Validações e lógica de negócio
  }
}

// Remover produto do carrinho
class RemoveFromCart {
  Future<Either<Failure, CartEntity>> call(String itemId) async {
    // Lógica de remoção
  }
}

// Atualizar quantidade
class UpdateCartItemQuantity {
  Future<Either<Failure, CartEntity>> call(
    String itemId,
    int newQuantity,
  ) async {
    // Validações e atualização
  }
}

// Limpar carrinho
class ClearCart {
  Future<Either<Failure, void>> call() async {
    // Limpeza completa
  }
}
```

#### Como Usar
```dart
// Adicionar produto ao carrinho
await ref.read(cartProvider.notifier).addToCart(productId, quantity);

// Remover item
await ref.read(cartProvider.notifier).removeFromCart(itemId);

// Atualizar quantidade
await ref.read(cartProvider.notifier).updateQuantity(itemId, newQuantity);

// Limpar carrinho
await ref.read(cartProvider.notifier).clearCart();
```

#### Interface do Carrinho
```dart
class CartPanel extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    
    return Container(
      width: AppSizes.cartPanelWidth,
      child: Column(
        children: [
          // Header do carrinho
          CartHeader(),
          
          // Lista de itens
          Expanded(
            child: cartState.when(
              data: (cart) => CartItemsList(cart.items),
              loading: () => CircularProgressIndicator(),
              error: (error, stack) => ErrorWidget(error),
            ),
          ),
          
          // Resumo e total
          CartSummary(),
          
          // Botões de ação
          CartActions(),
        ],
      ),
    );
  }
}
```

---

### 🎨 Interface Responsiva

**Descrição**: Interface moderna e adaptável baseada no Fluent Design System.

#### Características
- **Design System**: Fluent UI da Microsoft
- **Tema Dark**: Profissional e moderno
- **Responsividade**: Adaptável a diferentes tamanhos de tela
- **Animações**: Transições suaves e feedback visual
- **Acessibilidade**: Componentes acessíveis
- **Performance**: Otimizada para 60fps

#### Paleta de Cores
```dart
class AppColors {
  // Cores principais
  static const Color primaryAccent = Color(0xFFFF8A65);
  static const Color secondaryAccent = Color(0xFF4FC3F7);
  
  // Backgrounds
  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color surfaceVariant = Color(0xFF2A2A2A);
  
  // Texto
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFE0E0E0);
  static const Color textTertiary = Color(0xFFBDBDBD);
}
```

#### Breakpoints Responsivos
```dart
class AppBreakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  static const double desktopLarge = 1600;
  
  static bool isMobile(double width) => width < mobile;
  static bool isTablet(double width) => width >= mobile && width < desktop;
  static bool isDesktop(double width) => width >= desktop;
}
```

#### Componentes Reutilizáveis
```dart
// Card de produto responsivo
class ProductCard extends StatelessWidget {
  final ProductEntity product;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: AppSizes.productCardMinWidth,
        maxWidth: AppSizes.productCardMaxWidth,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.surface, AppColors.surfaceVariant],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Imagem do produto
          ProductImage(product.imageUrl),
          
          // Informações
          ProductInfo(product),
          
          // Ações
          ProductActions(product),
        ],
      ),
    );
  }
}
```

---

## Funcionalidades em Desenvolvimento (v2.1.0)

### 📋 Histórico de Pedidos

**Status**: 🔄 Em desenvolvimento  
**Previsão**: Q1 2025

#### Funcionalidades Planejadas
- **Lista de pedidos** realizados
- **Filtros por data** e valor
- **Detalhes do pedido** expandidos
- **Status do pedido** (pendente, concluído, cancelado)
- **Busca por número** do pedido
- **Exportação** de dados

#### Estrutura Planejada
```dart
class OrderEntity {
  final String id;
  final List<CartItemEntity> items;
  final double subtotal;
  final double tax;
  final double total;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;
}

enum OrderStatus {
  pending,
  processing,
  completed,
  cancelled,
}
```

### 🎁 Sistema de Promoções

**Status**: 📋 Planejado  
**Previsão**: Q1 2025

#### Funcionalidades Planejadas
- **Criação de ofertas** promocionais
- **Desconto por porcentagem** ou valor fixo
- **Promoções por categoria** ou produto específico
- **Período de validade** configurável
- **Aplicação automática** no carrinho
- **Códigos promocionais**

---

## Funcionalidades Futuras

### v2.2.0 (Q2 2025)

#### ⚙️ Configurações Avançadas
- Personalização de impostos
- Configuração de impressoras
- Backup e restauração de dados
- Configurações de interface

#### 📊 Relatórios e Analytics
- Dashboard de vendas
- Produtos mais vendidos
- Análise de performance
- Relatórios personalizáveis

### v2.3.0 (Q3 2025)

#### 🌐 Integração com API
- Sincronização em nuvem
- Atualizações em tempo real
- Backup automático
- Sincronização multi-dispositivo

#### 👥 Sistema de Usuários
- Autenticação e autorização
- Perfis de acesso
- Auditoria de ações
- Gestão de permissões

#### 🏪 Gestão Multi-loja
- Múltiplas filiais
- Centralização de dados
- Relatórios consolidados
- Gestão de estoque distribuído

---

## Métricas e Performance

### Métricas de Funcionalidades

| Métrica | Valor Atual | Meta |
|:--------|:------------|:-----|
| Tempo de carregamento | < 2s | < 1s |
| Responsividade da UI | < 100ms | < 50ms |
| Taxa de erro | < 1% | < 0.5% |
| Cobertura de testes | 75% | 90% |

### Performance por Funcionalidade

- **Navegação**: Transições em < 300ms
- **Busca de produtos**: Resultados em < 200ms
- **Carrinho**: Atualizações em < 100ms
- **Persistência**: Salvamento em < 50ms

---

## Testes de Funcionalidades

### Testes Automatizados

```dart
// Teste de funcionalidade do carrinho
group('Cart Functionality', () {
  testWidgets('should add product to cart', (tester) async {
    // Arrange
    final product = ProductEntity(...);
    
    // Act
    await tester.tap(find.byKey(Key('add-to-cart-${product.id}')));
    await tester.pump();
    
    // Assert
    expect(find.text('1'), findsOneWidget); // Quantidade no carrinho
  });
  
  testWidgets('should calculate total correctly', (tester) async {
    // Teste de cálculo de total
  });
});
```

### Testes de Integração

```dart
// Teste de fluxo completo
testWidgets('complete purchase flow', (tester) async {
  // 1. Navegar para menu
  await tester.tap(find.text('Menu'));
  await tester.pumpAndSettle();
  
  // 2. Adicionar produto ao carrinho
  await tester.tap(find.byKey(Key('add-to-cart-1')));
  await tester.pump();
  
  // 3. Verificar carrinho
  expect(find.text('R\$ 25,90'), findsOneWidget);
  
  // 4. Finalizar pedido (quando implementado)
  // await tester.tap(find.text('Finalizar Pedido'));
});
```

---

## Conclusão

O PDV Restaurant oferece um conjunto robusto de funcionalidades que atendem às necessidades essenciais de um sistema de ponto de venda para restaurantes. Com uma arquitetura sólida e roadmap bem definido, o sistema está preparado para crescer e evoluir conforme as demandas do negócio.

### Próximos Passos

1. **Finalizar v2.1.0** com histórico e promoções
2. **Implementar testes** para todas as funcionalidades
3. **Otimizar performance** baseado em métricas
4. **Coletar feedback** dos usuários para melhorias