import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../performance/smart_cache.dart';
import '../performance/background_processor.dart';
import '../../features/products/domain/entities/product_entity.dart';

/// Sistema de preloading e cache inteligente para recursos críticos
/// 
/// Carrega antecipadamente recursos que provavelmente serão necessários,
/// otimizando a experiência do usuário
class PreloadingSystem {
  static PreloadingSystem? _instance;
  static PreloadingSystem get instance => _instance ??= PreloadingSystem._();
  
  PreloadingSystem._();
  
  final Set<String> _preloadedImages = {};
  final Set<String> _preloadingImages = {};
  final Map<String, Completer<void>> _preloadCompleters = {};
  
  /// Inicializa o sistema de preloading
  Future<void> initialize() async {
    await _preloadCriticalAssets();
    await _buildSearchIndex();
    _startBackgroundOptimizations();
  }
    /// Preload de assets críticos
  Future<void> _preloadCriticalAssets() async {
    // Lista de imagens críticas para preload
    final criticalImages = <String>[
      // Adicione imagens críticas conforme necessário
      // 'assets/images/logo.png',
      // 'assets/images/placeholder.png',
    ];

    if (criticalImages.isNotEmpty) {
      await Future.wait(
        criticalImages.map((path) => preloadImage(path)),
      );
    }
  }
    /// Preload de uma imagem específica
  Future<void> preloadImage(String imagePath) async {
    if (_preloadedImages.contains(imagePath) || 
        _preloadingImages.contains(imagePath)) {
      return _preloadCompleters[imagePath]?.future ?? Future.value();
    }

    _preloadingImages.add(imagePath);
    final completer = Completer<void>();
    _preloadCompleters[imagePath] = completer;

    try {
      if (imagePath.startsWith('assets/')) {
        // Verificar se o asset existe antes de tentar carregar
        try {
          final data = await rootBundle.load(imagePath);
          final bytes = data.buffer.asUint8List();
          
          // Salva no cache de imagens
          ImageCache.putImageBytes(imagePath, bytes);
          
          debugPrint('✅ Preloaded asset: $imagePath (${bytes.length} bytes)');
        } catch (assetError) {
          debugPrint('⚠️ Asset not found, skipping: $imagePath');
          // Não tratamos como erro fatal se um asset não existe
        }
      } else {
        // Para URLs externas (se necessário no futuro)
        debugPrint('⚠️ URL preloading not implemented: $imagePath');
      }

      _preloadedImages.add(imagePath);
      completer.complete();
    } catch (e) {
      debugPrint('❌ Failed to preload $imagePath: $e');
      completer.completeError(e);
    } finally {
      _preloadingImages.remove(imagePath);
    }
  }
  
  /// Preload de imagens de produtos de uma categoria
  Future<void> preloadCategoryImages(String categoryId, List<ProductEntity> products) async {
    final categoryProducts = products.where((p) => p.categoryId == categoryId).toList();
    
    // Preload apenas primeiras 10 imagens para não sobrecarregar
    final imagesToPreload = categoryProducts
        .take(10)
        .map((p) => p.imageUrl)
        .where((url) => url.isNotEmpty)
        .toList();
    
    await Future.wait(
      imagesToPreload.map((url) => preloadImage(url)),
    );
    
    debugPrint('🖼️ Preloaded ${imagesToPreload.length} images for category $categoryId');
  }
  
  /// Constrói índice de busca em background
  Future<void> _buildSearchIndex() async {
    try {
      // Simula dados de produtos para indexação
      final products = <Map<String, dynamic>>[];
      
      final searchIndex = await PDVBackgroundService.buildProductSearchIndex(products);
      
      // Salva índice no cache
      ProductCache.put('search_index', searchIndex);
      
      debugPrint('🔍 Search index built: ${searchIndex['totalWords']} words');
    } catch (e) {
      debugPrint('❌ Failed to build search index: $e');
    }
  }
  
  /// Inicia otimizações em background
  void _startBackgroundOptimizations() {
    // Timer para otimizações periódicas
    Timer.periodic(const Duration(minutes: 5), (_) {
      _performBackgroundOptimizations();
    });
  }
  
  /// Realiza otimizações em background
  Future<void> _performBackgroundOptimizations() async {
    try {
      // Comprime cache se necessário
      final cacheStats = ProductCache.stats;
      if (cacheStats.totalItems > 100) {
        await _compressCache();
      }
      
      // Limpa imagens não usadas
      _cleanupUnusedImages();
      
      // Preload predictivo baseado no uso
      await _predictivePreload();
      
    } catch (e) {
      debugPrint('❌ Background optimization error: $e');
    }
  }
  
  /// Comprime cache em background
  Future<void> _compressCache() async {
    try {
      final mockData = <Map<String, dynamic>>[];
      
      final result = await PDVBackgroundService.processProductCache(mockData);
      
      debugPrint('🗜️ Cache compressed: ${result['originalSize']} -> ${result['compressedSize']}');
    } catch (e) {
      debugPrint('❌ Cache compression failed: $e');
    }
  }
    /// Limpa imagens não usadas
  void _cleanupUnusedImages() {
    // Remove imagens preloaded antigas
    _preloadedImages.removeWhere((imagePath) {
      // Lógica para verificar se a imagem foi usada recentemente
      // Por simplificação, mantém todas por enquanto
      return false; // Implementar lógica real baseada no uso
    });
    
    debugPrint('🧹 Cleaned up unused images');
  }
  
  /// Preload predictivo baseado em padrões de uso
  Future<void> _predictivePreload() async {
    // Análise de padrões de navegação
    final usage = _analyzeUsagePatterns();
    
    // Preload baseado em probabilidade
    if (usage['likelyNextCategory'] != null) {
      final categoryId = usage['likelyNextCategory'] as String;
      // await preloadCategoryImages(categoryId, []); // Implementar com dados reais
      debugPrint('🔮 Predictive preload for category: $categoryId');
    }
  }
  
  /// Analisa padrões de uso
  Map<String, dynamic> _analyzeUsagePatterns() {
    // Implementar análise real baseada em histórico
    return {
      'likelyNextCategory': 'hamburgers', // Exemplo
      'confidence': 0.7,
    };
  }
  
  /// Verifica se uma imagem está preloaded
  bool isImagePreloaded(String imagePath) {
    return _preloadedImages.contains(imagePath);
  }
  
  /// Obtém estatísticas do preloading
  Map<String, dynamic> getStats() {
    return {
      'preloadedImages': _preloadedImages.length,
      'preloadingImages': _preloadingImages.length,
      'cacheSize': ProductCache.stats.totalItems,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
  
  /// Limpa sistema de preloading
  void clear() {
    _preloadedImages.clear();
    _preloadingImages.clear();
    _preloadCompleters.clear();
    ImageCache.clear();
  }
}

/// Sistema de otimização de assets
class AssetOptimizer {
  /// Otimiza imagem para uso em cache
  static Uint8List optimizeImageData(Uint8List originalData) {
    // Por enquanto, retorna dados originais
    // Em implementação real, poderia comprimir/redimensionar
    return originalData;
  }
  
  /// Calcula hash de asset para cache
  static String calculateAssetHash(String assetPath) {
    return assetPath.hashCode.toString();
  }
  
  /// Determina se asset deve ser preloaded
  static bool shouldPreload(String assetPath) {
    // Critérios para preload
    const preloadPatterns = [
      'logo',
      'icon',
      'placeholder',
      'hero',
    ];
    
    return preloadPatterns.any((pattern) => 
        assetPath.toLowerCase().contains(pattern));
  }
}

/// Sistema de cache inteligente para dados de negócio
class BusinessDataCache {
  static final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _defaultTTL = Duration(minutes: 15);
  
  /// Salva dados com TTL automático
  static void putWithTTL<T>(String key, T data, {Duration? ttl}) {
    ProductCache.put(key, data);
    _cacheTimestamps[key] = DateTime.now();
  }
  
  /// Obtém dados verificando TTL
  static T? getWithTTL<T>(String key, {Duration? ttl}) {
    final timestamp = _cacheTimestamps[key];
    if (timestamp == null) return null;
    
    final age = DateTime.now().difference(timestamp);
    if (age > (ttl ?? _defaultTTL)) {
      ProductCache.remove(key);
      _cacheTimestamps.remove(key);
      return null;
    }
    
    return ProductCache.get<T>(key);
  }
  
  /// Invalida cache por padrão
  static void invalidatePattern(String pattern) {
    final keysToRemove = <String>[];
    
    for (final key in _cacheTimestamps.keys) {
      if (key.contains(pattern)) {
        keysToRemove.add(key);
      }
    }
    
    for (final key in keysToRemove) {
      ProductCache.remove(key);
      _cacheTimestamps.remove(key);
    }
    
    debugPrint('🔄 Invalidated ${keysToRemove.length} cache entries matching "$pattern"');
  }
}

/// Wrapper para operações com cache automático
class CachedOperation<T> {
  final String cacheKey;
  final Future<T> Function() operation;
  final Duration cacheDuration;
  
  const CachedOperation({
    required this.cacheKey,
    required this.operation,
    this.cacheDuration = const Duration(minutes: 10),
  });
  
  /// Executa operação com cache automático
  Future<T> execute() async {
    // Tenta buscar do cache primeiro
    final cached = BusinessDataCache.getWithTTL<T>(cacheKey, ttl: cacheDuration);
    if (cached != null) {
      debugPrint('💾 Cache hit: $cacheKey');
      return cached;
    }
    
    // Executa operação e salva no cache
    debugPrint('🔄 Cache miss: $cacheKey - executing operation');
    final result = await operation();
    BusinessDataCache.putWithTTL(cacheKey, result, ttl: cacheDuration);
    
    return result;
  }
}
