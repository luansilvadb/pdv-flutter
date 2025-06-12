---
layout: default
title: API Reference
nav_order: 5
description: "Referência completa da API e componentes do PDV Restaurant"
---

# API Reference
{: .no_toc }

Documentação completa da API, componentes e interfaces do PDV Restaurant.
{: .fs-6 .fw-300 }

## Índice
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Core APIs

### AppConstants

Constantes centrais da aplicação.

```dart
class AppConstants {
  // Informações da aplicação
  static const String appName = 'Lorem Restaurant';
  static const String appVersion = '2.0.0';
  static const String searchPlaceholder = 'Search menu here...';
  
  // Configurações de negócio
  static const double taxRate = 0.10; // 10%
  static const int maxCartItems = 50;
  static const Duration animationDuration = Duration(milliseconds: 300);
  
  // Navegação
  static const List<String> navigationItems = [
    'Home', 'Menu', 'History', 'Promos', 'Settings'
  ];
}
```

### AppColors

Paleta de cores do design system.

```dart
class AppColors {
  // Cores principais
  static const Color primaryAccent = Color(0xFFFF8A65);
  static const Color primaryAccentHover = Color(0xFFFF7043);
  static const Color primaryAccentPressed = Color(0xFFFF5722);
  static const Color secondaryAccent = Color(0xFF4FC3F7);
  
  // Backgrounds
  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color surfaceVariant = Color(0xFF2A2A2A);
  static const Color surfaceElevated = Color(0xFF242424);
  
  // Texto
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFE0E0E0);
  static const Color textTertiary = Color(0xFFBDBDBD);
  
  // Estados
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
}
```

### AppSizes

Dimensões e tamanhos padronizados.

```dart
class AppSizes {
  // Padding
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  // Border radius
  static const double radiusSmall = 6.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 20.0;
  
  // Componentes
  static const double productCardHeight = 220.0;
  static const double productCardWidth = 190.0;
  static const double sidebarWidth = 260.0;
  static const double cartPanelWidth = 320.0;
  
  // Ícones
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
}
```

---

## Domain Entities

### ProductEntity

Entidade principal de produto.

```dart
class ProductEntity extends Entity {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String categoryId;
  final bool isAvailable;
  final int availableQuantity;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categoryId,
    required this.isAvailable,
    required this.availableQuantity,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();
  
  // Getters computados
  Money get priceAsMoney => Money(price);
  Quantity get quantityAsQuantity => Quantity(availableQuantity);
  bool get isLowStock => availableQuantity <= 5 && availableQuantity > 0;
  bool get isOutOfStock => availableQuantity == 0;
  String get formattedPrice => priceAsMoney.formatted;
  
  // Métodos de negócio
  ProductEntity copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? categoryId,
    bool? isAvailable,
    int? availableQuantity,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  
  ProductEntity updateQuantity(int newQuantity);
  ProductEntity decrementQuantity(int amount);
  ProductEntity incrementQuantity(int amount);
}
```

### CartEntity

Entidade do carrinho de compras.

```dart
class CartEntity extends Entity {
  final String id;
  final List<CartItemEntity> items;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  CartEntity({
    required this.id,
    required this.items,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();
  
  // Cálculos
  double get subtotal => items.fold(0, (sum, item) => sum + item.total);
  double get tax => subtotal * AppConstants.taxRate;
  double get total => subtotal + tax;
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  
  // Estados
  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
  bool get isAtMaxCapacity => totalItems >= AppConstants.maxCartItems;
  
  // Formatação
  String get formattedSubtotal => Money(subtotal).formatted;
  String get formattedTax => Money(tax).formatted;
  String get formattedTotal => Money(total).formatted;
  
  // Métodos de negócio
  CartEntity addItem(CartItemEntity item);
  CartEntity removeItem(String itemId);
  CartEntity updateItemQuantity(String itemId, int quantity);
  CartEntity clear();
  CartItemEntity? findItem(String productId);
  bool hasItem(String productId);
}
```

### CartItemEntity

Item individual do carrinho.

```dart
class CartItemEntity extends Entity {
  final String id;
  final ProductEntity product;
  final int quantity;
  final DateTime addedAt;
  
  CartItemEntity({
    required this.id,
    required this.product,
    required this.quantity,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();
  
  // Cálculos
  double get unitPrice => product.price;
  double get total => unitPrice * quantity;
  
  // Formatação
  String get formattedUnitPrice => Money(unitPrice).formatted;
  String get formattedTotal => Money(total).formatted;
  
  // Validações
  bool get isValidQuantity => quantity > 0 && quantity <= product.availableQuantity;
  
  // Métodos
  CartItemEntity copyWith({
    String? id,
    ProductEntity? product,
    int? quantity,
    DateTime? addedAt,
  });
  
  CartItemEntity updateQuantity(int newQuantity);
}
```

### CategoryEntity

Entidade de categoria de produtos.

```dart
class CategoryEntity extends Entity {
  final String id;
  final String name;
  final String description;
  final String iconPath;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  CategoryEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();
}
```

---

## Use Cases

### Product Use Cases

#### GetAvailableProducts

Obtém lista de produtos disponíveis.

```dart
class GetAvailableProducts {
  final ProductRepository repository;
  
  GetAvailableProducts(this.repository);
  
  Future<Either<Failure, List<ProductEntity>>> call() async {
    return await repository.getAvailableProducts();
  }
}
```

#### SearchProducts

Busca produtos por termo.

```dart
class SearchProducts {
  final ProductRepository repository;
  
  SearchProducts(this.repository);
  
  Future<Either<Failure, List<ProductEntity>>> call(String query) async {
    if (query.trim().isEmpty) {
      return Left(InvalidInputFailure('Query cannot be empty'));
    }
    
    return await repository.searchProducts(query);
  }
}
```

#### FilterProductsByCategory

Filtra produtos por categoria.

```dart
class FilterProductsByCategory {
  final ProductRepository repository;
  
  FilterProductsByCategory(this.repository);
  
  Future<Either<Failure, List<ProductEntity>>> call(String categoryId) async {
    return await repository.getProductsByCategory(categoryId);
  }
}
```

### Cart Use Cases

#### AddToCart

Adiciona produto ao carrinho.

```dart
class AddToCart {
  final CartRepository repository;
  
  AddToCart(this.repository);
  
  Future<Either<Failure, CartEntity>> call(
    String productId,
    int quantity,
  ) async {
    // Validações
    if (quantity <= 0) {
      return Left(InvalidInputFailure('Quantity must be positive'));
    }
    
    final cartResult = await repository.getCart();
    return cartResult.fold(
      (failure) => Left(failure),
      (cart) async {
        if (cart.isAtMaxCapacity) {
          return Left(BusinessLogicFailure('Cart is at maximum capacity'));
        }
        
        final updatedCart = cart.addItem(CartItemEntity(
          id: generateId(),
          product: product,
          quantity: quantity,
        ));
        
        return await repository.saveCart(updatedCart);
      },
    );
  }
}
```

#### RemoveFromCart

Remove item do carrinho.

```dart
class RemoveFromCart {
  final CartRepository repository;
  
  RemoveFromCart(this.repository);
  
  Future<Either<Failure, CartEntity>> call(String itemId) async {
    final cartResult = await repository.getCart();
    return cartResult.fold(
      (failure) => Left(failure),
      (cart) async {
        final updatedCart = cart.removeItem(itemId);
        return await repository.saveCart(updatedCart);
      },
    );
  }
}
```

#### UpdateCartItemQuantity

Atualiza quantidade de item no carrinho.

```dart
class UpdateCartItemQuantity {
  final CartRepository repository;
  
  UpdateCartItemQuantity(this.repository);
  
  Future<Either<Failure, CartEntity>> call(
    String itemId,
    int newQuantity,
  ) async {
    if (newQuantity < 0) {
      return Left(InvalidInputFailure('Quantity cannot be negative'));
    }
    
    final cartResult = await repository.getCart();
    return cartResult.fold(
      (failure) => Left(failure),
      (cart) async {
        if (newQuantity == 0) {
          final updatedCart = cart.removeItem(itemId);
          return await repository.saveCart(updatedCart);
        } else {
          final updatedCart = cart.updateItemQuantity(itemId, newQuantity);
          return await repository.saveCart(updatedCart);
        }
      },
    );
  }
}
```

#### ClearCart

Limpa o carrinho completamente.

```dart
class ClearCart {
  final CartRepository repository;
  
  ClearCart(this.repository);
  
  Future<Either<Failure, void>> call() async {
    return await repository.clearCart();
  }
}
```

---

## Repository Interfaces

### ProductRepository

Interface para operações de produtos.

```dart
abstract class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> getAvailableProducts();
  Future<Either<Failure, List<ProductEntity>>> searchProducts(String query);
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(String categoryId);
  Future<Either<Failure, ProductEntity?>> getProductById(String id);
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
}
```

### CartRepository

Interface para operações do carrinho.

```dart
abstract class CartRepository {
  Future<Either<Failure, CartEntity>> getCart();
  Future<Either<Failure, CartEntity>> saveCart(CartEntity cart);
  Future<Either<Failure, void>> clearCart();
  Stream<CartEntity> watchCart();
}
```

---

## State Management

### Riverpod Providers

#### Products Providers

```dart
// Provider do repositório
final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => getIt<ProductRepository>(),
);

// Provider dos use cases
final getAvailableProductsProvider = Provider<GetAvailableProducts>(
  (ref) => GetAvailableProducts(ref.read(productRepositoryProvider)),
);

final searchProductsProvider = Provider<SearchProducts>(
  (ref) => SearchProducts(ref.read(productRepositoryProvider)),
);

// Provider do estado dos produtos
final productsProvider = StateNotifierProvider<ProductsNotifier, AsyncValue<List<ProductEntity>>>(
  (ref) => ProductsNotifier(
    getAvailableProducts: ref.read(getAvailableProductsProvider),
    searchProducts: ref.read(searchProductsProvider),
  ),
);

// Provider de busca
final searchQueryProvider = StateProvider<String>((ref) => '');

// Provider de filtro por categoria
final categoryFilterProvider = StateProvider<String?>((ref) => null);

// Provider de produtos filtrados
final filteredProductsProvider = Provider<AsyncValue<List<ProductEntity>>>((ref) {
  final productsAsync = ref.watch(productsProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  final categoryFilter = ref.watch(categoryFilterProvider);
  
  return productsAsync.when(
    data: (products) {
      final filtered = products.where((product) {
        final matchesSearch = searchQuery.isEmpty || 
            product.name.toLowerCase().contains(searchQuery.toLowerCase());
        final matchesCategory = categoryFilter == null || 
            product.categoryId == categoryFilter;
        return matchesSearch && matchesCategory;
      }).toList();
      
      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});
```

#### Cart Providers

```dart
// Provider do repositório
final cartRepositoryProvider = Provider<CartRepository>(
  (ref) => getIt<CartRepository>(),
);

// Provider dos use cases
final addToCartProvider = Provider<AddToCart>(
  (ref) => AddToCart(ref.read(cartRepositoryProvider)),
);

final removeFromCartProvider = Provider<RemoveFromCart>(
  (ref) => RemoveFromCart(ref.read(cartRepositoryProvider)),
);

final updateCartItemQuantityProvider = Provider<UpdateCartItemQuantity>(
  (ref) => UpdateCartItemQuantity(ref.read(cartRepositoryProvider)),
);

final clearCartProvider = Provider<ClearCart>(
  (ref) => ClearCart(ref.read(cartRepositoryProvider)),
);

// Provider do estado do carrinho
final cartProvider = StateNotifierProvider<CartNotifier, AsyncValue<CartEntity>>(
  (ref) => CartNotifier(
    addToCart: ref.read(addToCartProvider),
    removeFromCart: ref.read(removeFromCartProvider),
    updateQuantity: ref.read(updateCartItemQuantityProvider),
    clearCart: ref.read(clearCartProvider),
    repository: ref.read(cartRepositoryProvider),
  ),
);

// Provider de contagem de itens
final cartItemCountProvider = Provider<int>((ref) {
  final cartAsync = ref.watch(cartProvider);
  return cartAsync.when(
    data: (cart) => cart.totalItems,
    loading: () => 0,
    error: (_, __) => 0,
  );
});

// Provider do total do carrinho
final cartTotalProvider = Provider<String>((ref) {
  final cartAsync = ref.watch(cartProvider);
  return cartAsync.when(
    data: (cart) => cart.formattedTotal,
    loading: () => 'R\$ 0,00',
    error: (_, __) => 'R\$ 0,00',
  );
});
```

#### Navigation Providers

```dart
// Estado da navegação
class NavigationState extends Equatable {
  final int selectedIndex;
  
  const NavigationState({required this.selectedIndex});
  
  NavigationState copyWith({int? selectedIndex}) {
    return NavigationState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
  
  @override
  List<Object> get props => [selectedIndex];
}

// Notifier da navegação
class NavigationNotifier extends StateNotifier<NavigationState> {
  NavigationNotifier() : super(const NavigationState(selectedIndex: 0));
  
  void setSelectedIndex(int index) {
    if (index >= 0 && index < AppConstants.navigationItems.length) {
      state = state.copyWith(selectedIndex: index);
    }
  }
  
  void navigateToHome() => setSelectedIndex(0);
  void navigateToMenu() => setSelectedIndex(1);
  void navigateToHistory() => setSelectedIndex(2);
  void navigateToPromos() => setSelectedIndex(3);
  void navigateToSettings() => setSelectedIndex(4);
}

// Provider da navegação
final navigationProvider = StateNotifierProvider<NavigationNotifier, NavigationState>(
  (ref) => NavigationNotifier(),
);
```

---

## Value Objects

### Money

Objeto de valor para representar valores monetários.

```dart
class Money extends ValueObject<double> {
  @override
  final double value;
  
  const Money._(this.value);
  
  factory Money(double input) {
    if (input < 0) {
      throw ArgumentError('Money cannot be negative');
    }
    return Money._(input);
  }
  
  factory Money.zero() => const Money._(0.0);
  
  String get formatted => NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
  ).format(value);
  
  Money operator +(Money other) => Money(value + other.value);
  Money operator -(Money other) => Money((value - other.value).clamp(0, double.infinity));
  Money operator *(double multiplier) => Money(value * multiplier);
  
  bool operator >(Money other) => value > other.value;
  bool operator <(Money other) => value < other.value;
  bool operator >=(Money other) => value >= other.value;
  bool operator <=(Money other) => value <= other.value;
}
```

### Quantity

Objeto de valor para representar quantidades.

```dart
class Quantity extends ValueObject<int> {
  @override
  final int value;
  
  const Quantity._(this.value);
  
  factory Quantity(int input) {
    if (input < 0) {
      throw ArgumentError('Quantity cannot be negative');
    }
    return Quantity._(input);
  }
  
  factory Quantity.zero() => const Quantity._(0);
  factory Quantity.one() => const Quantity._(1);
  
  bool get isZero => value == 0;
  bool get isPositive => value > 0;
  
  Quantity operator +(Quantity other) => Quantity(value + other.value);
  Quantity operator -(Quantity other) => Quantity((value - other.value).clamp(0, value));
  
  bool operator >(Quantity other) => value > other.value;
  bool operator <(Quantity other) => value < other.value;
}
```

---

## Error Handling

### Failure Classes

```dart
abstract class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error occurred']) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error occurred']) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Network error occurred']) : super(message);
}

class InvalidInputFailure extends Failure {
  const InvalidInputFailure(String message) : super(message);
}

class BusinessLogicFailure extends Failure {
  const BusinessLogicFailure(String message) : super(message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([String message = 'Resource not found']) : super(message);
}
```

### Exception Classes

```dart
abstract class AppException implements Exception {
  final String message;
  
  const AppException(this.message);
}

class ServerException extends AppException {
  const ServerException([String message = 'Server exception']) : super(message);
}

class CacheException extends AppException {
  const CacheException([String message = 'Cache exception']) : super(message);
}

class NetworkException extends AppException {
  const NetworkException([String message = 'Network exception']) : super(message);
}
```

---

## Utilities

### ID Generator

```dart
class IdGenerator {
  static String generate() {
    return '${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}';
  }
  
  static String generateUuid() {
    return Uuid().v4();
  }
}
```

### Input Sanitizer

```dart
class InputSanitizer {
  static String sanitizeString(String input) {
    return input
        .trim()
        .replaceAll(RegExp(r'[<>\"\'%;()&+]'), '');
  }
  
  static double sanitizePrice(String input) {
    final cleaned = input.replaceAll(RegExp(r'[^\d.,]'), '');
    return double.tryParse(cleaned.replaceAll(',', '.')) ?? 0.0;
  }
  
  static int sanitizeQuantity(String input) {
    final cleaned = input.replaceAll(RegExp(r'[^\d]'), '');
    return int.tryParse(cleaned) ?? 0;
  }
}
```

### Logger Service

```dart
class LoggerService {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );
  
  static void debug(String message) => _logger.d(message);
  static void info(String message) => _logger.i(message);
  static void warning(String message) => _logger.w(message);
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error, stackTrace);
  }
}
```

---

## Testing Utilities

### Mock Factories

```dart
class MockProductFactory {
  static ProductEntity createProduct({
    String? id,
    String? name,
    double? price,
    String? categoryId,
    bool? isAvailable,
    int? availableQuantity,
  }) {
    return ProductEntity(
      id: id ?? 'test-product-1',
      name: name ?? 'Test Product',
      description: 'Test product description',
      price: price ?? 25.90,
      imageUrl: 'assets/images/test.png',
      categoryId: categoryId ?? 'test-category',
      isAvailable: isAvailable ?? true,
      availableQuantity: availableQuantity ?? 10,
    );
  }
  
  static List<ProductEntity> createProductList(int count) {
    return List.generate(count, (index) => createProduct(
      id: 'test-product-${index + 1}',
      name: 'Test Product ${index + 1}',
      price: 25.90 + index,
    ));
  }
}

class MockCartFactory {
  static CartEntity createEmptyCart() {
    return CartEntity(
      id: 'test-cart',
      items: [],
    );
  }
  
  static CartEntity createCartWithItems(List<ProductEntity> products) {
    final items = products.map((product) => CartItemEntity(
      id: 'item-${product.id}',
      product: product,
      quantity: 1,
    )).toList();
    
    return CartEntity(
      id: 'test-cart',
      items: items,
    );
  }
}
```

### Test Helpers

```dart
class TestHelpers {
  static Widget wrapWithProviders(Widget child) {
    return ProviderScope(
      child: MaterialApp(
        home: child,
      ),
    );
  }
  
  static Future<void> pumpAndSettle(WidgetTester tester, Widget widget) async {
    await tester.pumpWidget(wrapWithProviders(widget));
    await tester.pumpAndSettle();
  }
}
```

---

Esta documentação de API fornece uma referência completa para desenvolvedores que trabalham com o PDV Restaurant, incluindo todas as interfaces, classes e métodos disponíveis no sistema.