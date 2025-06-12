---
sidebar_position: 4
---

# Funcionalidades

Explore todas as funcionalidades disponíveis no PDV Restaurant

## 🏠 Interface Principal

### Design Moderno
- **Tema Dark Profissional**: Interface elegante baseada no Fluent UI
- **Layout Responsivo**: Adapta-se automaticamente a diferentes tamanhos de tela
- **Navegação Intuitiva**: Sidebar moderna com acesso rápido às funcionalidades
- **Animações Suaves**: Transições fluidas entre telas e estados

### Componentes Visuais
- **Cards Modernos**: Bordas arredondadas com sombras sutis
- **Botões Interativos**: Estados hover, pressed e disabled
- **Feedback Visual**: Indicadores de carregamento e confirmação
- **Tipografia Hierárquica**: Textos bem organizados e legíveis

## 🛍️ Catálogo de Produtos

### Organização por Categorias
O sistema organiza produtos em categorias bem definidas:

- **🍔 Hambúrguers**: Variedade completa de hambúrguers artesanais
- **🍕 Pizzas**: Pizzas tradicionais e especiais
- **🥤 Bebidas**: Refrigerantes, sucos e bebidas especiais
- **🍰 Sobremesas**: Doces e sobremesas da casa

### Visualização de Produtos
```dart
// Exemplo de estrutura de produto
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final bool isAvailable;
}
```

### Funcionalidades do Catálogo
- **Cards Visuais**: Cada produto é apresentado em um card atrativo
- **Imagens de Alta Qualidade**: Fotos profissionais dos produtos
- **Informações Completas**: Nome, descrição, preço e disponibilidade
- **Busca em Tempo Real**: Encontre produtos rapidamente
- **Filtros por Categoria**: Navegação facilitada entre categorias

### Sistema de Busca
```dart
// Implementação da busca
class ProductSearchDelegate extends SearchDelegate<Product?> {
  @override
  Widget buildResults(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final filteredProducts = ref.watch(
          productsProvider.select((state) => 
            state.products.where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase())
            ).toList()
          )
        );
        
        return ProductGrid(products: filteredProducts);
      },
    );
  }
}
```

## 🛒 Carrinho de Compras

### Interface do Carrinho
- **Painel Lateral**: Sempre visível e acessível
- **Lista de Itens**: Visualização clara dos produtos selecionados
- **Controles de Quantidade**: Botões + e - para ajustar quantidades
- **Cálculos Automáticos**: Subtotal, impostos e total atualizados em tempo real

### Funcionalidades Principais

#### Adição de Produtos
```dart
// Adicionar produto ao carrinho
void addToCart(Product product) {
  final cartItem = CartItem(
    product: product,
    quantity: 1,
    unitPrice: product.price,
  );
  
  ref.read(cartProvider.notifier).addItem(cartItem);
}
```

#### Gerenciamento de Quantidades
```dart
// Atualizar quantidade
void updateQuantity(String productId, int newQuantity) {
  if (newQuantity <= 0) {
    ref.read(cartProvider.notifier).removeItem(productId);
  } else {
    ref.read(cartProvider.notifier).updateQuantity(productId, newQuantity);
  }
}
```

#### Cálculos Automáticos
```dart
class CartCalculations {
  static double calculateSubtotal(List<CartItem> items) {
    return items.fold(0.0, (total, item) => 
      total + (item.unitPrice * item.quantity)
    );
  }
  
  static double calculateTax(double subtotal, double taxRate) {
    return subtotal * taxRate;
  }
  
  static double calculateTotal(double subtotal, double tax) {
    return subtotal + tax;
  }
}
```

### Persistência Local
- **Armazenamento Offline**: Carrinho salvo automaticamente
- **Recuperação de Sessão**: Itens mantidos entre sessões
- **Sincronização**: Estado consistente em toda a aplicação

## 🎨 Sistema de Design

### Paleta de Cores
```dart
class AppColors {
  // Cores principais
  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color primaryAccent = Color(0xFFFF8A65);
  static const Color secondaryAccent = Color(0xFF4FC3F7);
  static const Color success = Color(0xFF4CAF50);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
}
```

### Componentes Reutilizáveis

#### Botões Personalizados
```dart
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonStyle style;
  
  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.style = ButtonStyle.primary,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: _getButtonStyle(style),
      child: Text(text),
    );
  }
}
```

#### Cards de Produto
```dart
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do produto
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                product.imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            // Informações do produto
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    product.description,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'R\$ ${product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.primaryAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 🧭 Sistema de Navegação

### Estrutura de Navegação
```dart
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = 
      GlobalKey<NavigatorState>();
  
  static void navigateToProducts() {
    navigatorKey.currentState?.pushNamed('/products');
  }
  
  static void navigateToCart() {
    navigatorKey.currentState?.pushNamed('/cart');
  }
  
  static void navigateToSettings() {
    navigatorKey.currentState?.pushNamed('/settings');
  }
}
```

### Sidebar Moderna
- **Ícones Intuitivos**: Representação visual clara das funcionalidades
- **Estados Ativos**: Indicação visual da seção atual
- **Transições Suaves**: Animações entre mudanças de estado
- **Responsividade**: Adaptação para diferentes tamanhos de tela

## 📊 Gerenciamento de Estado

### Riverpod Providers
```dart
// Provider para produtos
final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>(
  (ref) => ProductsNotifier(ref.read(productRepositoryProvider)),
);

// Provider para carrinho
final cartProvider = StateNotifierProvider<CartNotifier, CartState>(
  (ref) => CartNotifier(ref.read(cartRepositoryProvider)),
);

// Provider para navegação
final navigationProvider = StateNotifierProvider<NavigationNotifier, int>(
  (ref) => NavigationNotifier(),
);
```

### Estados da Aplicação
```dart
// Estado dos produtos
abstract class ProductsState {}
class ProductsInitial extends ProductsState {}
class ProductsLoading extends ProductsState {}
class ProductsLoaded extends ProductsState {
  final List<Product> products;
  ProductsLoaded(this.products);
}
class ProductsError extends ProductsState {
  final String message;
  ProductsError(this.message);
}

// Estado do carrinho
class CartState {
  final List<CartItem> items;
  final double subtotal;
  final double tax;
  final double total;
  
  CartState({
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
  });
}
```

## 💾 Persistência de Dados

### Configuração do Hive
```dart
// Inicialização do Hive
Future<void> initializeStorage() async {
  await Hive.initFlutter();
  
  // Registrar adapters
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(CartItemAdapter());
  
  // Abrir boxes
  await Hive.openBox<Product>('products');
  await Hive.openBox<CartItem>('cart');
}
```

### Modelos de Dados
```dart
@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final double price;
  
  @HiveField(4)
  final String category;
  
  @HiveField(5)
  final String imageUrl;
  
  @HiveField(6)
  final bool isAvailable;
  
  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.isAvailable,
  });
}
```

## 🔄 Funcionalidades Futuras

### Versão 2.1.0 - Processamento de Vendas
- ✅ **Finalização de Pedidos**: Processo completo de checkout
- ✅ **Métodos de Pagamento**: Dinheiro, cartão, PIX
- ✅ **Impressão de Cupons**: Comprovantes de venda
- ✅ **Histórico de Vendas**: Registro de todas as transações

### Versão 2.2.0 - Gestão Avançada
- 📊 **Relatórios Detalhados**: Analytics de vendas e produtos
- 📦 **Gestão de Estoque**: Controle de inventário
- 🎯 **Sistema de Promoções**: Descontos e ofertas especiais
- 📈 **Dashboard Gerencial**: Visão executiva do negócio

### Versão 2.3.0 - Integração
- 🌐 **API Backend**: Sincronização com servidor
- 📱 **Multi-device**: Sincronização entre dispositivos
- 🚚 **Integração com Delivery**: Pedidos online
- 👥 **Sistema de Usuários**: Controle de acesso e permissões

## 🎯 Benefícios das Funcionalidades

### Para Operadores
- **Interface Intuitiva**: Fácil aprendizado e uso
- **Rapidez**: Operações ágeis durante picos de movimento
- **Confiabilidade**: Sistema estável e responsivo
- **Flexibilidade**: Adaptação a diferentes fluxos de trabalho

### Para Gestores
- **Visibilidade**: Acompanhamento em tempo real
- **Controle**: Gestão completa do catálogo
- **Insights**: Dados para tomada de decisão
- **Escalabilidade**: Crescimento sem limitações técnicas

### Para Clientes
- **Experiência Moderna**: Interface atrativa e profissional
- **Agilidade**: Atendimento mais rápido
- **Precisão**: Pedidos corretos e completos
- **Satisfação**: Experiência de compra aprimorada