import 'package:hive_flutter/hive_flutter.dart';
import '../errors/exceptions.dart';

/// Interface para storage local
abstract class LocalStorage {
  Future<void> init();
  Future<void> store<T>(String key, T value);
  Future<T?> retrieve<T>(String key);
  Future<void> delete(String key);
  Future<void> clear();
  Future<bool> exists(String key);
  Future<List<String>> getAllKeys();
}

/// Implementação do storage local usando Hive
class HiveLocalStorage implements LocalStorage {
  static const String _boxName = 'pdv_storage';
  Box? _box;

  @override
  Future<void> init() async {
    try {
      await Hive.initFlutter();
      _box = await Hive.openBox(_boxName);
    } catch (e) {
      throw StorageException(
        message: 'Falha ao inicializar storage local',
        cause: e,
      );
    }
  }

  @override
  Future<void> store<T>(String key, T value) async {
    try {
      _ensureInitialized();
      await _box!.put(key, value);
    } catch (e) {
      throw StorageException(
        message: 'Falha ao armazenar dados para a chave: $key',
        cause: e,
      );
    }
  }

  @override
  Future<T?> retrieve<T>(String key) async {
    try {
      _ensureInitialized();
      return _box!.get(key) as T?;
    } catch (e) {
      throw StorageException(
        message: 'Falha ao recuperar dados para a chave: $key',
        cause: e,
      );
    }
  }

  @override
  Future<void> delete(String key) async {
    try {
      _ensureInitialized();
      await _box!.delete(key);
    } catch (e) {
      throw StorageException(
        message: 'Falha ao deletar dados para a chave: $key',
        cause: e,
      );
    }
  }

  @override
  Future<void> clear() async {
    try {
      _ensureInitialized();
      await _box!.clear();
    } catch (e) {
      throw StorageException(message: 'Falha ao limpar storage', cause: e);
    }
  }

  @override
  Future<bool> exists(String key) async {
    try {
      _ensureInitialized();
      return _box!.containsKey(key);
    } catch (e) {
      throw StorageException(
        message: 'Falha ao verificar existência da chave: $key',
        cause: e,
      );
    }
  }

  @override
  Future<List<String>> getAllKeys() async {
    try {
      _ensureInitialized();
      return _box!.keys.cast<String>().toList();
    } catch (e) {
      throw StorageException(
        message: 'Falha ao obter todas as chaves',
        cause: e,
      );
    }
  }

  void _ensureInitialized() {
    if (_box == null) {
      throw StorageException(
        message: 'Storage não foi inicializado. Chame init() primeiro.',
      );
    }
  }

  /// Fecha o box do Hive
  Future<void> dispose() async {
    await _box?.close();
    _box = null;
  }
}
