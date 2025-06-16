import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';

/// Sistema de cache inteligente com LRU e TTL para otimizar performance
/// 
/// Este cache mantém os dados mais frequentemente acessados em memória,
/// com limpeza automática de itens antigos e limite de tamanho.
class SmartCache<K, V> {
  final int _maxSize;
  final Duration _ttl;
  final LinkedHashMap<K, _CacheEntry<V>> _cache = LinkedHashMap();
  Timer? _cleanupTimer;

  SmartCache({
    int maxSize = 100,
    Duration ttl = const Duration(minutes: 10),
  })  : _maxSize = maxSize,
        _ttl = ttl {
    _startCleanupTimer();
  }

  /// Obtém um item do cache
  V? get(K key) {
    final entry = _cache[key];
    if (entry == null) return null;

    // Verifica se expirou
    if (entry.isExpired) {
      _cache.remove(key);
      return null;
    }

    // Move para o final (LRU)
    _cache.remove(key);
    _cache[key] = entry.copyWith(lastAccessed: DateTime.now());
    
    return entry.value;
  }

  /// Armazena um item no cache
  void put(K key, V value) {
    // Remove item existente se houver
    _cache.remove(key);

    // Adiciona novo item
    final entry = _CacheEntry(
      value: value,
      timestamp: DateTime.now(),
      lastAccessed: DateTime.now(),
    );
    _cache[key] = entry;

    // Remove itens mais antigos se necessário
    _evictIfNeeded();
  }

  /// Remove um item específico
  void remove(K key) {
    _cache.remove(key);
  }

  /// Limpa todo o cache
  void clear() {
    _cache.clear();
  }

  /// Obtém ou calcula um valor com cache
  Future<V> getOrCompute(K key, Future<V> Function() computer) async {
    final cached = get(key);
    if (cached != null) return cached;

    final computed = await computer();
    put(key, computed);
    return computed;
  }

  /// Número de itens no cache
  int get size => _cache.length;

  /// Verifica se o cache está vazio
  bool get isEmpty => _cache.isEmpty;
  /// Estatísticas do cache
  CacheStats get stats {
    var expired = 0;
    var total = _cache.length;

    for (final entry in _cache.values) {
      if (entry.isExpired) expired++;
    }

    return CacheStats(
      totalItems: total,
      expiredItems: expired,
      hitRatio: total > 0 ? (total - expired) / total : 0.0,
    );
  }

  /// Remove itens se o cache estiver cheio
  void _evictIfNeeded() {
    while (_cache.length > _maxSize) {
      final firstKey = _cache.keys.first;
      _cache.remove(firstKey);
    }
  }

  /// Inicia timer para limpeza automática
  void _startCleanupTimer() {
    _cleanupTimer = Timer.periodic(
      Duration(minutes: _ttl.inMinutes ~/ 2),
      (_) => _cleanup(),
    );
  }

  /// Remove itens expirados
  void _cleanup() {
    final keysToRemove = <K>[];
    
    for (final entry in _cache.entries) {
      if (entry.value.isExpired) {
        keysToRemove.add(entry.key);
      }
    }

    for (final key in keysToRemove) {
      _cache.remove(key);
    }

    debugPrint('Cache cleanup: removed ${keysToRemove.length} expired items');
  }

  /// Libera recursos
  void dispose() {
    _cleanupTimer?.cancel();
    _cache.clear();
  }
}

/// Entrada do cache com metadados
class _CacheEntry<V> {
  final V value;
  final DateTime timestamp;
  final DateTime lastAccessed;

  const _CacheEntry({
    required this.value,
    required this.timestamp,
    required this.lastAccessed,
  });

  /// Verifica se a entrada expirou
  bool get isExpired {
    final now = DateTime.now();
    const maxAge = Duration(minutes: 10);
    return now.difference(timestamp) > maxAge;
  }

  /// Cria uma cópia com novos metadados
  _CacheEntry<V> copyWith({
    V? value,
    DateTime? timestamp,
    DateTime? lastAccessed,
  }) {
    return _CacheEntry(
      value: value ?? this.value,
      timestamp: timestamp ?? this.timestamp,
      lastAccessed: lastAccessed ?? this.lastAccessed,
    );
  }
}

/// Estatísticas do cache
class CacheStats {
  final int totalItems;
  final int expiredItems;
  final double hitRatio;

  const CacheStats({
    required this.totalItems,
    required this.expiredItems,
    required this.hitRatio,
  });

  @override
  String toString() {
    return 'CacheStats(total: $totalItems, expired: $expiredItems, hitRatio: ${(hitRatio * 100).toStringAsFixed(1)}%)';
  }
}

/// Cache global para produtos
class ProductCache {
  static final SmartCache<String, dynamic> _instance = SmartCache(
    maxSize: 200,
    ttl: const Duration(minutes: 15),
  );
  static V? get<V>(String key) => _instance.get(key) as V?;
  static void put<V>(String key, V value) => _instance.put(key, value);
  static void remove(String key) => _instance.remove(key);
  static Future<V> getOrCompute<V>(String key, Future<V> Function() computer) async {
    final cached = _instance.get(key);
    if (cached != null) return cached as V;
    
    final computed = await computer();
    _instance.put(key, computed);
    return computed;
  }
  static void clear() => _instance.clear();
  static CacheStats get stats => _instance.stats;
}

/// Cache para imagens
class ImageCache {
  static final SmartCache<String, Uint8List> _instance = SmartCache(
    maxSize: 50,
    ttl: const Duration(hours: 1),
  );

  static Uint8List? getImageBytes(String url) => _instance.get(url);
  static void putImageBytes(String url, Uint8List bytes) => _instance.put(url, bytes);
  static void clear() => _instance.clear();
}

/// Cache para carrinho e pedidos
class StateCache {
  static final SmartCache<String, dynamic> _instance = SmartCache(
    maxSize: 100,
    ttl: const Duration(minutes: 30),
  );

  static V? get<V>(String key) => _instance.get(key) as V?;
  static void put<V>(String key, V value) => _instance.put(key, value);
  static void remove(String key) => _instance.remove(key);
  static void clear() => _instance.clear();
}
