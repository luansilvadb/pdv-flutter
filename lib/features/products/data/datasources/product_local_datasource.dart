import '../models/product_model.dart';
import '../models/category_model.dart';

/// Interface abstrata para fonte de dados local de produtos
/// Define o contrato para acesso aos dados locais
abstract class ProductLocalDataSource {
  /// Busca todos os produtos disponíveis localmente
  /// Retorna [List<ProductModel>]
  /// Pode lançar [CacheException] em caso de erro
  Future<List<ProductModel>> getAllProducts();

  /// Busca produtos filtrados por categoria
  /// [categoryId] - ID da categoria para filtrar
  /// Retorna [List<ProductModel>]
  /// Pode lançar [CacheException] em caso de erro
  Future<List<ProductModel>> getProductsByCategory(String categoryId);

  /// Busca um produto específico pelo ID
  /// [productId] - ID do produto a ser buscado
  /// Retorna [ProductModel]
  /// Pode lançar [CacheException] se produto não for encontrado
  Future<ProductModel> getProductById(String productId);

  /// Busca produtos por lista de IDs
  /// [productIds] - Lista de IDs dos produtos
  /// Retorna [List<ProductModel>]
  /// Pode lançar [CacheException] em caso de erro
  Future<List<ProductModel>> getProductsByIds(List<String> productIds);

  /// Verifica se um produto está disponível
  /// [productId] - ID do produto a ser verificado
  /// Retorna [bool] - true se disponível, false caso contrário
  /// Pode lançar [CacheException] se produto não for encontrado
  Future<bool> isProductAvailable(String productId);

  /// Cacheia uma lista de produtos localmente
  /// [products] - Lista de produtos para cachear
  /// Pode lançar [CacheException] em caso de erro
  Future<void> cacheProducts(List<ProductModel> products);

  /// Limpa o cache de produtos
  /// Pode lançar [CacheException] em caso de erro
  /// Busca todas as categorias disponíveis localmente
  /// Retorna [List<CategoryModel>]
  /// Pode lançar [CacheException] em caso de erro
  Future<List<CategoryModel>> getCategories();
  Future<void> clearCache();
}
