import 'package:logger/logger.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/local_storage.dart';
import '../models/cart_model.dart';
import 'cart_local_datasource.dart';

/// Implementação da persistência local do carrinho usando Hive
class CartLocalDataSourceImpl implements CartLocalDataSource {
  static const String _cartKey = 'current_cart';
  static const String _lastModifiedKey = 'cart_last_modified';

  final LocalStorage localStorage;
  final Logger logger;

  const CartLocalDataSourceImpl({
    required this.localStorage,
    required this.logger,
  });
  @override
  Future<CartModel?> getCart() async {
    try {
      logger.d('Buscando carrinho no storage local...');

      final cartData = await localStorage.retrieve<Map<String, dynamic>>(
        _cartKey,
      );

      if (cartData == null) {
        logger.d('Nenhum carrinho encontrado no storage local');
        return null;
      }

      final cart = CartModel.fromJson(cartData);
      logger.d('Carrinho carregado com sucesso: ${cart.items.length} itens');

      return cart;
    } catch (e, stackTrace) {
      // Se é erro de chave não encontrada, retorna null ao invés de erro
      if (e.toString().contains('Falha ao recuperar dados para a chave')) {
        logger.d('Carrinho não existe ainda no storage (primeira vez)');
        return null;
      }
      
      logger.e(
        'Erro ao buscar carrinho no storage local',
        error: e,
        stackTrace: stackTrace,
      );
      throw CacheException(message: 'Erro ao carregar carrinho: $e');
    }
  }

  @override
  Future<void> saveCart(CartModel cart) async {
    try {
      logger.d('Salvando carrinho no storage local...');

      final cartJson = cart.toJson();
      await localStorage.store(_cartKey, cartJson);

      // Salva timestamp da última modificação
      await localStorage.store(
        _lastModifiedKey,
        DateTime.now().toIso8601String(),
      );

      logger.d('Carrinho salvo com sucesso: ${cart.items.length} itens');
    } catch (e, stackTrace) {
      logger.e(
        'Erro ao salvar carrinho no storage local',
        error: e,
        stackTrace: stackTrace,
      );
      throw CacheException(message: 'Erro ao salvar carrinho: $e');
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      logger.d('Limpando carrinho do storage local...');

      await localStorage.delete(_cartKey);
      await localStorage.delete(_lastModifiedKey);

      logger.d('Carrinho limpo com sucesso');
    } catch (e, stackTrace) {
      logger.e(
        'Erro ao limpar carrinho do storage local',
        error: e,
        stackTrace: stackTrace,
      );
      throw CacheException(message: 'Erro ao limpar carrinho: $e');
    }
  }

  @override
  Future<bool> hasCart() async {
    try {
      logger.d('Verificando se existe carrinho no storage local...');

      final hasCart = await localStorage.exists(_cartKey);

      logger.d('Carrinho existe: $hasCart');
      return hasCart;
    } catch (e, stackTrace) {
      logger.e(
        'Erro ao verificar existência do carrinho',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  @override
  Future<DateTime?> getLastModified() async {
    try {
      logger.d('Buscando última modificação do carrinho...');

      final lastModifiedData = await localStorage.retrieve<String>(
        _lastModifiedKey,
      );

      if (lastModifiedData == null) {
        logger.d('Nenhuma data de modificação encontrada');
        return null;
      }

      final lastModified = DateTime.parse(lastModifiedData);
      logger.d('Última modificação: $lastModified');

      return lastModified;
    } catch (e, stackTrace) {
      logger.e(
        'Erro ao buscar última modificação do carrinho',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }
}
