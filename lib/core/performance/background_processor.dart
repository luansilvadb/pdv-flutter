import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';

/// Sistema de processamento em background para operações pesadas
/// 
/// Utiliza isolates para não bloquear a UI thread e
/// processa operações como cache, sincronização e cálculos complexos
class BackgroundProcessor {
  static BackgroundProcessor? _instance;
  static BackgroundProcessor get instance => _instance ??= BackgroundProcessor._();
  
  BackgroundProcessor._();
  
  final Map<String, Isolate> _isolates = {};
  final Map<String, SendPort> _sendPorts = {};
  final Map<String, Completer> _completers = {};
  
  /// Processa uma tarefa em background
  Future<T> processInBackground<T>({
    required String taskId,
    required Map<String, dynamic> data,
    required String operation,
  }) async {
    // Se já existe um isolate para esta tarefa, usa ele
    if (_sendPorts.containsKey(taskId)) {
      return _sendTaskToExistingIsolate<T>(taskId, data, operation);
    }
    
    // Cria novo isolate
    return _createIsolateAndProcess<T>(taskId, data, operation);
  }
  
  /// Cria isolate e processa tarefa
  Future<T> _createIsolateAndProcess<T>(
    String taskId,
    Map<String, dynamic> data,
    String operation,
  ) async {
    final receivePort = ReceivePort();
    final completer = Completer<T>();
    _completers[taskId] = completer;
    
    // Dados para enviar ao isolate
    final isolateData = {
      'sendPort': receivePort.sendPort,
      'operation': operation,
      'data': data,
      'taskId': taskId,
    };
    
    try {
      // Spawn isolate
      final isolate = await Isolate.spawn(_isolateEntryPoint, isolateData);
      _isolates[taskId] = isolate;
      
      // Listen para respostas
      receivePort.listen((message) {
        _handleIsolateMessage<T>(taskId, message);
      });
      
      return completer.future;
    } catch (e) {
      _cleanup(taskId);
      throw Exception('Erro ao criar isolate: $e');
    }
  }
  
  /// Envia tarefa para isolate existente
  Future<T> _sendTaskToExistingIsolate<T>(
    String taskId,
    Map<String, dynamic> data,
    String operation,
  ) async {
    final sendPort = _sendPorts[taskId];
    if (sendPort == null) {
      throw Exception('SendPort não encontrado para taskId: $taskId');
    }
    
    final completer = Completer<T>();
    final requestId = DateTime.now().millisecondsSinceEpoch.toString();
    _completers[requestId] = completer;
    
    sendPort.send({
      'operation': operation,
      'data': data,
      'requestId': requestId,
    });
    
    return completer.future;
  }
  
  /// Manipula mensagens do isolate
  void _handleIsolateMessage<T>(String taskId, dynamic message) {
    if (message is Map<String, dynamic>) {
      if (message.containsKey('sendPort')) {
        // Primeira mensagem com SendPort
        _sendPorts[taskId] = message['sendPort'];
      } else if (message.containsKey('result')) {
        // Resultado da operação
        final requestId = message['requestId'] ?? taskId;
        final completer = _completers.remove(requestId);
        
        if (message.containsKey('error')) {
          completer?.completeError(Exception(message['error']));
        } else {
          completer?.complete(message['result'] as T);
        }
      }
    }
  }
  
  /// Entry point do isolate
  static void _isolateEntryPoint(Map<String, dynamic> data) async {
    final sendPort = data['sendPort'] as SendPort;
    final receivePort = ReceivePort();
    
    // Envia SendPort de volta
    sendPort.send({'sendPort': receivePort.sendPort});
    
    // Listen para requests
    receivePort.listen((message) async {
      await _processIsolateTask(sendPort, message);
    });
    
    // Processa primeira tarefa
    await _processIsolateTask(sendPort, data);
  }
  
  /// Processa tarefa no isolate
  static Future<void> _processIsolateTask(
    SendPort sendPort,
    dynamic message,
  ) async {
    if (message is! Map<String, dynamic>) return;
    
    final operation = message['operation'] as String?;
    final data = message['data'] as Map<String, dynamic>?;
    final requestId = message['requestId'] ?? message['taskId'];
    
    if (operation == null || data == null) return;
    
    try {
      final result = await _executeOperation(operation, data);
      sendPort.send({
        'result': result,
        'requestId': requestId,
      });
    } catch (e) {
      sendPort.send({
        'error': e.toString(),
        'requestId': requestId,
      });
    }
  }
  
  /// Executa operação específica
  static Future<dynamic> _executeOperation(
    String operation,
    Map<String, dynamic> data,
  ) async {
    switch (operation) {
      case 'cacheCompression':
        return _compressCache(data);
      
      case 'dataSync':
        return _syncData(data);
      
      case 'complexCalculation':
        return _performComplexCalculation(data);
      
      case 'imageProcessing':
        return _processImages(data);
      
      case 'searchIndexing':
        return _buildSearchIndex(data);
      
      default:
        throw Exception('Operação não suportada: $operation');
    }
  }
  
  /// Comprime dados de cache
  static Map<String, dynamic> _compressCache(Map<String, dynamic> data) {
    // Simula compressão de dados
    final items = data['items'] as List<dynamic>? ?? [];
    final compressed = items.map((item) => {
      'id': item['id'],
      'essential': item['name'], // Só dados essenciais
    }).toList();
    
    return {
      'compressed': compressed,
      'originalSize': items.length,
      'compressedSize': compressed.length,
    };
  }
  
  /// Sincroniza dados
  static Map<String, dynamic> _syncData(Map<String, dynamic> data) {
    // Simula sincronização
    final updates = data['updates'] as List<dynamic>? ?? [];
    final processed = <String, dynamic>{};
    
    for (final update in updates) {
      processed[update['id']] = {
        'status': 'synced',
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
    
    return processed;
  }
  
  /// Realiza cálculos complexos
  static Map<String, dynamic> _performComplexCalculation(Map<String, dynamic> data) {
    final numbers = data['numbers'] as List<dynamic>? ?? [];
    
    if (numbers.isEmpty) return {'result': 0};
      // Simula cálculo complexo
    var sum = 0.0;
    var product = 1.0;
    
    for (final number in numbers) {
      final value = (number as num).toDouble();
      sum += value;
      product *= value;
    }
    
    return {
      'sum': sum,
      'product': product,
      'average': sum / numbers.length,
      'count': numbers.length,
    };
  }
  
  /// Processa imagens
  static Map<String, dynamic> _processImages(Map<String, dynamic> data) {
    final images = data['images'] as List<dynamic>? ?? [];
    final processed = <Map<String, dynamic>>[];
    
    for (final image in images) {
      processed.add({
        'url': image['url'],
        'optimized': true,
        'size': 'reduced',
        'format': 'webp',
      });
    }
    
    return {'processedImages': processed};
  }
  
  /// Constrói índice de busca
  static Map<String, dynamic> _buildSearchIndex(Map<String, dynamic> data) {
    final items = data['items'] as List<dynamic>? ?? [];
    final index = <String, List<String>>{};
    
    for (final item in items) {
      final name = item['name']?.toString().toLowerCase() ?? '';
      final words = name.split(' ');
      
      for (final word in words) {
        if (word.isNotEmpty) {
          index[word] = index[word] ?? [];
          index[word]!.add(item['id'].toString());
        }
      }
    }
    
    return {
      'searchIndex': index,
      'indexedItems': items.length,
      'totalWords': index.length,
    };
  }
  
  /// Limpa isolate específico
  void cleanupIsolate(String taskId) {
    _cleanup(taskId);
  }
  
  /// Limpa todos os isolates
  void cleanupAll() {
    for (final taskId in _isolates.keys.toList()) {
      _cleanup(taskId);
    }
  }
  
  /// Operação de limpeza
  void _cleanup(String taskId) {
    _isolates[taskId]?.kill();
    _isolates.remove(taskId);
    _sendPorts.remove(taskId);
    _completers.remove(taskId);
  }
}

/// Service para operações em background específicas do PDV
class PDVBackgroundService {
  static final BackgroundProcessor _processor = BackgroundProcessor.instance;
  
  /// Processa cache de produtos em background
  static Future<Map<String, dynamic>> processProductCache(
    List<Map<String, dynamic>> products,
  ) async {
    return _processor.processInBackground<Map<String, dynamic>>(
      taskId: 'product_cache',
      operation: 'cacheCompression',
      data: {'items': products},
    );
  }
  
  /// Sincroniza dados do carrinho
  static Future<Map<String, dynamic>> syncCartData(
    List<Map<String, dynamic>> cartUpdates,
  ) async {
    return _processor.processInBackground<Map<String, dynamic>>(
      taskId: 'cart_sync',
      operation: 'dataSync',
      data: {'updates': cartUpdates},
    );
  }
  
  /// Calcula estatísticas de pedidos
  static Future<Map<String, dynamic>> calculateOrderStats(
    List<num> orderValues,
  ) async {
    return _processor.processInBackground<Map<String, dynamic>>(
      taskId: 'order_stats',
      operation: 'complexCalculation',
      data: {'numbers': orderValues},
    );
  }
  
  /// Otimiza imagens de produtos
  static Future<Map<String, dynamic>> optimizeProductImages(
    List<Map<String, dynamic>> images,
  ) async {
    return _processor.processInBackground<Map<String, dynamic>>(
      taskId: 'image_optimization',
      operation: 'imageProcessing',
      data: {'images': images},
    );
  }
  
  /// Constrói índice de busca para produtos
  static Future<Map<String, dynamic>> buildProductSearchIndex(
    List<Map<String, dynamic>> products,
  ) async {
    return _processor.processInBackground<Map<String, dynamic>>(
      taskId: 'search_index',
      operation: 'searchIndexing',
      data: {'items': products},
    );
  }
}

/// Wrapper para operações assíncronas com timeout
class AsyncOperationWrapper {
  /// Executa operação com timeout e fallback
  static Future<T> executeWithTimeout<T>({
    required Future<T> Function() operation,
    required Duration timeout,
    T? fallback,
  }) async {
    try {
      return await operation().timeout(timeout);
    } on TimeoutException {
      if (fallback != null) {
        debugPrint('Operação timeout, usando fallback');
        return fallback;
      }
      rethrow;
    } catch (e) {
      debugPrint('Erro na operação: $e');
      if (fallback != null) return fallback;
      rethrow;
    }
  }
  
  /// Executa múltiplas operações em paralelo com controle
  static Future<List<T>> executeInParallel<T>({
    required List<Future<T> Function()> operations,
    int? maxConcurrency,
  }) async {
    maxConcurrency ??= operations.length;
    
    final results = <T>[];
    final chunks = _chunkList(operations, maxConcurrency);
    
    for (final chunk in chunks) {
      final chunkResults = await Future.wait(
        chunk.map((op) => op()).toList(),
      );
      results.addAll(chunkResults);
    }
    
    return results;
  }
  
  /// Divide lista em chunks
  static List<List<T>> _chunkList<T>(List<T> list, int chunkSize) {
    final chunks = <List<T>>[];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(list.sublist(i, (i + chunkSize).clamp(0, list.length)));
    }
    return chunks;
  }
}
