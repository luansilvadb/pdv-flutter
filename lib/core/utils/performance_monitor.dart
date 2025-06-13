import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Utilitário para otimização e monitoramento de performance
/// 
/// Esta classe fornece ferramentas para medir e otimizar o desempenho
/// da aplicação, especialmente em momentos críticos como a navegação
/// entre telas e o carregamento de dados.
class PerformanceMonitor {
  /// Flag para habilitar logs de performance em ambientes de desenvolvimento
  static bool enablePerformanceLogs = kDebugMode;

  /// Medição de tempo de execução de uma operação
  static Future<T> measureOperation<T>({
    required String operationName,
    required Future<T> Function() operation,
  }) async {
    if (!enablePerformanceLogs) return operation();

    final stopwatch = Stopwatch()..start();
    final result = await operation();
    stopwatch.stop();

    debugPrint('PERFORMANCE: $operationName took ${stopwatch.elapsedMilliseconds}ms');
    return result;
  }

  /// Habilita a visualização de repinturas na aplicação
  static void enableRepaintRainbow() {
    if (kDebugMode) {
      debugRepaintRainbowEnabled = true;
    }
  }

  /// Habilita contadores para medir performance de widgets
  static void initPerformanceOverlay() {
    if (kDebugMode) {
      // Adicionar outras configurações conforme necessário
    }
  }

  /// Imprime estatísticas de rebuild para ajudar a identificar gargalos
  static void logRebuildStatistics(String widgetName) {
    if (!enablePerformanceLogs) return;

    final DateTime now = DateTime.now();
    debugPrint('WIDGET REBUILD: $widgetName at $now');
  }
}

/// Widget envoltório para rastrear rebuilds e melhorar a performance
class PerformanceTracker extends StatefulWidget {
  final Widget child;
  final String trackerName;
  const PerformanceTracker({
    super.key,
    required this.child,
    required this.trackerName,
  });

  @override
  State<PerformanceTracker> createState() => _PerformanceTrackerState();
}

class _PerformanceTrackerState extends State<PerformanceTracker> {
  int _buildCount = 0;

  @override
  Widget build(BuildContext context) {
    _buildCount++;
    
    if (PerformanceMonitor.enablePerformanceLogs && _buildCount % 5 == 0) {
      debugPrint('REBUILD COUNT: ${widget.trackerName} built $_buildCount times');
    }
    
    return widget.child;
  }
}
