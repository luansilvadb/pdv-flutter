import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/dependency_injection.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_all_products.dart';
import '../../domain/usecases/get_products_by_category.dart';

/// Estado dos produtos
class ProductsState {
  final List<ProductEntity> products;
  final bool isLoading;
  final String? error;
  final String? selectedCategoryId;

  const ProductsState({
    this.products = const [],
    this.isLoading = false,
    this.error,
    this.selectedCategoryId,
  });

  ProductsState copyWith({
    List<ProductEntity>? products,
    bool? isLoading,
    String? error,
    String? selectedCategoryId,
  }) {
    return ProductsState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
    );
  }
}

/// Notifier para gerenciar estado dos produtos
class ProductsNotifier extends StateNotifier<ProductsState> {
  final GetAllProducts _getAllProducts;
  final GetProductsByCategory _getProductsByCategory;

  ProductsNotifier(this._getAllProducts, this._getProductsByCategory)
    : super(const ProductsState());

  /// Carrega todos os produtos
  Future<void> loadAllProducts() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _getAllProducts();

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (products) =>
          state = state.copyWith(
            isLoading: false,
            products: products,
            selectedCategoryId: null,
            error: null,
          ),
    );
  }

  /// Carrega produtos por categoria
  Future<void> loadProductsByCategory(String categoryId) async {
    state = state.copyWith(isLoading: true, error: null);

    final params = GetProductsByCategoryParams(categoryId: categoryId);
    final result = await _getProductsByCategory(params);

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (products) =>
          state = state.copyWith(
            isLoading: false,
            products: products,
            selectedCategoryId: categoryId,
            error: null,
          ),
    );
  }

  /// Limpa o filtro de categoria e carrega todos os produtos
  Future<void> clearCategoryFilter() async {
    await loadAllProducts();
  }

  /// Busca um produto específico pelo ID na lista atual
  ProductEntity? getProductById(String productId) {
    try {
      return state.products.firstWhere((product) => product.id == productId);
    } catch (e) {
      return null;
    }
  }

  /// Verifica se existe produtos para a categoria selecionada
  bool get hasProductsForSelectedCategory {
    return state.products.isNotEmpty;
  }

  /// Retorna produtos disponíveis (quantidade > 0)
  List<ProductEntity> get availableProducts {
    return state.products
        .where(
          (product) => product.isAvailable && product.availableQuantity > 0,
        )
        .toList();
  }
}

/// Provider para o notifier dos produtos
final productsNotifierProvider =
    StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
      return ProductsNotifier(
        sl<GetAllProducts>(),
        sl<GetProductsByCategory>(),
      );
    });

/// Provider para acessar apenas a lista de produtos
final productsListProvider = Provider<List<ProductEntity>>((ref) {
  return ref.watch(productsNotifierProvider).products;
});

/// Provider para verificar se está carregando
final isLoadingProductsProvider = Provider<bool>((ref) {
  return ref.watch(productsNotifierProvider).isLoading;
});

/// Provider para obter erro
final productsErrorProvider = Provider<String?>((ref) {
  return ref.watch(productsNotifierProvider).error;
});

/// Provider para obter categoria selecionada
final selectedCategoryProvider = Provider<String?>((ref) {
  return ref.watch(productsNotifierProvider).selectedCategoryId;
});

/// Provider para obter produtos disponíveis
final availableProductsProvider = Provider<List<ProductEntity>>((ref) {
  return ref.watch(productsNotifierProvider.notifier).availableProducts;
});
