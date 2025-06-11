import '../../../../core/errors/exceptions.dart';
import '../../../../utils/mock_data.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import 'product_local_datasource.dart';

/// Implementação do ProductLocalDataSource usando MockData
/// Adapta os dados existentes para a nova arquitetura
class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  // Cache em memória para simular persistência local
  List<ProductModel>? _cachedProducts;

  /// Carrega produtos dos dados mockados e converte para ProductModel
  List<ProductModel> _loadProductsFromMockData() {
    if (_cachedProducts != null) {
      return _cachedProducts!;
    }

    try {
      // Converte produtos do MockData para ProductModel
      _cachedProducts =
          MockData.products
              .map((product) => ProductModel.fromLegacyProduct(product))
              .toList();

      return _cachedProducts!;
    } catch (e) {
      throw CacheException(
        message: 'Erro ao carregar produtos dos dados mockados: $e',
      );
    }
  }

  /// Converte ID da categoria para nome legível
  String _getCategoryNameById(String categoryId) {
    switch (categoryId) {
      case 'burgers':
        return 'Hambúrgueres';
      case 'pizzas':
        return 'Pizzas';
      case 'drinks':
        return 'Bebidas';
      case 'desserts':
        return 'Sobremesas';
      case 'salads':
        return 'Saladas';
      case 'sides':
        return 'Acompanhamentos';
      default:
        return categoryId.toUpperCase();
    }
  }

  /// Converte ID da categoria para caminho do ícone
  String _getCategoryIconPath(String categoryId) {
    return 'assets/icons/$categoryId.png';
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      // Simula delay de operação assíncrona
      await Future.delayed(const Duration(milliseconds: 100));

      final products = _loadProductsFromMockData();
      return products;
    } catch (e) {
      throw CacheException(message: 'Erro ao buscar todos os produtos: $e');
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    try {
      // Simula delay de operação assíncrona
      await Future.delayed(const Duration(milliseconds: 100));

      final allProducts = _loadProductsFromMockData();

      // Filtra produtos pela categoria
      final filteredProducts =
          allProducts
              .where((product) => product.categoryId == categoryId)
              .toList();

      return filteredProducts;
    } catch (e) {
      throw CacheException(
        message: 'Erro ao buscar produtos por categoria: $e',
      );
    }
  }

  @override
  Future<ProductModel> getProductById(String productId) async {
    try {
      // Simula delay de operação assíncrona
      await Future.delayed(const Duration(milliseconds: 100));

      final allProducts = _loadProductsFromMockData();

      // Busca produto pelo ID
      try {
        final product = allProducts.firstWhere(
          (product) => product.id == productId,
        );
        return product;
      } catch (e) {
        throw CacheException(
          message: 'Produto com ID $productId não encontrado',
        );
      }
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException(message: 'Erro ao buscar produto por ID: $e');
    }
  }

  @override
  Future<List<ProductModel>> getProductsByIds(List<String> productIds) async {
    try {
      // Simula delay de operação assíncrona
      await Future.delayed(const Duration(milliseconds: 100));

      final allProducts = _loadProductsFromMockData();

      // Filtra produtos pelos IDs fornecidos
      final filteredProducts =
          allProducts
              .where((product) => productIds.contains(product.id))
              .toList();

      return filteredProducts;
    } catch (e) {
      throw CacheException(message: 'Erro ao buscar produtos por IDs: $e');
    }
  }

  @override
  Future<bool> isProductAvailable(String productId) async {
    try {
      // Simula delay de operação assíncrona
      await Future.delayed(const Duration(milliseconds: 50));

      final product = await getProductById(productId);
      return product.isAvailable && product.availableQuantity > 0;
    } catch (e) {
      if (e is CacheException) {
        // Se produto não existe, retorna false
        return false;
      }
      throw CacheException(
        message: 'Erro ao verificar disponibilidade do produto: $e',
      );
    }
  }

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    try {
      // Simula delay de operação de cache
      await Future.delayed(const Duration(milliseconds: 50));

      _cachedProducts = List.from(products);
    } catch (e) {
      throw CacheException(message: 'Erro ao cachear produtos: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      // Simula delay de operação de limpeza
      await Future.delayed(const Duration(milliseconds: 50));

      _cachedProducts = null;
    } catch (e) {
      throw CacheException(message: 'Erro ao limpar cache: $e');
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      // Simula delay de operação assíncrona
      await Future.delayed(const Duration(milliseconds: 100));

      // Extrai categorias únicas dos produtos existentes
      final allProducts = _loadProductsFromMockData();

      // Cria um mapa para evitar duplicatas de categorias
      final Map<String, CategoryModel> categoriesMap = {};

      for (final product in allProducts) {
        if (!categoriesMap.containsKey(product.categoryId)) {
          categoriesMap[product.categoryId] = CategoryModel(
            id: product.categoryId,
            name: _getCategoryNameById(product.categoryId),
            description:
                'Categoria ${_getCategoryNameById(product.categoryId)}',
            iconPath: _getCategoryIconPath(product.categoryId),
          );
        }
      }

      return categoriesMap.values.toList();
    } catch (e) {
      throw CacheException(message: 'Erro ao buscar categorias: $e');
    }
  }
}
