import '../../../features/products/data/models/product_model.dart';
import '../../../features/products/data/models/category_model.dart';
import '../../../core/utils/logger.dart';

/// Serviço de dados mock refatorado para substituir MockData estático
class MockDataService {
  final List<ProductModel> _cachedProducts = [];
  final List<CategoryModel> _cachedCategories = [];
  bool _initialized = false;

  /// Obtém produtos do cache ou carrega se necessário
  Future<List<ProductModel>> getProducts() async {
    if (!_initialized) {
      await _loadInitialData();
    }
    AppLogger.debug(
      'MockDataService: Returning ${_cachedProducts.length} products',
    );
    return List.from(_cachedProducts);
  }

  /// Obtém categorias do cache ou carrega se necessário
  Future<List<CategoryModel>> getCategories() async {
    if (!_initialized) {
      await _loadInitialData();
    }
    AppLogger.debug(
      'MockDataService: Returning ${_cachedCategories.length} categories',
    );
    return List.from(_cachedCategories);
  }

  /// Obtém produtos por categoria
  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    final products = await getProducts();
    final filteredProducts =
        products.where((product) => product.categoryId == categoryId).toList();
    AppLogger.debug(
      'MockDataService: Found ${filteredProducts.length} products for category $categoryId',
    );
    return filteredProducts;
  }

  /// Busca produtos por nome
  Future<List<ProductModel>> searchProducts(String query) async {
    final products = await getProducts();
    final searchResults =
        products
            .where(
              (product) =>
                  product.name.toLowerCase().contains(query.toLowerCase()) ||
                  product.description.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
            .toList();
    AppLogger.debug(
      'MockDataService: Found ${searchResults.length} products for query "$query"',
    );
    return searchResults;
  }

  /// Carrega dados iniciais
  Future<void> _loadInitialData() async {
    AppLogger.migration('MockDataService', 'Loading initial data');

    // Carregar categorias
    _cachedCategories.addAll([
      const CategoryModel(
        id: 'burgers',
        name: 'Burgers',
        description: 'Deliciosos hambúrgueres artesanais',
        iconPath: 'assets/icons/burgers.png',
      ),
      const CategoryModel(
        id: 'drinks',
        name: 'Bebidas',
        description: 'Bebidas refrescantes e sucos naturais',
        iconPath: 'assets/icons/drinks.png',
      ),
      const CategoryModel(
        id: 'sides',
        name: 'Acompanhamentos',
        description: 'Batatas, anéis de cebola e muito mais',
        iconPath: 'assets/icons/sides.png',
      ),
      const CategoryModel(
        id: 'desserts',
        name: 'Sobremesas',
        description: 'Doces e sobremesas irresistíveis',
        iconPath: 'assets/icons/desserts.png',
      ),
    ]);

    // Carregar produtos
    _cachedProducts.addAll([
      // Burgers
      ProductModel(
        id: 'burger-001',
        name: 'Classic Burger',
        description:
            'Hambúrguer clássico com carne bovina, queijo, alface e tomate',
        price: 25.90,
        imageUrl: 'assets/images/burgers/hamburguer1.png',
        categoryId: 'burgers',
        isAvailable: true,
        availableQuantity: 20,
      ),
      ProductModel(
        id: 'burger-002',
        name: 'Cheese Bacon',
        description: 'Hambúrguer com queijo derretido e bacon crocante',
        price: 28.90,
        imageUrl: 'assets/images/burgers/hamburguer2.png',
        categoryId: 'burgers',
        isAvailable: true,
        availableQuantity: 15,
      ),
      ProductModel(
        id: 'burger-003',
        name: 'BBQ Supreme',
        description:
            'Hambúrguer com molho barbecue especial e cebola caramelizada',
        price: 32.90,
        imageUrl: 'assets/images/burgers/hamburguer3.png',
        categoryId: 'burgers',
        isAvailable: true,
        availableQuantity: 12,
      ),
      ProductModel(
        id: 'burger-004',
        name: 'Veggie Delight',
        description:
            'Hambúrguer vegetariano com grão-de-bico e vegetais frescos',
        price: 24.90,
        imageUrl: 'assets/images/burgers/hamburguer4.png',
        categoryId: 'burgers',
        isAvailable: true,
        availableQuantity: 18,
      ),
      ProductModel(
        id: 'burger-005',
        name: 'Spicy Hot',
        description: 'Hambúrguer picante com pimenta jalapeño e molho especial',
        price: 29.90,
        imageUrl: 'assets/images/burgers/hamburguer5.png',
        categoryId: 'burgers',
        isAvailable: true,
        availableQuantity: 10,
      ),
      ProductModel(
        id: 'burger-006',
        name: 'Double Meat',
        description: 'Dois hambúrgueres de carne bovina com queijo duplo',
        price: 35.90,
        imageUrl: 'assets/images/burgers/hamburguer6.png',
        categoryId: 'burgers',
        isAvailable: true,
        availableQuantity: 8,
      ),
      ProductModel(
        id: 'burger-007',
        name: 'Gourmet Special',
        description: 'Hambúrguer gourmet com ingredientes premium',
        price: 38.90,
        imageUrl: 'assets/images/burgers/hamburguer7.png',
        categoryId: 'burgers',
        isAvailable: true,
        availableQuantity: 6,
      ),
      ProductModel(
        id: 'burger-008',
        name: 'Fish Burger',
        description: 'Hambúrguer de peixe grelhado com molho tártaro',
        price: 27.90,
        imageUrl: 'assets/images/burgers/hamburguer8.png',
        categoryId: 'burgers',
        isAvailable: true,
        availableQuantity: 14,
      ),
    ]);

    _initialized = true;
    AppLogger.migration(
      'MockDataService',
      'Initial data loaded: ${_cachedProducts.length} products, ${_cachedCategories.length} categories',
    );
  }

  /// Limpa o cache
  void clearCache() {
    _cachedProducts.clear();
    _cachedCategories.clear();
    _initialized = false;
    AppLogger.debug('MockDataService: Cache cleared');
  }

  /// Recarrega os dados
  Future<void> reload() async {
    clearCache();
    await _loadInitialData();
    AppLogger.debug('MockDataService: Data reloaded');
  }
}
