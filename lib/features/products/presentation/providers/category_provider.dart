import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/category_entity.dart';
import '../../../../core/services/dependency_injection.dart';
import '../../data/datasources/product_local_datasource.dart';

/// Estado das categorias
class CategoriesState {
  final List<CategoryEntity> categories;
  final bool isLoading;
  final String? error;
  final String? selectedCategoryId;

  const CategoriesState({
    this.categories = const [],
    this.isLoading = false,
    this.error,
    this.selectedCategoryId,
  });

  CategoriesState copyWith({
    List<CategoryEntity>? categories,
    bool? isLoading,
    String? error,
    String? selectedCategoryId,
  }) {
    return CategoriesState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
    );
  }
}

/// Notifier para gerenciar estado das categorias
class CategoriesNotifier extends StateNotifier<CategoriesState> {
  final ProductLocalDataSource _dataSource;

  CategoriesNotifier(this._dataSource) : super(const CategoriesState());

  /// Carrega todas as categorias
  Future<void> loadCategories() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final categories = await _dataSource.getCategories();
      state = state.copyWith(
        isLoading: false,
        categories: categories,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erro ao carregar categorias: $e',
      );
    }
  }

  /// Define a categoria selecionada
  void setSelectedCategory(String? categoryId) {
    state = state.copyWith(selectedCategoryId: categoryId);
  }

  /// Limpa a seleção de categoria - alias para compatibilidade
  void clearSelection() {
    clearSelectedCategory();
  }

  /// Limpa a seleção de categoria
  void clearSelectedCategory() {
    state = state.copyWith(selectedCategoryId: null);
  }

  /// Obtém uma categoria por ID
  CategoryEntity? getCategoryById(String categoryId) {
    try {
      return state.categories.firstWhere((cat) => cat.id == categoryId);
    } catch (e) {
      return null;
    }
  }

  /// Verifica se uma categoria está selecionada
  bool isCategorySelected(String categoryId) {
    return state.selectedCategoryId == categoryId;
  }

  /// Seleciona uma categoria - alias para compatibilidade
  void selectCategory(String? categoryId) {
    setSelectedCategory(categoryId);
  }
}

/// Provider para o notifier das categorias
final categoriesNotifierProvider =
    StateNotifierProvider<CategoriesNotifier, CategoriesState>((ref) {
      return CategoriesNotifier(sl<ProductLocalDataSource>());
    });

/// Alias para compatibilidade com código existente
final categoryNotifierProvider = categoriesNotifierProvider;

/// Provider para acessar apenas a lista de categorias
final categoriesListProvider = Provider<List<CategoryEntity>>((ref) {
  return ref.watch(categoriesNotifierProvider).categories;
});

/// Provider para verificar se está carregando categorias
final isLoadingCategoriesProvider = Provider<bool>((ref) {
  return ref.watch(categoriesNotifierProvider).isLoading;
});

/// Provider para obter erro das categorias
final categoriesErrorProvider = Provider<String?>((ref) {
  return ref.watch(categoriesNotifierProvider).error;
});

/// Provider para obter categoria selecionada
final selectedCategoryIdProvider = Provider<String?>((ref) {
  return ref.watch(categoriesNotifierProvider).selectedCategoryId;
});

/// Provider para obter a categoria selecionada (objeto completo)
final selectedCategoryProvider = Provider<CategoryEntity?>((ref) {
  final selectedId = ref.watch(selectedCategoryIdProvider);
  if (selectedId == null) return null;

  return ref
      .watch(categoriesNotifierProvider.notifier)
      .getCategoryById(selectedId);
});
