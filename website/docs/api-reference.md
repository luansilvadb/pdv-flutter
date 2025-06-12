---
sidebar_position: 5
---

# API Reference

Documentação técnica completa das APIs e interfaces do PDV Restaurant

## 📦 Core APIs

### Product API

#### Product Entity
```dart
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    this.isAvailable = true,
    required this.createdAt,
    required this.updatedAt,
  });

  // Métodos de conveniência
  bool get isFood => ['burgers', 'pizzas', 'desserts'].contains(category);
  bool get isDrink => category == 'drinks';
  String get formattedPrice => 'R\$ ${price.toStringAsFixed(2)}';
}
```

#### ProductRepository Interface
```dart
abstract class ProductRepository {
  /// Retorna todos os produtos disponíveis
  Future<Either<Failure, List<Product>>> getProducts();
  
  /// Retorna um produto específico por ID
  Future<Either<Failure, Product>> getProductById(String id);
  
  /// Retorna produtos filtrados por categoria
  Future<Either<Failure, List<Product>>> getProductsByCategory(String category);
  
  /// Busca produtos por nome ou descrição
  Future<Either<Failure, List<Product>>> searchProducts(String query);
  
  /// Adiciona um novo produto
  Future<Either<Failure, Product>> addProduct(Product product);
  
  /// Atualiza um produto existente
  Future<Either<Failure, Product>> updateProduct(Product product);
  
  /// Remove um produto
  Future<Either<Failure, void>> deleteProduct(String id);
}
```

#### Use Cases

##### GetProductsUseCase
```dart
class GetProductsUseCase {
  final ProductRepository repository;
  
  GetProductsUseCase(this.repository);
  
  /// Executa o caso de uso para obter produtos
  /// 
  /// Returns:
  ///   Either<Failure, List<Product>> - Lista de produtos ou falha
  Future<Either<Failure, List<Product>>> call() async {
    return await repository.getProducts();
  }
}
```

##### SearchProductsUseCase
```dart
class SearchProductsUseCase {
  final ProductRepository repository;
  
  SearchProductsUseCase(this.repository);
  
  /// Busca produtos por query
  /// 
  /// Parameters:
  ///   query: String - Termo de busca
  /// 
  /// Returns:
  ///   Either<Failure, List<Product>> - Produtos encontrados ou falha
  Future<Either<Failure, List<Product>>> call(String query) async {
    if (query.trim().isEmpty) {
      return const Right([]);
    }
    
    return await repository.searchProducts(query);
  }
}
```

### Cart API

#### CartItem Entity
```dart
class CartItem {
  final String id;
  final Product product;
  final int quantity;
  final double unitPrice;
  final DateTime addedAt;
  final String? notes;

  const CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.unitPrice,
    required this.addedAt,
    this.notes,
  });

  // Métodos calculados
  double get totalPrice => unitPrice * quantity;
  bool get isValid => quantity > 0 && unitPrice > 0;
}
```

#### CartRepository Interface
```dart
abstract class CartRepository {
  /// Retorna todos os itens do carrinho
  Future<Either<Failure, List<CartItem>>> getCartItems();
  
  /// Adiciona um item ao carrinho
  Future<Either<Failure, CartItem>> addItem(CartItem item);
  
  /// Atualiza a quantidade de um item
  Future<Either<Failure, CartItem>> updateItemQuantity(String itemId, int quantity);
  
  /// Remove um item do carrinho
  Future<Either<Failure, void>> removeItem(String itemId);
  
  /// Limpa todo o carrinho
  Future<Either<Failure, void>> clearCart();
  
  /// Calcula o total do carrinho
  Future<Either<Failure, CartSummary>> getCartSummary();
}
```

#### CartSummary Entity
```dart
class CartSummary {
  final List<CartItem> items;
  final int totalItems;
  final double subtotal;
  final double taxAmount;
  final double discountAmount;
  final double totalAmount;
  final DateTime calculatedAt;

  const CartSummary({
    required this.items,
    required this.totalItems,
    required this.subtotal,
    required this.taxAmount,
    required this.discountAmount,
    required this.totalAmount,
    required this.calculatedAt,
  });

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
}
```

## 🎯 State Management APIs

### ProductsProvider
```dart
final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>(
  (ref) => ProductsNotifier(
    ref.read(getProductsUseCaseProvider),
    ref.read(searchProductsUseCaseProvider),
  ),
);

class ProductsNotifier extends StateNotifier<ProductsState> {
  final GetProductsUseCase getProductsUseCase;
  final SearchProductsUseCase searchProductsUseCase;
  
  ProductsNotifier(this.getProductsUseCase, this.searchProductsUseCase) 
      : super(const ProductsState.initial());

  /// Carrega todos os produtos
  Future<void> loadProducts() async {
    state = const ProductsState.loading();
    
    final result = await getProductsUseCase();
    
    result.fold(
      (failure) => state = ProductsState.error(failure.message),
      (products) => state = ProductsState.loaded(products),
    );
  }

  /// Busca produtos por query
  Future<void> searchProducts(String query) async {
    if (query.trim().isEmpty) {
      await loadProducts();
      return;
    }
    
    state = const ProductsState.loading();
    
    final result = await searchProductsUseCase(query);
    
    result.fold(
      (failure) => state = ProductsState.error(failure.message),
      (products) => state = ProductsState.loaded(products),
    );
  }

  /// Filtra produtos por categoria
  void filterByCategory(String? category) {
    state.maybeWhen(
      loaded: (products) {
        if (category == null) {
          state = ProductsState.loaded(products);
        } else {
          final filtered = products
              .where((product) => product.category == category)
              .toList();
          state = ProductsState.loaded(filtered);
        }
      },
      orElse: () {},
    );
  }
}
```

### CartProvider
```dart
final cartProvider = StateNotifierProvider<CartNotifier, CartState>(
  (ref) => CartNotifier(
    ref.read(addToCartUseCaseProvider),
    ref.read(removeFromCartUseCaseProvider),
    ref.read(updateCartItemUseCaseProvider),
    ref.read(getCartSummaryUseCaseProvider),
  ),
);

class CartNotifier extends StateNotifier<CartState> {
  final AddToCartUseCase addToCartUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final UpdateCartItemUseCase updateCartItemUseCase;
  final GetCartSummaryUseCase getCartSummaryUseCase;
  
  CartNotifier(
    this.addToCartUseCase,
    this.removeFromCartUseCase,
    this.updateCartItemUseCase,
    this.getCartSummaryUseCase,
  ) : super(const CartState.initial());

  /// Adiciona produto ao carrinho
  Future<void> addProduct(Product product, {int quantity = 1}) async {
    final cartItem = CartItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      product: product,
      quantity: quantity,
      unitPrice: product.price,
      addedAt: DateTime.now(),
    );
    
    final result = await addToCartUseCase(cartItem);
    
    result.fold(
      (failure) => state = CartState.error(failure.message),
      (_) => _refreshCart(),
    );
  }

  /// Remove produto do carrinho
  Future<void> removeProduct(String itemId) async {
    final result = await removeFromCartUseCase(itemId);
    
    result.fold(
      (failure) => state = CartState.error(failure.message),
      (_) => _refreshCart(),
    );
  }

  /// Atualiza quantidade do item
  Future<void> updateQuantity(String itemId, int quantity) async {
    if (quantity <= 0) {
      await removeProduct(itemId);
      return;
    }
    
    final result = await updateCartItemUseCase(itemId, quantity);
    
    result.fold(
      (failure) => state = CartState.error(failure.message),
      (_) => _refreshCart(),
    );
  }

  /// Atualiza o estado do carrinho
  Future<void> _refreshCart() async {
    final result = await getCartSummaryUseCase();
    
    result.fold(
      (failure) => state = CartState.error(failure.message),
      (summary) => state = CartState.loaded(summary),
    );
  }
}
```

## 🔧 Utility APIs

### Storage Service
```dart
abstract class StorageService {
  /// Inicializa o serviço de storage
  Future<void> initialize();
  
  /// Salva dados no storage
  Future<void> save<T>(String key, T data);
  
  /// Recupera dados do storage
  Future<T?> get<T>(String key);
  
  /// Remove dados do storage
  Future<void> remove(String key);
  
  /// Limpa todo o storage
  Future<void> clear();
  
  /// Verifica se uma chave existe
  Future<bool> containsKey(String key);
}

class HiveStorageService implements StorageService {
  late Box _box;
  
  @override
  Future<void> initialize() async {
    await Hive.initFlutter();
    _box = await Hive.openBox('app_storage');
  }
  
  @override
  Future<void> save<T>(String key, T data) async {
    await _box.put(key, data);
  }
  
  @override
  Future<T?> get<T>(String key) async {
    return _box.get(key) as T?;
  }
  
  @override
  Future<void> remove(String key) async {
    await _box.delete(key);
  }
  
  @override
  Future<void> clear() async {
    await _box.clear();
  }
  
  @override
  Future<bool> containsKey(String key) async {
    return _box.containsKey(key);
  }
}
```

### Navigation Service
```dart
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = 
      GlobalKey<NavigatorState>();
  
  /// Navega para uma rota específica
  static Future<T?> navigateTo<T>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }
  
  /// Substitui a rota atual
  static Future<T?> navigateAndReplace<T>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushReplacementNamed<T>(
      routeName,
      arguments: arguments,
    );
  }
  
  /// Volta para a tela anterior
  static void goBack<T>([T? result]) {
    return navigatorKey.currentState!.pop<T>(result);
  }
  
  /// Navega para a rota e remove todas as anteriores
  static Future<T?> navigateAndClearStack<T>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil<T>(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }
}
```

## 🎨 Widget APIs

### CustomButton
```dart
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final Widget? icon;
  final bool isLoading;
  final bool isFullWidth;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: _getHeight(),
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: _getButtonStyle(),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 8),
                  ],
                  Text(text),
                ],
              ),
      ),
    );
  }

  double _getHeight() {
    switch (size) {
      case ButtonSize.small:
        return 32;
      case ButtonSize.medium:
        return 40;
      case ButtonSize.large:
        return 48;
    }
  }

  ButtonStyle _getButtonStyle() {
    // Implementação dos estilos baseados no variant
    // ...
  }
}

enum ButtonVariant { primary, secondary, outline, ghost }
enum ButtonSize { small, medium, large }
```

### ProductCard
```dart
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final bool showAddButton;

  const ProductCard({
    Key? key,
    required this.product,
    this.onTap,
    this.onAddToCart,
    this.showAddButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            _buildContent(context),
            if (showAddButton) _buildAddButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Image.asset(
          product.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: const Icon(Icons.image_not_supported),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: Theme.of(context).textTheme.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            product.description,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            product.formattedPrice,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        width: double.infinity,
        child: CustomButton(
          text: 'Adicionar',
          onPressed: product.isAvailable ? onAddToCart : null,
          variant: ButtonVariant.primary,
          size: ButtonSize.small,
          icon: const Icon(Icons.add_shopping_cart, size: 16),
        ),
      ),
    );
  }
}
```

## 🔍 Error Handling

### Failure Classes
```dart
abstract class Failure {
  final String message;
  final String? code;
  final dynamic details;

  const Failure(this.message, {this.code, this.details});
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error occurred']) 
      : super(message, code: 'CACHE_ERROR');
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Network error occurred']) 
      : super(message, code: 'NETWORK_ERROR');
}

class ValidationFailure extends Failure {
  const ValidationFailure([String message = 'Validation error occurred']) 
      : super(message, code: 'VALIDATION_ERROR');
}

class UnknownFailure extends Failure {
  const UnknownFailure([String message = 'Unknown error occurred']) 
      : super(message, code: 'UNKNOWN_ERROR');
}
```

### Error Handler
```dart
class ErrorHandler {
  static String getErrorMessage(Failure failure) {
    switch (failure.runtimeType) {
      case CacheFailure:
        return 'Erro ao acessar dados locais';
      case NetworkFailure:
        return 'Erro de conexão. Verifique sua internet';
      case ValidationFailure:
        return 'Dados inválidos fornecidos';
      default:
        return 'Erro inesperado. Tente novamente';
    }
  }

  static void showError(BuildContext context, Failure failure) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(getErrorMessage(failure)),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
```

## 📱 Platform APIs

### Platform Service
```dart
abstract class PlatformService {
  bool get isWeb;
  bool get isMobile;
  bool get isDesktop;
  bool get isAndroid;
  bool get isIOS;
  bool get isWindows;
  bool get isMacOS;
  bool get isLinux;
}

class PlatformServiceImpl implements PlatformService {
  @override
  bool get isWeb => kIsWeb;
  
  @override
  bool get isMobile => Platform.isAndroid || Platform.isIOS;
  
  @override
  bool get isDesktop => Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  
  @override
  bool get isAndroid => Platform.isAndroid;
  
  @override
  bool get isIOS => Platform.isIOS;
  
  @override
  bool get isWindows => Platform.isWindows;
  
  @override
  bool get isMacOS => Platform.isMacOS;
  
  @override
  bool get isLinux => Platform.isLinux;
}
```

## 🧪 Testing APIs

### Test Helpers
```dart
class TestHelpers {
  /// Cria um produto de teste
  static Product createTestProduct({
    String? id,
    String? name,
    double? price,
    String? category,
  }) {
    return Product(
      id: id ?? 'test-product-1',
      name: name ?? 'Test Product',
      description: 'Test product description',
      price: price ?? 10.99,
      category: category ?? 'burgers',
      imageUrl: 'assets/images/test-product.jpg',
      isAvailable: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Cria um item de carrinho de teste
  static CartItem createTestCartItem({
    Product? product,
    int? quantity,
  }) {
    return CartItem(
      id: 'test-cart-item-1',
      product: product ?? createTestProduct(),
      quantity: quantity ?? 1,
      unitPrice: product?.price ?? 10.99,
      addedAt: DateTime.now(),
    );
  }

  /// Cria um widget de teste com providers
  static Widget createTestWidget(Widget child) {
    return ProviderScope(
      overrides: [
        // Override providers para testes
      ],
      child: MaterialApp(
        home: child,
      ),
    );
  }
}
```

Esta documentação de API fornece uma referência completa para desenvolvedores que trabalham com o PDV Restaurant, incluindo todas as interfaces, classes e métodos principais do sistema.