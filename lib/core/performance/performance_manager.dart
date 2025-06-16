import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'smart_cache.dart';

/// Gerenciador central de performance para monitorar e otimizar o app
/// 
/// Coleta métricas, identifica gargalos e aplica otimizações automáticas
class PerformanceManager {
  static PerformanceManager? _instance;
  static PerformanceManager get instance => _instance ??= PerformanceManager._();
  
  PerformanceManager._() {
    _startMonitoring();
  }
  
  // Métricas
  final Map<String, List<double>> _buildTimes = {};
  final Map<String, int> _buildCounts = {};
  final Map<String, DateTime> _lastBuildTime = {};
  final List<double> _frameRenderTimes = [];
  final Map<String, dynamic> _memoryUsage = {};
  
  // Configurações
  static const int _maxMetricsHistory = 100;
  static const Duration _monitoringInterval = Duration(seconds: 30);
  
  Timer? _monitoringTimer;
  int _frameCount = 0;
  double _averageFrameTime = 16.67; // 60 FPS target
  
  /// Inicia monitoramento automático
  void _startMonitoring() {
    if (kDebugMode) {
      _monitoringTimer = Timer.periodic(_monitoringInterval, (_) {
        _collectSystemMetrics();
        _analyzePerformance();
        _applyOptimizations();
      });
    }
  }
  
  /// Registra tempo de build de um widget
  void recordBuildTime(String widgetName, double milliseconds) {
    if (!kDebugMode) return;
    
    _buildTimes[widgetName] ??= [];
    _buildCounts[widgetName] = (_buildCounts[widgetName] ?? 0) + 1;
    _lastBuildTime[widgetName] = DateTime.now();
    
    final times = _buildTimes[widgetName]!;
    times.add(milliseconds);
    
    // Mantém apenas as últimas métricas
    if (times.length > _maxMetricsHistory) {
      times.removeAt(0);
    }
    
    // Log se build muito lento
    if (milliseconds > 50) {
      debugPrint('⚠️ SLOW BUILD: $widgetName took ${milliseconds.toStringAsFixed(2)}ms');
    }
  }
  
  /// Registra tempo de renderização de frame
  void recordFrameTime(double milliseconds) {
    if (!kDebugMode) return;
    
    _frameCount++;
    _frameRenderTimes.add(milliseconds);
    
    if (_frameRenderTimes.length > _maxMetricsHistory) {
      _frameRenderTimes.removeAt(0);
    }
    
    // Atualiza média
    _averageFrameTime = _frameRenderTimes.isEmpty 
        ? 16.67 
        : _frameRenderTimes.reduce((a, b) => a + b) / _frameRenderTimes.length;
  }
  
  /// Coleta métricas do sistema
  void _collectSystemMetrics() {
    try {
      // Simula coleta de métricas de memória
      _memoryUsage['timestamp'] = DateTime.now().millisecondsSinceEpoch;
      _memoryUsage['cacheSize'] = ProductCache.stats.totalItems;
      _memoryUsage['buildHistory'] = _buildTimes.length;
      _memoryUsage['averageFrameTime'] = _averageFrameTime;
      _memoryUsage['frameCount'] = _frameCount;
    } catch (e) {
      debugPrint('Erro ao coletar métricas: $e');
    }
  }
  
  /// Analisa performance e identifica problemas
  void _analyzePerformance() {
    final issues = <String>[];
    
    // Verifica widgets com build lento
    _buildTimes.forEach((widget, times) {
      if (times.isNotEmpty) {
        final average = times.reduce((a, b) => a + b) / times.length;
        if (average > 30) {
          issues.add('Widget $widget tem build lento (${average.toStringAsFixed(1)}ms)');
        }
      }
    });
    
    // Verifica frame rate
    if (_averageFrameTime > 20) {
      issues.add('Frame rate baixo (${(1000 / _averageFrameTime).toStringAsFixed(1)} FPS)');
    }
    
    // Verifica widgets com muitos rebuilds
    _buildCounts.forEach((widget, count) {
      final lastBuild = _lastBuildTime[widget];
      if (lastBuild != null && count > 50) {
        final minutesSinceStart = DateTime.now().difference(lastBuild).inMinutes;
        if (minutesSinceStart < 5) {
          issues.add('Widget $widget com muitos rebuilds ($count em ${minutesSinceStart}min)');
        }
      }
    });
    
    if (issues.isNotEmpty) {
      debugPrint('🔍 PERFORMANCE ISSUES DETECTED:');
      for (final issue in issues) {
        debugPrint('  • $issue');
      }
    }
  }
  
  /// Aplica otimizações automáticas
  void _applyOptimizations() {
    // Limpa cache se muito grande
    if (ProductCache.stats.totalItems > 150) {
      ProductCache.clear();
      debugPrint('🧹 Cache limpo automaticamente (muito grande)');
    }
    
    // Reset métricas antigas
    _cleanupOldMetrics();
    
    // Garbage collection hint
    if (_frameCount % 1000 == 0) {
      _suggestGarbageCollection();
    }
  }
  
  /// Limpa métricas antigas
  void _cleanupOldMetrics() {
    final now = DateTime.now();
    final cutoff = now.subtract(const Duration(minutes: 10));
    
    _lastBuildTime.removeWhere((widget, time) => time.isBefore(cutoff));
    
    // Reset contadores para widgets não usados recentemente
    final oldWidgets = _buildCounts.keys.where((widget) {
      final lastBuild = _lastBuildTime[widget];
      return lastBuild == null || lastBuild.isBefore(cutoff);
    }).toList();
    
    for (final widget in oldWidgets) {
      _buildCounts.remove(widget);
      _buildTimes.remove(widget);
    }
  }
  
  /// Sugere garbage collection
  void _suggestGarbageCollection() {
    if (kDebugMode) {
      debugPrint('💾 Sugerindo garbage collection...');
      // Em produção, você poderia usar platform channels para forçar GC
    }
  }
  
  /// Obtém relatório de performance
  PerformanceReport getReport() {
    final slowWidgets = <String, double>{};
    final frequentWidgets = <String, int>{};
    
    _buildTimes.forEach((widget, times) {
      if (times.isNotEmpty) {
        final average = times.reduce((a, b) => a + b) / times.length;
        if (average > 20) {
          slowWidgets[widget] = average;
        }
      }
    });
    
    _buildCounts.forEach((widget, count) {
      if (count > 20) {
        frequentWidgets[widget] = count;
      }
    });
    
    return PerformanceReport(
      averageFrameTime: _averageFrameTime,
      frameRate: 1000 / _averageFrameTime,
      totalFrames: _frameCount,
      slowWidgets: slowWidgets,
      frequentRebuildWidgets: frequentWidgets,
      cacheStats: ProductCache.stats,
      memoryUsage: Map.from(_memoryUsage),
    );
  }
  
  /// Limpa todas as métricas
  void reset() {
    _buildTimes.clear();
    _buildCounts.clear();
    _lastBuildTime.clear();
    _frameRenderTimes.clear();
    _memoryUsage.clear();
    _frameCount = 0;
    _averageFrameTime = 16.67;
  }
  
  /// Para o monitoramento
  void dispose() {
    _monitoringTimer?.cancel();
    reset();
  }
}

/// Relatório de performance
class PerformanceReport {
  final double averageFrameTime;
  final double frameRate;
  final int totalFrames;
  final Map<String, double> slowWidgets;
  final Map<String, int> frequentRebuildWidgets;
  final CacheStats cacheStats;
  final Map<String, dynamic> memoryUsage;
  
  const PerformanceReport({
    required this.averageFrameTime,
    required this.frameRate,
    required this.totalFrames,
    required this.slowWidgets,
    required this.frequentRebuildWidgets,
    required this.cacheStats,
    required this.memoryUsage,
  });
  
  /// Converte para JSON
  Map<String, dynamic> toJson() {
    return {
      'averageFrameTime': averageFrameTime,
      'frameRate': frameRate,
      'totalFrames': totalFrames,
      'slowWidgets': slowWidgets,
      'frequentRebuildWidgets': frequentRebuildWidgets,
      'cacheStats': {
        'totalItems': cacheStats.totalItems,
        'expiredItems': cacheStats.expiredItems,
        'hitRatio': cacheStats.hitRatio,
      },
      'memoryUsage': memoryUsage,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
  
  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('📊 PERFORMANCE REPORT');
    buffer.writeln('Frame Rate: ${frameRate.toStringAsFixed(1)} FPS');
    buffer.writeln('Total Frames: $totalFrames');
    buffer.writeln('Cache: ${cacheStats.totalItems} items (${(cacheStats.hitRatio * 100).toStringAsFixed(1)}% hit rate)');
    
    if (slowWidgets.isNotEmpty) {
      buffer.writeln('\n🐌 Slow Widgets:');
      slowWidgets.forEach((widget, time) {
        buffer.writeln('  • $widget: ${time.toStringAsFixed(1)}ms');
      });
    }
    
    if (frequentRebuildWidgets.isNotEmpty) {
      buffer.writeln('\n🔄 Frequent Rebuilds:');
      frequentRebuildWidgets.forEach((widget, count) {
        buffer.writeln('  • $widget: $count rebuilds');
      });
    }
    
    return buffer.toString();
  }
}

/// Widget wrapper para medir performance automaticamente
class PerformanceTracker extends StatefulWidget {
  final Widget child;
  final String name;
  
  const PerformanceTracker({
    required this.child,
    required this.name,
    super.key,
  });

  @override
  State<PerformanceTracker> createState() => _PerformanceTrackerState();
}

class _PerformanceTrackerState extends State<PerformanceTracker> {
  late final Stopwatch _stopwatch;
  
  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      _stopwatch.reset();
      _stopwatch.start();
    }
    
    final child = widget.child;
    
    if (kDebugMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _stopwatch.stop();
        PerformanceManager.instance.recordBuildTime(
          widget.name,
          _stopwatch.elapsedMicroseconds / 1000.0,
        );
      });
    }
    
    return child;
  }
}

/// Mixin para widgets que querem monitorar performance
mixin PerformanceAware<T extends StatefulWidget> on State<T> {
  late final Stopwatch _buildStopwatch;
  
  @override
  void initState() {
    super.initState();
    _buildStopwatch = Stopwatch();
  }
  
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      _buildStopwatch.reset();
      _buildStopwatch.start();
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _buildStopwatch.stop();
        PerformanceManager.instance.recordBuildTime(
          widget.runtimeType.toString(),
          _buildStopwatch.elapsedMicroseconds / 1000.0,
        );
      });
    }
    
    return buildWithPerformanceTracking(context);
  }
  
  /// Implementar este método ao invés de build()
  Widget buildWithPerformanceTracking(BuildContext context);
}

/// Utilitários de otimização
class PerformanceUtils {
  /// Debounce para evitar chamadas excessivas
  static Timer? _debounceTimer;
  
  static void debounce(Duration duration, VoidCallback callback) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(duration, callback);
  }
  
  /// Throttle para limitar frequência de chamadas
  static final Map<String, DateTime> _lastThrottleTimes = {};
  
  static bool throttle(String key, Duration duration) {
    final now = DateTime.now();
    final lastTime = _lastThrottleTimes[key];
    
    if (lastTime == null || now.difference(lastTime) >= duration) {
      _lastThrottleTimes[key] = now;
      return true;
    }
    
    return false;
  }
  
  /// Batch executor para operações em lote
  static final Map<String, List<VoidCallback>> _batchQueues = {};
  static final Map<String, Timer> _batchTimers = {};
  
  static void batch(String key, VoidCallback callback, Duration delay) {
    _batchQueues[key] ??= [];
    _batchQueues[key]!.add(callback);
    
    _batchTimers[key]?.cancel();
    _batchTimers[key] = Timer(delay, () {
      final callbacks = _batchQueues[key] ?? [];
      _batchQueues[key]?.clear();
      
      for (final callback in callbacks) {
        try {
          callback();
        } catch (e) {
          debugPrint('Erro em batch callback: $e');
        }
      }
    });
  }
  
  /// Calcula hash rápido para comparações
  static int fastHash(String input) {
    var hash = 0;
    for (var i = 0; i < input.length; i++) {
      hash = ((hash << 5) - hash + input.codeUnitAt(i)) & 0xffffffff;
    }
    return hash;
  }
}
