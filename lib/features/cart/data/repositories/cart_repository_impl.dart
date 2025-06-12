import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/domain/value_objects/quantity.dart';

import '../../domain/entities/cart_entity.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_datasource.dart';
import '../models/cart_model.dart';

/// Implementação concreta do CartRepository
class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;
  final Logger logger;

  const CartRepositoryImpl({
    required this.localDataSource,
    required this.logger,
  });

  @override
  Future<Either<Failure, CartEntity>> getCart() async {
    try {
      logger.d('Buscando carrinho...');

      final cartModel = await localDataSource.getCart();

      if (cartModel == null) {
        // Retorna carrinho vazio se não existe
        final emptyCart = CartModel.empty();
        logger.d('Carrinho não encontrado, retornando carrinho vazio');
        return Right(emptyCart.toEntity());
      }

      logger.d('Carrinho encontrado com ${cartModel.items.length} itens');
      return Right(cartModel.toEntity());
    } on CacheException catch (e) {
      logger.e('Erro de cache ao buscar carrinho', error: e);
      return Left(CacheFailure(message: e.message));
    } catch (e) {      logger.e('Erro inesperado ao buscar carrinho', error: e);
      return Left(UnknownFailure(message: 'Erro ao buscar carrinho: $e'));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> addItem(CartItemEntity item) async {
    try {
      logger.d('Adicionando item ${item.productId} ao carrinho (quantidade: ${item.quantity.value})');

      // Busca carrinho atual
      final currentCartResult = await getCart();
      if (currentCartResult.isLeft()) {
        return currentCartResult;
      }

      final currentCart = currentCartResult.getOrElse(() => throw Exception());

      // Adiciona item usando o método da entidade
      final updatedCart = currentCart.addItem(item);

      // Salva carrinho
      final cartModel = CartModel.fromEntity(updatedCart);
      await localDataSource.saveCart(cartModel);

      logger.d('Carrinho atualizado com sucesso: ${updatedCart.items.length} itens');
      return Right(updatedCart);
    } on CacheException catch (e) {
      logger.e('Erro de cache ao adicionar item', error: e);
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      logger.e('Erro inesperado ao adicionar item', error: e);
      return Left(UnknownFailure(message: 'Erro ao adicionar item: $e'));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> removeItem(String productId) async {
    try {
      logger.d('Removendo produto $productId do carrinho');

      // Busca carrinho atual
      final currentCartResult = await getCart();
      if (currentCartResult.isLeft()) {
        return currentCartResult;
      }

      final currentCart = currentCartResult.getOrElse(() => throw Exception());

      // Remove item usando método da entidade
      final updatedCart = currentCart.removeItem(productId);

      // Salva carrinho
      final cartModel = CartModel.fromEntity(updatedCart);
      await localDataSource.saveCart(cartModel);

      logger.d('Produto removido com sucesso: ${updatedCart.items.length} itens restantes');
      return Right(updatedCart);
    } on CacheException catch (e) {
      logger.e('Erro de cache ao remover item', error: e);
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      logger.e('Erro inesperado ao remover item', error: e);
      return Left(UnknownFailure(message: 'Erro ao remover item: $e'));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> updateQuantity({
    required String productId,
    required Quantity quantity,
  }) async {
    try {
      logger.d('Atualizando quantidade do produto $productId para ${quantity.value}');

      // Busca carrinho atual
      final currentCartResult = await getCart();
      if (currentCartResult.isLeft()) {
        return currentCartResult;
      }

      final currentCart = currentCartResult.getOrElse(() => throw Exception());

      // Atualiza quantidade usando método da entidade
      final updatedCart = currentCart.updateItemQuantity(productId, quantity);

      // Salva carrinho
      final cartModel = CartModel.fromEntity(updatedCart);
      await localDataSource.saveCart(cartModel);

      logger.d('Quantidade atualizada com sucesso');
      return Right(updatedCart);
    } on CacheException catch (e) {
      logger.e('Erro de cache ao atualizar quantidade', error: e);
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      logger.e('Erro inesperado ao atualizar quantidade', error: e);
      return Left(UnknownFailure(message: 'Erro ao atualizar quantidade: $e'));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> incrementQuantity(String productId) async {
    try {
      // Busca carrinho atual
      final currentCartResult = await getCart();
      if (currentCartResult.isLeft()) {
        return currentCartResult;
      }

      final currentCart = currentCartResult.getOrElse(() => throw Exception());

      // Encontra o item
      final item = currentCart.findItemByProductId(productId);
      if (item == null) {
        logger.w('Produto $productId não encontrado no carrinho');
        return Left(NotFoundFailure(message: 'Produto não encontrado no carrinho'));
      }

      // Incrementa a quantidade
      final newQuantity = Quantity(item.quantity.value + 1);
      return updateQuantity(productId: productId, quantity: newQuantity);
    } catch (e) {
      logger.e('Erro ao incrementar quantidade', error: e);
      return Left(UnknownFailure(message: 'Erro ao incrementar quantidade: $e'));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> decrementQuantity(String productId) async {
    try {
      // Busca carrinho atual
      final currentCartResult = await getCart();
      if (currentCartResult.isLeft()) {
        return currentCartResult;
      }

      final currentCart = currentCartResult.getOrElse(() => throw Exception());

      // Encontra o item
      final item = currentCart.findItemByProductId(productId);
      if (item == null) {
        logger.w('Produto $productId não encontrado no carrinho');
        return Left(NotFoundFailure(message: 'Produto não encontrado no carrinho'));
      }

      // Decrementa a quantidade
      final newQuantityValue = item.quantity.value - 1;
      if (newQuantityValue <= 0) {
        // Remove o item se quantidade chegar a zero
        return removeItem(productId);
      }

      final newQuantity = Quantity(newQuantityValue);
      return updateQuantity(productId: productId, quantity: newQuantity);
    } catch (e) {
      logger.e('Erro ao decrementar quantidade', error: e);
      return Left(UnknownFailure(message: 'Erro ao decrementar quantidade: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearCart() async {
    try {
      logger.d('Limpando carrinho');

      final emptyCart = CartModel.empty();
      await localDataSource.saveCart(emptyCart);

      logger.d('Carrinho limpo com sucesso');
      return const Right(unit);
    } on CacheException catch (e) {
      logger.e('Erro de cache ao limpar carrinho', error: e);
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      logger.e('Erro inesperado ao limpar carrinho', error: e);
      return Left(UnknownFailure(message: 'Erro ao limpar carrinho: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveCart(CartEntity cart) async {
    try {
      logger.d('Salvando carrinho');

      final cartModel = CartModel.fromEntity(cart);
      await localDataSource.saveCart(cartModel);

      logger.d('Carrinho salvo com sucesso');
      return const Right(unit);
    } on CacheException catch (e) {
      logger.e('Erro de cache ao salvar carrinho', error: e);
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      logger.e('Erro inesperado ao salvar carrinho', error: e);
      return Left(UnknownFailure(message: 'Erro ao salvar carrinho: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> containsProduct(String productId) async {
    try {
      final currentCartResult = await getCart();
      if (currentCartResult.isLeft()) {
        return currentCartResult.map((_) => false);
      }

      final currentCart = currentCartResult.getOrElse(() => throw Exception());
      final contains = currentCart.containsProduct(productId);

      return Right(contains);
    } catch (e) {
      logger.e('Erro ao verificar se carrinho contém produto', error: e);
      return Left(UnknownFailure(message: 'Erro ao verificar produto: $e'));
    }
  }

  @override
  Future<Either<Failure, Quantity>> getProductQuantity(String productId) async {
    try {
      final currentCartResult = await getCart();
      if (currentCartResult.isLeft()) {
        return currentCartResult.map((_) => Quantity.zero);
      }

      final currentCart = currentCartResult.getOrElse(() => throw Exception());
      final item = currentCart.findItemByProductId(productId);

      return Right(item?.quantity ?? Quantity.zero);
    } catch (e) {
      logger.e('Erro ao obter quantidade do produto', error: e);
      return Left(UnknownFailure(message: 'Erro ao obter quantidade: $e'));
    }
  }
}
