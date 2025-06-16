import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/products/domain/entities/product_entity.dart';
import '../../features/cart/presentation/providers/optimized_cart_providers.dart';
import '../../widgets/product_card.dart';
import '../constants/app_constants.dart';
import '../performance/optimized_providers.dart';

/// GridView otimizado para produtos com performance máxima
/// 
/// Implementa várias otimizações:
/// - RepaintBoundary para isolamento de repaint
/// - Slivers para melhor performance de scroll
/// - Lazy building e viewport awareness
/// - Cache de widgets e reutilização
class OptimizedProductGrid extends ConsumerWidget {
  const OptimizedProductGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(optimizedProductsListProvider);
    
    if (products.isEmpty) {
      return const SliverFillRemaining(
        child: Center(child: Text('Nenhum produto encontrado')),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      sliver: SliverGrid(
        gridDelegate: _buildGridDelegate(context),
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildProductItem(products[index]),
          childCount: products.length,
          // Importante: permite reutilização de widgets
          findChildIndexCallback: (Key key) {
            if (key is ValueKey<String>) {
              final productId = key.value;
              return products.indexWhere((p) => p.id == productId);
            }
            return null;
          },
        ),
      ),
    );
  }

  /// Constrói item do produto com otimizações
  Widget _buildProductItem(ProductEntity product) {
    return RepaintBoundary(
      key: ValueKey('product-boundary-${product.id}'),
      child: ProductCard(
        product: product,
        key: ValueKey('product-${product.id}'),
      ),
    );
  }

  /// Constrói delegate do grid responsivo
  SliverGridDelegate _buildGridDelegate(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Calcula número de colunas baseado na largura da tela
    int crossAxisCount;
    double childAspectRatio;
    
    if (screenWidth > 1400) {
      crossAxisCount = 6;
      childAspectRatio = 0.85;
    } else if (screenWidth > 1200) {
      crossAxisCount = 5;
      childAspectRatio = 0.8;
    } else if (screenWidth > 900) {
      crossAxisCount = 4;
      childAspectRatio = 0.75;
    } else if (screenWidth > 600) {
      crossAxisCount = 3;
      childAspectRatio = 0.7;
    } else {
      crossAxisCount = 2;
      childAspectRatio = 0.65;
    }

    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount,
      childAspectRatio: childAspectRatio,
      crossAxisSpacing: AppSizes.paddingMedium,
      mainAxisSpacing: AppSizes.paddingMedium,
    );
  }
}

/// Lista otimizada para o carrinho com virtualização
class OptimizedCartList extends ConsumerWidget {
  const OptimizedCartList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartItemsProvider);
    
    if (cartItems.isEmpty) {
      return const Expanded(
        child: Center(child: Text('Carrinho vazio')),
      );
    }

    return Expanded(
      child: ListView.builder(
        // Configurações de performance
        physics: const BouncingScrollPhysics(),
        cacheExtent: 500, // Cache maior para melhor UX
        itemExtent: 80, // Altura fixa para melhor performance
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          
          return RepaintBoundary(
            key: ValueKey('cart-item-${item.productId}'),
            child: _CartItemTile(
              item: item,
              key: ValueKey('cart-tile-${item.productId}'),
            ),
          );
        },
      ),
    );
  }
}

/// Widget otimizado para item do carrinho
class _CartItemTile extends StatelessWidget {
  final dynamic item; // CartItemEntity
  
  const _CartItemTile({
    required this.item,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMedium,
        vertical: AppSizes.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMedium,
        ),
        title: Text(
          item.productName,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          'Qtd: ${item.quantity.value}',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        trailing: Text(
          'R\$ ${item.subtotal.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Scroll otimizado para listas grandes
class OptimizedScrollView extends StatelessWidget {
  final List<Widget> slivers;
  final ScrollController? controller;
  
  const OptimizedScrollView({
    required this.slivers,
    this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller,
      // Otimizações de scroll
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      cacheExtent: 1000, // Cache maior para melhor UX
      slivers: slivers,
    );
  }
}

/// Mixin para otimização de widgets com estado
mixin WidgetOptimizationMixin<T extends StatefulWidget> on State<T> {
  bool _isDisposed = false;
  
  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
  
  /// Verifica se o widget ainda está ativo antes de setState
  void safeSetState(VoidCallback fn) {
    if (!_isDisposed && mounted) {
      setState(fn);
    }
  }
}

/// Builder otimizado para listas condicionais
class ConditionalListBuilder extends StatelessWidget {
  final bool condition;
  final Widget Function() builder;
  final Widget Function()? fallback;
  
  const ConditionalListBuilder({
    required this.condition,
    required this.builder,
    this.fallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (condition) {
      return builder();
    }
    
    return fallback?.call() ?? const SizedBox.shrink();
  }
}

/// Widget para lazy loading de imagens
class LazyImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  
  const LazyImageWidget({
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        // Cache importante para performance
        cacheWidth: width?.toInt(),
        cacheHeight: height?.toInt(),
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    }
    
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildLoadingIndicator(loadingProgress);
      },
      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
    );
  }
  
  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      ),
      child: Icon(
        Icons.image_not_supported,
        color: AppColors.textSecondary,
        size: 32,
      ),
    );
  }
  
  Widget _buildLoadingIndicator(ImageChunkEvent progress) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      ),
      child: Center(
        child: CircularProgressIndicator(
          value: progress.expectedTotalBytes != null
              ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
              : null,
          strokeWidth: 2,
        ),
      ),
    );
  }
}
