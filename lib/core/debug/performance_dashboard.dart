import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../performance/performance_manager.dart';

/// Sistema interno de monitoramento de performance
/// Coleta métricas sem interface visual para o usuário
class PerformanceMonitor {
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();
  factory PerformanceMonitor() => _instance;
  PerformanceMonitor._internal();

  static PerformanceMonitor get instance => _instance;

  bool _isLogging = false;
  PerformanceMetrics? _lastMetrics;

  /// Inicia o monitoramento interno
  void startMonitoring() {
    if (_isLogging) return;
    _isLogging = true;
    
    if (kDebugMode) {
      developer.log('Performance monitoring started', name: 'PerformanceMonitor');
    }
    
    _startPeriodicLogging();
  }

  /// Para o monitoramento
  void stopMonitoring() {
    _isLogging = false;
    
    if (kDebugMode) {
      developer.log('Performance monitoring stopped', name: 'PerformanceMonitor');
    }
  }

  /// Inicia logging periódico das métricas
  void _startPeriodicLogging() {
    Future.doWhile(() async {
      if (!_isLogging) return false;
      
      await _logPerformanceMetrics();
      await Future.delayed(const Duration(seconds: 10));
      
      return _isLogging;
    });
  }  /// Faz log das métricas de performance
  Future<void> _logPerformanceMetrics() async {
    try {
      final report = PerformanceManager.instance.getReport();
      final memoryInBytes = (report.memoryUsage['current'] ?? 0) as int;
      
      _lastMetrics = PerformanceMetrics(
        fps: report.frameRate,
        memoryUsage: memoryInBytes,
        cpuUsage: 0.0, // Não disponível no report atual
        activeObjects: report.totalFrames,
        timestamp: DateTime.now(),
      );
      
      if (kDebugMode) {
        developer.log(
          'Performance Metrics - '
          'FPS: ${report.frameRate.toStringAsFixed(1)}, '
          'Memory: ${(memoryInBytes / 1024 / 1024).toStringAsFixed(1)}MB, '
          'Cache Hit Rate: ${(report.cacheStats.hitRatio * 100).toStringAsFixed(1)}%',
          name: 'PerformanceMonitor'
        );
        
        // Log alertas se necessário
        if (report.frameRate < 30) {
          developer.log('LOW FPS WARNING: ${report.frameRate}', name: 'PerformanceAlert');
        }
        
        if (memoryInBytes > 100 * 1024 * 1024) { // 100MB
          developer.log('HIGH MEMORY WARNING: ${(memoryInBytes / 1024 / 1024).toStringAsFixed(1)}MB', name: 'PerformanceAlert');
        }
        
        if (report.cacheStats.hitRatio < 0.5) {
          developer.log('LOW CACHE HIT RATE WARNING: ${(report.cacheStats.hitRatio * 100).toStringAsFixed(1)}%', name: 'PerformanceAlert');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        developer.log('Error logging performance metrics: $e', name: 'PerformanceMonitor');
      }
    }
  }

  /// Obtém as últimas métricas coletadas
  PerformanceMetrics? get lastMetrics => _lastMetrics;

  /// Log de evento de performance específico
  void logEvent(String event, {Map<String, dynamic>? data}) {
    if (kDebugMode) {
      final dataStr = data != null ? ' - Data: $data' : '';
      developer.log('$event$dataStr', name: 'PerformanceEvent');
    }
  }
}

/// Métricas de performance
class PerformanceMetrics {
  final double fps;
  final int memoryUsage;
  final double cpuUsage;
  final int activeObjects;
  final DateTime timestamp;

  const PerformanceMetrics({
    required this.fps,
    required this.memoryUsage,
    required this.cpuUsage,
    required this.activeObjects,
    required this.timestamp,
  });
}

/// Provider para métricas de performance (apenas para sistema interno)
final performanceMetricsProvider = StateProvider<PerformanceMetrics?>((ref) => null);
