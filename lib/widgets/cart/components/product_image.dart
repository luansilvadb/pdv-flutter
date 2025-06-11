import 'package:fluent_ui/fluent_ui.dart';
import '../../../models/order.dart';
import '../../../constants/app_constants.dart';

/// Componente reutilizável para exibir imagem do produto no carrinho
///
/// Exibe a imagem do produto com fallback para ícone em caso de erro.
/// Suporta tanto imagens de assets quanto de rede.
class ProductImage extends StatelessWidget {
  /// Item do carrinho contendo as informações do produto
  final CartItem item;

  /// Largura da imagem (padrão: 56)
  final double width;

  /// Altura da imagem (padrão: 56)
  final double height;

  const ProductImage({
    super.key,
    required this.item,
    this.width = 56,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
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
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    return item.product.imageUrl.startsWith('assets/')
        ? Image.asset(
          item.product.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
        )
        : Image.network(
          item.product.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
        );
  }

  Widget _buildErrorWidget() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceVariant,
            AppColors.surfaceVariant.withValues(alpha: 0.5),
          ],
        ),
      ),
      child: Icon(
        FluentIcons.photo2,
        color: AppColors.textTertiary,
        size: AppSizes.iconMedium,
      ),
    );
  }
}
