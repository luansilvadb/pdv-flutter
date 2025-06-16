import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/products/domain/entities/product_entity.dart';
import '../../features/products/presentation/providers/products_provider.dart';
import '../../features/cart/presentation/providers/cart_provider.dart';
import '../../features/cart/presentation/providers/cart_state.dart';
import '../../features/navigation/presentation/providers/navigation_provider.dart';
import '../performance/smart_cache.dart';

/// Providers altamente otimizados que reduzem rebuilds desnecessários
/// usando select() e memoização para máxima performance

// ===== PRODUTOS - PROVIDERS OTIMIZADOS =====

/// Provider que observa apenas mudanças na lista de produtos
/// Não rebuilda quando loading ou error mudam
final optimizedProductsListProvider = Provider<List<ProductEntity>>((ref) {
  return ref.watch(
    productsNotifierProvider.select((state) => state.products),
  );
});

/// Provider memoizado para produtos por categoria
final productsByCategoryMemoProvider = Provider.family<List<ProductEntity>, String?>((ref, categoryId) {
  final products = ref.watch(optimizedProductsListProvider);
  
  // Cache key único para esta categoria
  final cacheKey = 'products_category_$categoryId';
  
  // Tenta buscar do cache primeiro
  final cached = ProductCache.get<List<ProductEntity>>(cacheKey);
  if (cached != null && cached.isNotEmpty) {
    return cached;
  }
  
  // Filtra produtos
  final filtered = categoryId == null 
    ? products
    : products.where((p) => p.categoryId == categoryId).toList();
  
  // Salva no cache
  ProductCache.put(cacheKey, filtered);
  
  return filtered;
});

/// Provider para produtos disponíveis (em estoque)
final availableProductsOnlyProvider = Provider<List<ProductEntity>>((ref) {
  final products = ref.watch(optimizedProductsListProvider);
  
  // Memoização com cache
  const cacheKey = 'available_products';
  final cached = ProductCache.get<List<ProductEntity>>(cacheKey);
  
  if (cached != null) {
    // Verifica se a lista mudou comparando tamanhos
    if (cached.length == products.where((p) => p.isAvailable && p.availableQuantity > 0).length) {
      return cached;
    }
  }
  
  final available = products
      .where((product) => product.isAvailable && product.availableQuantity > 0)
      .toList();
  
  ProductCache.put(cacheKey, available);
  return available;
});

/// Provider para contagem de produtos por categoria (otimizado)
final productCountByCategoryProvider = Provider.family<int, String>((ref, categoryId) {
  // Observa apenas a lista de produtos, não o estado completo
  final products = ref.watch(optimizedProductsListProvider);
  
  return products.where((p) => p.categoryId == categoryId).length;
});

// ===== CARRINHO - PROVIDERS ULTRA OTIMIZADOS =====

/// Provider que observa apenas o estado do carrinho (loaded/loading/error)
final cartStateTypeProvider = Provider<Type>((ref) {
  return ref.watch(cartProvider.select((state) => state.runtimeType));
});

/// Provider otimizado para total do carrinho com memoização
final memoizedCartTotalProvider = Provider<double>((ref) {
  final cartState = ref.watch(cartProvider);
  
  if (cartState is! CartLoaded) return 0.0;
  
  // Cache baseado no hash dos itens
  final itemsHash = cartState.cart.items.map((i) => '${i.productId}_${i.quantity.value}').join('|');
  final cacheKey = 'cart_total_$itemsHash';
  
  return StateCache.get<double>(cacheKey) ?? (() {
    final total = cartState.cart.totalAmount;
    StateCache.put(cacheKey, total);
    return total;
  })();
});

/// Provider para informações específicas de item no carrinho
final cartItemInfoProvider = Provider.family<({int quantity, double subtotal})?, String>((ref, productId) {
  final cartState = ref.watch(cartProvider);
  
  if (cartState is! CartLoaded) return null;
  
  final item = cartState.cart.items.where((i) => i.productId == productId).firstOrNull;
  if (item == null) return null;
    return (
    quantity: item.quantity.value,
    subtotal: item.subtotal,
  );
});

/// Provider para verificar se produto está no carrinho (super otimizado)
final isProductInCartOptimizedProvider = Provider.family<bool, String>((ref, productId) {
  // Observa apenas mudanças relevantes nos itens do carrinho
  final cartState = ref.watch(cartProvider);
  
  if (cartState is! CartLoaded) return false;
  
  // Usa hash para otimizar comparação
  final productIds = cartState.cart.items.map((i) => i.productId).toSet();
  return productIds.contains(productId);
});

// ===== NAVIGATION - PROVIDERS OTIMIZADOS =====

/// Provider que observa apenas o índice selecionado
final selectedIndexOnlyProvider = Provider<int>((ref) {
  return ref.watch(
    navigationProvider.select((state) => state.selectedIndex),
  );
});

/// Provider para verificar se uma tela específica está ativa
final isScreenActiveProvider = Provider.family<bool, int>((ref, screenIndex) {
  final currentIndex = ref.watch(selectedIndexOnlyProvider);
  return currentIndex == screenIndex;
});

// ===== SEARCH - PROVIDER COM DEBOUNCE =====

/// Provider para busca com debounce automático
final debouncedSearchProvider = StateProvider<String>((ref) => '');

/// Provider para resultados de busca memoizados
final searchResultsProvider = Provider<List<ProductEntity>>((ref) {
  final query = ref.watch(debouncedSearchProvider);
  final products = ref.watch(optimizedProductsListProvider);
  
  if (query.isEmpty) return products;
  
  // Cache de busca
  final cacheKey = 'search_${query.toLowerCase()}';
  final cached = ProductCache.get<List<ProductEntity>>(cacheKey);
  
  if (cached != null) return cached;
  
  final results = products.where((product) {
    final name = product.name.toLowerCase();
    final description = product.description.toLowerCase();
    final searchQuery = query.toLowerCase();
    
    return name.contains(searchQuery) || description.contains(searchQuery);
  }).toList();
  
  ProductCache.put(cacheKey, results);
  return results;
});

// ===== PERFORMANCE - PROVIDER PARA MONITORAMENTO =====

/// Provider para estatísticas de performance
final performanceStatsProvider = Provider<Map<String, dynamic>>((ref) {
  return {
    'productCacheStats': ProductCache.stats,
    'timestamp': DateTime.now().toIso8601String(),
  };
});

/// Provider para limpar caches quando necessário
final cacheCleanupProvider = Provider<void>((ref) {
  // Auto-dispose para limpar quando não usado
  ref.onDispose(() {
    ProductCache.clear();
    StateCache.clear();
  });
});

// ===== MEMOIZATION HELPERS =====

/// Classe para memoização de providers
class ProviderMemoization {
  static final Map<String, dynamic> _memoCache = {};
  
  static V? getMemo<V>(String key) => _memoCache[key] as V?;
  static void setMemo<V>(String key, V value) => _memoCache[key] = value;
  static void clearMemo() => _memoCache.clear();
}

/// Extension para otimizar providers com select
extension ProviderOptimization<T> on Provider<T> {
  /// Cria um provider que observa apenas mudanças específicas
  Provider<R> selectOptimized<R>(R Function(T) selector) {
    return Provider<R>((ref) {
      return ref.watch(select(selector));
    });
  }
}

/// AutoDispose providers para liberar recursos automaticamente
final autoDisposeProductsProvider = Provider.autoDispose<List<ProductEntity>>((ref) {
  // Automatically disposed when not used
  final products = ref.watch(optimizedProductsListProvider);
  
  // Cleanup callback
  ref.onDispose(() {
    debugPrint('Products provider disposed - cleaning up resources');
  });
  
  return products;
});

final autoDisposeCartProvider = Provider.autoDispose<double>((ref) {
  final total = ref.watch(memoizedCartTotalProvider);
  
  ref.onDispose(() {
    debugPrint('Cart total provider disposed');
  });
  
  return total;
});
