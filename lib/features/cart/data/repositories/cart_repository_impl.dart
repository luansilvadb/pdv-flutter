import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';

import '../../../products/domain/repositories/product_repository.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_datasource.dart';

import '../models/cart_model.dart';

/// Implementação concreta do CartRepository
class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;
  final ProductRepository productRepository;
  final Logger logger;

  const CartRepositoryImpl({
    required this.localDataSource,
    required this.productRepository,
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
    } catch (e) {
      logger.e('Erro inesperado ao buscar carrinho', error: e);
      return Left(UnknownFailure(message: 'Erro ao buscar carrinho: $e'));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> addItem({
    required String productId,
    required int quantity,
  }) async {
    try {
      logger.d(
        'Adicionando produto $productId ao carrinho (quantidade: $quantity)',
      );

      // Busca o produto para validar se existe e obter dados atualizados
      final productResult = await productRepository.getProductById(productId);
      if (productResult.isLeft()) {
        logger.w('Produto $productId não encontrado');
        return Left(NotFoundFailure(message: 'Produto não encontrado'));
      }

      final product = productResult.getOrElse(() => throw Exception());

      // Busca carrinho atual
      final currentCartResult = await getCart();
      if (currentCartResult.isLeft()) {
        return currentCartResult;
      }

      final currentCart = currentCartResult.getOrElse(() => throw Exception());

      // Verifica se produto já existe no carrinho
      final existingItemIndex = currentCart.items.indexWhere(
        (item) => item.productId == productId,
      );

      List<CartItemEntity> updatedItems = List.from(currentCart.items);

      if (existingItemIndex >= 0) {
        // Atualiza quantidade do item existente
        final existingItem = updatedItems[existingItemIndex];
        final newQuantity = existingItem.quantity + quantity;

        updatedItems[existingItemIndex] = existingItem.copyWith(
          quantity: newQuantity,
          productPrice: product.price, // Atualiza preço
          productName: product.name, // Atualiza nome
          productImageUrl: product.imageUrl, // Atualiza imagem
        );

        logger.d(
          'Produto já existe no carrinho, nova quantidade: $newQuantity',
        );
      } else {
        // Adiciona novo item
        final newItem = CartItemEntity(
          id: 'item_${DateTime.now().millisecondsSinceEpoch}',
          productId: product.id,
          productName: product.name,
          productPrice: product.price,
          productImageUrl: product.imageUrl,
          quantity: quantity,
        );

        updatedItems.add(newItem);
        logger.d('Novo produto adicionado ao carrinho');
      }

      // Cria carrinho atualizado
      final updatedCart = currentCart.copyWith(
        items: updatedItems,
        updatedAt: DateTime.now(),
      );

      // Salva carrinho
      final cartModel = CartModel.fromEntity(updatedCart);
      await localDataSource.saveCart(cartModel);

      logger.d(
        'Carrinho atualizado com sucesso: ${updatedCart.items.length} itens',
      );
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

      // Remove item
      final updatedItems =
          currentCart.items
              .where((item) => item.productId != productId)
              .toList();

      // Cria carrinho atualizado
      final updatedCart = currentCart.copyWith(
        items: updatedItems,
        updatedAt: DateTime.now(),
      );

      // Salva carrinho
      final cartModel = CartModel.fromEntity(updatedCart);
      await localDataSource.saveCart(cartModel);

      logger.d(
        'Produto removido com sucesso: ${updatedCart.items.length} itens restantes',
      );
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
    required int quantity,
  }) async {
    try {
      logger.d('Atualizando quantidade do produto $productId para $quantity');

      // Se quantidade é 0, remove o item
      if (quantity <= 0) {
        return await removeItem(productId);
      }

      // Busca carrinho atual
      final currentCartResult = await getCart();
      if (currentCartResult.isLeft()) {
        return currentCartResult;
      }

      final currentCart = currentCartResult.getOrElse(() => throw Exception());

      // Encontra e atualiza item
      final itemIndex = currentCart.items.indexWhere(
        (item) => item.productId == productId,
      );

      if (itemIndex < 0) {
        logger.w('Produto $productId não encontrado no carrinho');
        return Left(
          NotFoundFailure(message: 'Item não encontrado no carrinho'),
        );
      }

      List<CartItemEntity> updatedItems = List.from(currentCart.items);
      updatedItems[itemIndex] = updatedItems[itemIndex].copyWith(
        quantity: quantity,
      );

      // Cria carrinho atualizado
      final updatedCart = currentCart.copyWith(
        items: updatedItems,
        updatedAt: DateTime.now(),
      );

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
  Future<Either<Failure, CartEntity>> incrementQuantity(
    String productId,
  ) async {
    try {
      logger.d('Incrementando quantidade do produto $productId');

      // Busca carrinho atual
      final currentCartResult = await getCart();
      if (currentCartResult.isLeft()) {
        return currentCartResult;
      }

      final currentCart = currentCartResult.getOrElse(() => throw Exception());
      final item = currentCart.findItemByProductId(productId);

      if (item == null) {
        logger.w('Produto $productId não encontrado no carrinho');
        return Left(
          NotFoundFailure(message: 'Item não encontrado no carrinho'),
        );
      }

      return await updateQuantity(
        productId: productId,
        quantity: item.quantity + 1,
      );
    } catch (e) {
      logger.e('Erro inesperado ao incrementar quantidade', error: e);
      return Left(
        UnknownFailure(message: 'Erro ao incrementar quantidade: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, CartEntity>> decrementQuantity(
    String productId,
  ) async {
    try {
      logger.d('Decrementando quantidade do produto $productId');

      // Busca carrinho atual
      final currentCartResult = await getCart();
      if (currentCartResult.isLeft()) {
        return currentCartResult;
      }

      final currentCart = currentCartResult.getOrElse(() => throw Exception());
      final item = currentCart.findItemByProductId(productId);

      if (item == null) {
        logger.w('Produto $productId não encontrado no carrinho');
        return Left(
          NotFoundFailure(message: 'Item não encontrado no carrinho'),
        );
      }

      final newQuantity = item.quantity - 1;

      return await updateQuantity(productId: productId, quantity: newQuantity);
    } catch (e) {
      logger.e('Erro inesperado ao decrementar quantidade', error: e);
      return Left(
        UnknownFailure(message: 'Erro ao decrementar quantidade: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> clearCart() async {
    try {
      logger.d('Limpando carrinho...');

      await localDataSource.clearCart();

      logger.d('Carrinho limpo com sucesso');
      return Right(unit);
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
      logger.d('Salvando carrinho...');

      final cartModel = CartModel.fromEntity(cart);
      await localDataSource.saveCart(cartModel);

      logger.d('Carrinho salvo com sucesso');
      return Right(unit);
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
      logger.d('Verificando se produto $productId está no carrinho');

      final cartResult = await getCart();
      if (cartResult.isLeft()) {
        return cartResult.fold((failure) => Left(failure), (_) => Right(false));
      }

      final cart = cartResult.getOrElse(() => throw Exception());
      final contains = cart.containsProduct(productId);

      logger.d('Produto $productId está no carrinho: $contains');
      return Right(contains);
    } catch (e) {
      logger.e('Erro inesperado ao verificar produto no carrinho', error: e);
      return Left(UnknownFailure(message: 'Erro ao verificar produto: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> getProductQuantity(String productId) async {
    try {
      logger.d('Buscando quantidade do produto $productId no carrinho');

      final cartResult = await getCart();
      if (cartResult.isLeft()) {
        return cartResult.fold((failure) => Left(failure), (_) => Right(0));
      }

      final cart = cartResult.getOrElse(() => throw Exception());
      final item = cart.findItemByProductId(productId);
      final quantity = item?.quantity ?? 0;

      logger.d('Quantidade do produto $productId: $quantity');
      return Right(quantity);
    } catch (e) {
      logger.e('Erro inesperado ao buscar quantidade do produto', error: e);
      return Left(UnknownFailure(message: 'Erro ao buscar quantidade: $e'));
    }
  }
}
