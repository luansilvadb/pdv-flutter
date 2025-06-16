import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:provider/provider.dart'; // COMENTADO - Provider antigo
import '../features/products/domain/entities/product_entity.dart';
import '../core/constants/app_constants.dart';
import '../core/performance/optimized_providers.dart';
import '../features/cart/presentation/providers/cart_provider.dart';
import 'package:intl/intl.dart';

/// Widget ProductCard migrado para nova arquitetura Clean Architecture + Riverpod
///
/// Mudanças principais:
/// - ProductEntity ao invés de Product antigo
/// - Consumer Riverpod ao invés de Provider
/// - CartProvider novo (Riverpod) para adicionar produtos
/// - Mantém visual e funcionalidade idênticos
class ProductCard extends ConsumerStatefulWidget {
  final ProductEntity product;

  const ProductCard({super.key, required this.product});

  @override
  ConsumerState<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends ConsumerState<ProductCard>
    with TickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: AppSizes.animationFast,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() => _isPressed = true);

    // Efeito mais suave ao adicionar
    _scaleController.forward().then((_) {
      _scaleController.reverse();
    });

    // MIGRADO: Usar CartProvider Riverpod ao invés do Provider antigo
    ref
        .read(cartProvider.notifier)
        .addProduct(
          productId: widget.product.id,
          productName: widget.product.name,
          price: widget.product.priceAsMoney,
          productImageUrl: widget.product.imageUrl,
        );

    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) {
        setState(() => _isPressed = false);
      }
    });
  }

  void _handleHoverEnter() {
    setState(() => _isHovered = true);
    _scaleController.forward();
  }

  void _handleHoverExit() {
    setState(() => _isHovered = false);
    _scaleController.reverse();
  }
  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      symbol: 'R\$',
      decimalDigits: 2,
      locale: 'pt_BR',
    );

    // Otimização: Observa apenas se o produto está no carrinho
    final isInCart = ref.watch(isProductInCartOptimizedProvider(widget.product.id));

    return RepaintBoundary(
      // RepaintBoundary isola repaints deste widget
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: MouseRegion(
              onEnter: (_) => _handleHoverEnter(),
              onExit: (_) => _handleHoverExit(),
              child: GestureDetector(
                onTap: widget.product.availableQuantity > 0 ? _handleTap : null,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: _getCardGradient(),
                    ),
                    borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                    border: Border.all(
                      color: _getBorderColor(),
                      width: _isHovered ? 2.0 : 1.0,
                    ),
                    boxShadow: _getBoxShadow(),
                  ),
                  child: Stack(
                    children: [
                      // Main content
                      _buildCardContent(currencyFormatter),

                      // Overlay when out of stock
                      if (widget.product.availableQuantity == 0)
                        _buildOutOfStockOverlay(),
                        
                      // Indicador se está no carrinho
                      if (isInCart)
                        _buildInCartIndicator(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildCardContent(NumberFormat currencyFormatter) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced Product Image
          Expanded(flex: 3, child: _buildProductImage()),

          const SizedBox(height: AppSizes.paddingMedium),

          // Enhanced Product Name
          Expanded(flex: 1, child: _buildProductName()),

          const SizedBox(height: AppSizes.paddingSmall),

          // Enhanced Price and Quantity Row
          _buildPriceQuantityRow(currencyFormatter),

          const SizedBox(height: AppSizes.paddingSmall),

          // Add to Cart Button
          _buildAddToCartButton(),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceVariant,
            AppColors.surfaceVariant.withValues(alpha: 0.7),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: Stack(
          children: [
            // Placeholder or actual image
            Center(
              child:
                  widget.product.imageUrl.startsWith('assets/')
                      ? Image.asset(
                        widget.product.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.surfaceVariant,
                                  AppColors.surfaceVariant.withValues(
                                    alpha: 0.5,
                                  ),
                                ],
                              ),
                            ),
                            child: Icon(
                              FluentIcons.photo2,
                              color: AppColors.textTertiary,
                              size: AppSizes.iconLarge,
                            ),
                          );
                        },
                      )
                      : Image.network(
                        widget.product.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.surfaceVariant,
                                  AppColors.surfaceVariant.withValues(
                                    alpha: 0.5,
                                  ),
                                ],
                              ),
                            ),
                            child: Icon(
                              FluentIcons.photo2,
                              color: AppColors.textTertiary,
                              size: AppSizes.iconLarge,
                            ),
                          );
                        },
                      ),
            ),

            // Category badge - MIGRADO: usar categoryId da ProductEntity
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                  border: Border.all(
                    color: AppColors.border.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  widget
                      .product
                      .categoryId, // MIGRADO: categoryId da ProductEntity
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductName() {
    return Text(
      widget.product.name,
      style: TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
        fontSize: 15,
        letterSpacing: 0.3,
        height: 1.2,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPriceQuantityRow(NumberFormat currencyFormatter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Enhanced Price
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.priceColor.withValues(alpha: 0.1),
                  AppColors.priceColor.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              border: Border.all(
                color: AppColors.priceColor.withValues(alpha: 0.2),
              ),
            ),
            child: Text(
              currencyFormatter.format(widget.product.price),
              style: TextStyle(
                color: AppColors.priceColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 0.3,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),

        const SizedBox(width: AppSizes.paddingSmall),

        // Enhanced Quantity Badge
        _buildQuantityBadge(),
      ],
    );
  }

  Widget _buildQuantityBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _getQuantityBadgeColor(),
            _getQuantityBadgeColor().withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        border: Border.all(
          color: _getQuantityTextColor().withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: _getQuantityTextColor().withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getQuantityIcon(), color: _getQuantityTextColor(), size: 12),
          const SizedBox(width: 4),
          Text(
            '${widget.product.availableQuantity}',
            style: TextStyle(
              color: _getQuantityTextColor(),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddToCartButton() {
    final isEnabled = widget.product.availableQuantity > 0;

    return SizedBox(
      width: double.infinity,
      height: 36,
      child: FilledButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (!isEnabled) return AppColors.surfaceVariant;
            if (states.contains(WidgetState.pressed)) {
              return AppColors.primaryAccentPressed;
            }
            if (states.contains(WidgetState.hovered)) {
              return AppColors.primaryAccentHover;
            }
            return AppColors.primaryAccent;
          }),
          foregroundColor: WidgetStateProperty.all(
            isEnabled ? Colors.white : AppColors.textTertiary,
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            ),
          ),
          elevation: WidgetStateProperty.resolveWith<double>((states) {
            if (!isEnabled) return 0;
            if (states.contains(WidgetState.pressed)) return 1;
            if (states.contains(WidgetState.hovered)) return 4;
            return 2;
          }),
        ),
        onPressed: isEnabled ? _handleTap : null,
        child: AnimatedSwitcher(
          duration: AppSizes.animationFast,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isEnabled ? FluentIcons.add : FluentIcons.blocked2,
                size: 14,
              ),
              const SizedBox(width: 6),
              Text(
                isEnabled ? 'Adicionar' : 'Indisponível',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOutOfStockOverlay() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
      child: Container(
        color: AppColors.surface.withValues(alpha: 0.8),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingMedium,
              vertical: AppSizes.paddingSmall,
            ),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              boxShadow: [
                BoxShadow(
                  color: AppColors.error.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  FluentIcons.warning,
                  color: Colors.white,
                  size: AppSizes.iconSmall,
                ),
                const SizedBox(width: AppSizes.paddingSmall),
                Text(
                  'Esgotado',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Constrói indicador visual de que o produto está no carrinho
  Widget _buildInCartIndicator() {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(          color: AppColors.primaryAccent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryAccent.withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          FluentIcons.shopping_cart,
          color: Colors.white,
          size: 12,
        ),
      ),
    );
  }

  List<Color> _getCardGradient() {
    if (widget.product.availableQuantity == 0) {
      return [
        AppColors.surface.withValues(alpha: 0.7),
        AppColors.surfaceVariant.withValues(alpha: 0.5),
      ];
    }

    if (_isPressed) {
      return [AppColors.surfaceContainer, AppColors.surfaceContainerHigh];
    }

    if (_isHovered) {
      return [AppColors.surfaceElevated, AppColors.surfaceContainer];
    }

    return [AppColors.surface, AppColors.surface.withValues(alpha: 0.9)];
  }

  Color _getBorderColor() {
    if (widget.product.availableQuantity == 0) {
      return AppColors.border.withValues(alpha: 0.3);
    }

    if (_isHovered) {
      return AppColors.primaryAccent.withValues(alpha: 0.5);
    }

    return AppColors.border.withValues(alpha: 0.5);
  }

  List<BoxShadow> _getBoxShadow() {
    if (widget.product.availableQuantity == 0) {
      return [];
    }

    if (_isPressed) {
      return [
        BoxShadow(
          color: AppColors.shadowLight,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];
    }

    if (_isHovered) {
      return [
        BoxShadow(
          color: AppColors.shadowMedium,
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: AppColors.primaryAccent.withValues(alpha: 0.2),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];
    }

    return [
      BoxShadow(
        color: AppColors.shadowLight,
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ];
  }

  Color _getQuantityBadgeColor() {
    final quantity = widget.product.availableQuantity;
    if (quantity == 0) return AppColors.error.withValues(alpha: 0.15);
    if (quantity <= 5) return AppColors.warning.withValues(alpha: 0.15);
    return AppColors.success.withValues(alpha: 0.15);
  }

  Color _getQuantityTextColor() {
    final quantity = widget.product.availableQuantity;
    if (quantity == 0) return AppColors.error;
    if (quantity <= 5) return AppColors.warning;
    return AppColors.success;
  }

  IconData _getQuantityIcon() {
    final quantity = widget.product.availableQuantity;
    if (quantity == 0) return FluentIcons.blocked2;
    if (quantity <= 5) return FluentIcons.warning;
    return FluentIcons.accept;
  }
}
