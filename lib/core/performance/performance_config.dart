import 'package:flutter/foundation.dart';

/// Configurações centralizadas de performance para o PDV Restaurant
/// 
/// Permite ajuste fino de todas as otimizações baseado no ambiente,
/// dispositivo e necessidades específicas
class PerformanceConfig {
  // ===== CACHE CONFIGURATIONS =====
  
  /// Tamanho máximo do cache de produtos
  static const int productCacheMaxSize = kDebugMode ? 50 : 200;
  
  /// TTL padrão para cache de produtos
  static const Duration productCacheTTL = Duration(minutes: 15);
  
  /// Tamanho máximo do cache de imagens
  static const int imageCacheMaxSize = kDebugMode ? 20 : 50;
  
  /// TTL para cache de imagens
  static const Duration imageCacheTTL = Duration(hours: 1);
  
  /// Tamanho máximo do cache de estado
  static const int stateCacheMaxSize = 100;
  
  // ===== WIDGET OPTIMIZATION =====
  
  /// Número máximo de widgets em cache para reutilização
  static const int maxWidgetCacheSize = 50;
  
  /// Intervalo para limpeza automática de widgets não utilizados
  static const Duration widgetCleanupInterval = Duration(minutes: 5);
  
  /// Cache extent para ListViews (distância de pré-carregamento)
  static const double listViewCacheExtent = 500.0;
  
  /// Cache extent para GridViews
  static const double gridViewCacheExtent = 1000.0;
  
  // ===== PERFORMANCE MONITORING =====
  
  /// Habilita monitoramento de performance (apenas debug)
  static const bool enablePerformanceMonitoring = kDebugMode;
  
  /// Intervalo de coleta de métricas
  static const Duration metricsCollectionInterval = Duration(seconds: 30);
  
  /// Número máximo de métricas mantidas em histórico
  static const int maxMetricsHistory = 100;
  
  /// Threshold para considerar um build "lento" (ms)
  static const double slowBuildThreshold = 30.0;
  
  /// Threshold para frame rate considerado baixo (FPS)
  static const double lowFrameRateThreshold = 45.0;
  
  // ===== BACKGROUND PROCESSING =====
  
  /// Habilita processamento em background
  static const bool enableBackgroundProcessing = true;
  
  /// Número máximo de isolates para background processing
  static const int maxBackgroundIsolates = 3;
  
  /// Timeout para operações em background
  static const Duration backgroundOperationTimeout = Duration(seconds: 30);
  
  // ===== PRELOADING =====
  
  /// Habilita preloading de assets
  static const bool enableAssetPreloading = true;
  
  /// Número máximo de imagens para preload por categoria
  static const int maxPreloadImagesPerCategory = 10;
  
  /// Habilita preloading predictivo
  static const bool enablePredictivePreloading = true;
  
  /// Intervalo para análise de padrões de uso
  static const Duration usageAnalysisInterval = Duration(minutes: 10);
  
  // ===== MEMORY MANAGEMENT =====
  
  /// Habilita limpeza automática de memória
  static const bool enableAutoMemoryCleanup = true;
  
  /// Intervalo para limpeza de memória
  static const Duration memoryCleanupInterval = Duration(minutes: 5);
  
  /// Threshold de uso de memória para trigger de limpeza (MB)
  static const int memoryCleanupThreshold = 100;
  
  // ===== NETWORK & STORAGE =====
  
  /// Timeout para operações de storage
  static const Duration storageOperationTimeout = Duration(seconds: 5);
  
  /// Habilita compressão de dados salvos
  static const bool enableDataCompression = true;
  
  /// Habilita batch writes para storage
  static const bool enableBatchWrites = true;
  
  /// Intervalo para batch writes
  static const Duration batchWriteInterval = Duration(milliseconds: 500);
  
  // ===== UI OPTIMIZATION =====
  
  /// Habilita RepaintBoundary automático
  static const bool enableAutoRepaintBoundary = true;
  
  /// Habilita otimizações de scroll
  static const bool enableScrollOptimizations = true;
  
  /// Física de scroll otimizada
  static const bool useOptimizedScrollPhysics = true;
  
  /// Habilita animações otimizadas
  static const bool enableOptimizedAnimations = true;
  
  // ===== ADAPTIVE PERFORMANCE =====
  
  /// Ajusta configurações baseado no desempenho do dispositivo
  static const bool enableAdaptivePerformance = true;
  
  /// Threshold de frame rate para reduzir qualidade automaticamente
  static const double adaptiveQualityThreshold = 30.0;
  
  /// Reduz automaticamente cache em dispositivos com pouca memória
  static const bool enableAdaptiveCaching = true;
  
  // ===== DEBUGGING =====
  
  /// Habilita logs verbosos de performance
  static const bool enableVerbosePerformanceLogs = kDebugMode;
  
  /// Habilita widget inspector de performance
  static const bool enablePerformanceWidgetInspector = kDebugMode;
  
  /// Habilita timeline tracking
  static const bool enableTimelineTracking = kDebugMode;
  
  // ===== DYNAMIC CONFIGURATIONS =====
  
  /// Configurações que podem ser ajustadas em runtime
  static final Map<String, dynamic> _runtimeConfig = {
    'imageQuality': 1.0, // 0.5 - 1.0
    'animationDuration': 1.0, // 0.5 - 2.0
    'cacheAggressiveness': 1.0, // 0.5 - 2.0
    'preloadAggressiveness': 1.0, // 0.0 - 2.0
  };
  
  /// Obtém configuração runtime
  static T getRuntimeConfig<T>(String key, T defaultValue) {
    return _runtimeConfig[key] as T? ?? defaultValue;
  }
  
  /// Define configuração runtime
  static void setRuntimeConfig<T>(String key, T value) {
    _runtimeConfig[key] = value;
    debugPrint('🔧 Runtime config updated: $key = $value');
  }
  
  /// Configuração baseada no ambiente
  static bool get isProductionOptimized => kReleaseMode;
  static bool get isDevelopmentMode => kDebugMode;
  static bool get isProfileMode => kProfileMode;
  
  /// Configurações específicas por plataforma
  static bool get isMobileOptimized => defaultTargetPlatform == TargetPlatform.android || 
                                        defaultTargetPlatform == TargetPlatform.iOS;
  static bool get isDesktopOptimized => defaultTargetPlatform == TargetPlatform.windows ||
                                        defaultTargetPlatform == TargetPlatform.macOS ||
                                        defaultTargetPlatform == TargetPlatform.linux;
  static bool get isWebOptimized => kIsWeb;
  
  /// Aplica configurações baseadas no dispositivo
  static void applyDeviceSpecificOptimizations() {
    if (isMobileOptimized) {
      // Configurações para mobile
      setRuntimeConfig('cacheAggressiveness', 0.8);
      setRuntimeConfig('preloadAggressiveness', 0.6);
      debugPrint('📱 Applied mobile optimizations');
    } else if (isDesktopOptimized) {
      // Configurações para desktop
      setRuntimeConfig('cacheAggressiveness', 1.5);
      setRuntimeConfig('preloadAggressiveness', 1.2);
      debugPrint('🖥️ Applied desktop optimizations');
    } else if (isWebOptimized) {
      // Configurações para web
      setRuntimeConfig('cacheAggressiveness', 1.0);
      setRuntimeConfig('preloadAggressiveness', 0.8);
      debugPrint('🌐 Applied web optimizations');
    }
  }
  
  /// Configurações adaptativas baseadas em performance
  static void adaptToPerformance(double averageFrameTime) {
    if (!enableAdaptivePerformance) return;
    
    final frameRate = 1000 / averageFrameTime;
    
    if (frameRate < adaptiveQualityThreshold) {
      // Reduz qualidade para melhorar performance
      setRuntimeConfig('imageQuality', 0.7);
      setRuntimeConfig('animationDuration', 0.7);
      setRuntimeConfig('cacheAggressiveness', 0.6);
      debugPrint('⚡ Adaptive performance: Reduced quality (${frameRate.toStringAsFixed(1)} FPS)');
    } else if (frameRate > 55) {
      // Aumenta qualidade se performance está boa
      setRuntimeConfig('imageQuality', 1.0);
      setRuntimeConfig('animationDuration', 1.0);
      setRuntimeConfig('cacheAggressiveness', 1.2);
      debugPrint('✨ Adaptive performance: Increased quality (${frameRate.toStringAsFixed(1)} FPS)');
    }
  }
  
  /// Preset de configurações para diferentes cenários
  static void applyPreset(PerformancePreset preset) {
    switch (preset) {
      case PerformancePreset.battery:
        setRuntimeConfig('imageQuality', 0.8);
        setRuntimeConfig('animationDuration', 0.8);
        setRuntimeConfig('cacheAggressiveness', 0.7);
        setRuntimeConfig('preloadAggressiveness', 0.5);
        debugPrint('🔋 Applied battery saver preset');
        break;
        
      case PerformancePreset.balanced:
        setRuntimeConfig('imageQuality', 1.0);
        setRuntimeConfig('animationDuration', 1.0);
        setRuntimeConfig('cacheAggressiveness', 1.0);
        setRuntimeConfig('preloadAggressiveness', 1.0);
        debugPrint('⚖️ Applied balanced preset');
        break;
        
      case PerformancePreset.performance:
        setRuntimeConfig('imageQuality', 1.0);
        setRuntimeConfig('animationDuration', 1.2);
        setRuntimeConfig('cacheAggressiveness', 1.5);
        setRuntimeConfig('preloadAggressiveness', 1.5);
        debugPrint('🚀 Applied performance preset');
        break;
    }
  }
  
  /// Obtém resumo de todas as configurações
  static Map<String, dynamic> getConfigSummary() {
    return {
      'environment': kDebugMode ? 'debug' : (kReleaseMode ? 'release' : 'profile'),
      'platform': defaultTargetPlatform.toString(),
      'isWeb': kIsWeb,
      'cacheConfig': {
        'productCache': {
          'maxSize': productCacheMaxSize,
          'ttl': productCacheTTL.inMinutes,
        },
        'imageCache': {
          'maxSize': imageCacheMaxSize,
          'ttl': imageCacheTTL.inHours,
        },
      },
      'optimizations': {
        'backgroundProcessing': enableBackgroundProcessing,
        'assetPreloading': enableAssetPreloading,
        'autoMemoryCleanup': enableAutoMemoryCleanup,
        'adaptivePerformance': enableAdaptivePerformance,
      },
      'runtimeConfig': Map.from(_runtimeConfig),
    };
  }
}

/// Presets de configuração de performance
enum PerformancePreset {
  battery,    // Economiza bateria, performance moderada
  balanced,   // Balanceado entre performance e recursos
  performance, // Máxima performance, usa mais recursos
}

/// Target platform enum para compatibilidade
enum TargetPlatform {
  android,
  iOS,
  windows,
  macOS,
  linux,
}

/// Simulação de defaultTargetPlatform para web
const TargetPlatform defaultTargetPlatform = TargetPlatform.windows;
