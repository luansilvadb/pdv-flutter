import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../features/orders/domain/entities/order_entity.dart';
import '../../features/orders/presentation/providers/orders_provider.dart';
import '../../features/orders/presentation/widgets/order_card.dart';
import '../../features/orders/presentation/widgets/order_filters.dart';
import '../../features/orders/presentation/widgets/order_statistics.dart';

/// Tela de histórico de pedidos com funcionalidade de scroll em toda a tela
/// 
/// Melhorias implementadas para scroll:
/// - SingleChildScrollView envolvendo toda a tela para scroll completo
/// - Column ao invés de ListView.builder na lista de pedidos
/// - ConstrainedBox para garantir altura mínima adequada
/// - AlwaysScrollableScrollPhysics para scroll sempre ativo
/// - Layout responsivo que se adapta ao tamanho da tela
/// - Remoção de Expanded/Flexible para permitir scroll natural
class OrderHistoryScreen extends ConsumerStatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  ConsumerState<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends ConsumerState<OrderHistoryScreen> {
  bool _hasInitialized = false;
  // Controlador para manter o estado de scroll
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Carrega os pedidos apenas uma vez quando a tela é inicializada
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasInitialized) {
        ref.read(ordersNotifierProvider.notifier).loadAllOrders();
        _hasInitialized = true;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(ordersListProvider);
    final isLoading = ref.watch(isLoadingOrdersProvider);
    final error = ref.watch(ordersErrorProvider);
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.background,
            AppColors.background.withValues(alpha: 0.95),
            AppColors.surfaceVariant.withValues(alpha: 0.1),
          ],
        ),      ),
      // Toda a tela agora é scrollável
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: screenHeight,
          ),
          child: screenHeight < 650 // Ajustado o threshold
            ? _buildCompactLayout(context, orders, isLoading, error)
            : _buildNormalLayout(context, orders, isLoading, error),
        ),
      ),
    );
  }
  
  Widget _buildCompactLayout(
    BuildContext context,
    List<OrderEntity> orders,
    bool isLoading,
    String? error,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Compact Header
        _buildCompactHeader(context),
        
        // Order Filters only (skip statistics on small screens)
        const OrderFilters(),
        
        // Orders Content - agora não usa Expanded
        _buildContent(context, orders, isLoading, error),
      ],
    );  }
  
  Widget _buildNormalLayout(
    BuildContext context,
    List<OrderEntity> orders,
    bool isLoading,
    String? error,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Enhanced Header
        _buildEnhancedHeader(context),

        // Order Statistics - only show if screen has enough space
        if (MediaQuery.of(context).size.height > 700)
          const OrderStatistics(),

        // Order Filters
        const OrderFilters(),

        // Orders Content - agora não usa Expanded
        _buildContent(context, orders, isLoading, error),
      ],    );
  }
  Widget _buildEnhancedHeader(BuildContext context) {
    final now = DateTime.now();
    final dateFormatter = DateFormat('dd/MM/yyyy', 'pt_BR');
    final timeFormatter = DateFormat('HH:mm', 'pt_BR');

    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSizes.paddingLarge, 
        AppSizes.paddingMedium, // Reduzido margin top
        AppSizes.paddingLarge, 
        AppSizes.paddingMedium  // Reduzido margin bottom
      ),
      padding: const EdgeInsets.all(AppSizes.paddingMedium), // Reduzido padding
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceElevated,
            AppColors.surfaceContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restaurant info and date/time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.secondaryAccent.withValues(alpha: 0.2),
                                AppColors.secondaryAccent.withValues(alpha: 0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusSmall,
                            ),
                          ),
                          child: Icon(
                            FluentIcons.history,
                            color: AppColors.secondaryAccent,
                            size: AppSizes.iconSmall,
                          ),                        ),
                        const SizedBox(width: AppSizes.paddingMedium),
                        Flexible(
                          child: Text(
                            'Histórico de Pedidos',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 20, // Reduzido de 24 para 20
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2), // Reduzido de 4 para 2
                    Text(
                      'Visualize e gerencie pedidos anteriores',
                      style: TextStyle(
                        color: AppColors.secondaryAccent,
                        fontSize: 12, // Reduzido de 14 para 12
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSizes.paddingLarge),
              Container(
                padding: const EdgeInsets.all(AppSizes.paddingMedium),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.surfaceVariant.withValues(alpha: 0.3),
                      AppColors.surfaceVariant.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  border: Border.all(
                    color: AppColors.border.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          FluentIcons.calendar,
                          color: AppColors.textSecondary,
                          size: AppSizes.iconSmall,
                        ),
                        const SizedBox(width: AppSizes.paddingSmall),
                        Text(
                          dateFormatter.format(now),
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          FluentIcons.clock,
                          color: AppColors.secondaryAccent,
                          size: AppSizes.iconSmall,
                        ),
                        const SizedBox(width: AppSizes.paddingSmall),
                        Text(
                          timeFormatter.format(now),
                          style: TextStyle(
                            color: AppColors.secondaryAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),            ],
          ),

          const SizedBox(height: AppSizes.paddingMedium), // Reduzido de paddingLarge

          // Action buttons
          Row(
            children: [
              FilledButton(
                onPressed: () {
                  ref.read(ordersNotifierProvider.notifier).loadAllOrders();
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    AppColors.secondaryAccent.withValues(alpha: 0.1),
                  ),
                  foregroundColor: WidgetStateProperty.all(
                    AppColors.secondaryAccent,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(FluentIcons.refresh, size: AppSizes.iconSmall),
                    const SizedBox(width: AppSizes.paddingSmall),
                    const Text('Atualizar'),
                  ],
                ),
              ),
              const SizedBox(width: AppSizes.paddingMedium),
              Button(
                onPressed: () {
                  ref.read(ordersNotifierProvider.notifier).loadTodayOrders();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(FluentIcons.calendar_day, size: AppSizes.iconSmall),
                    const SizedBox(width: AppSizes.paddingSmall),
                    const Text('Hoje'),
                  ],
                ),
              ),
              const SizedBox(width: AppSizes.paddingSmall),
              Button(
                onPressed: () {
                  ref.read(ordersNotifierProvider.notifier).loadThisWeekOrders();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(FluentIcons.calendar_week, size: AppSizes.iconSmall),
                    const SizedBox(width: AppSizes.paddingSmall),
                    const Text('Esta Semana'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSizes.paddingMedium),
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.secondaryAccent.withValues(alpha: 0.2),
                  AppColors.secondaryAccent.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            ),
            child: Icon(
              FluentIcons.history,
              color: AppColors.secondaryAccent,
              size: AppSizes.iconMedium,
            ),
          ),
          const SizedBox(width: AppSizes.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Histórico de Pedidos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Gerencie seus pedidos',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: () {
              ref.read(ordersNotifierProvider.notifier).loadAllOrders();
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                AppColors.secondaryAccent.withValues(alpha: 0.1),
              ),
              foregroundColor: WidgetStateProperty.all(
                AppColors.secondaryAccent,
              ),
            ),
            child: Icon(FluentIcons.refresh, size: AppSizes.iconSmall),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<OrderEntity> orders,
    bool isLoading,
    String? error,
  ) {
    if (isLoading) {
      return const Center(child: ProgressRing());
    }

    if (error != null) {
      return _buildErrorState(error);
    }

    if (orders.isEmpty) {
      return _buildEmptyState(context);
    }

    return _buildOrdersList(context, orders);
  }  Widget _buildErrorState(String error) {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FluentIcons.error, size: 64, color: AppColors.error),
            const SizedBox(height: AppSizes.paddingLarge),
            Text(
              'Erro ao carregar pedidos',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.paddingMedium),
            Text(
              error,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.paddingLarge),
            FilledButton(
              onPressed: () {
                ref.read(ordersNotifierProvider.notifier).loadAllOrders();
              },
              child: const Text('Tentar Novamente'),
            ),
          ],
        ),
      ),
    );
  }  Widget _buildEmptyState(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingXLarge),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    AppColors.surfaceVariant.withValues(alpha: 0.3),
                    AppColors.surfaceVariant.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppSizes.radiusXLarge),
                border: Border.all(
                  color: AppColors.border.withValues(alpha: 0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowLight,
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(
                FluentIcons.history,
                size: 60,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: AppSizes.paddingLarge),
            Text(
              'Nenhum pedido encontrado',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.paddingMedium),
            Text(
              'Quando você fizer pedidos, eles aparecerão aqui\npara fácil consulta e gestão',
              style: TextStyle(
                color: AppColors.textTertiary,
                fontSize: 14,
                height: 1.4,
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }Widget _buildOrdersList(BuildContext context, List<OrderEntity> orders) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 2.0,
          colors: [
            AppColors.surfaceVariant.withValues(alpha: 0.05),
            AppColors.background,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int index = 0; index < orders.length; index++)
              Padding(
                padding: EdgeInsets.only(
                  bottom: index < orders.length - 1 
                      ? AppSizes.paddingSmall
                      : AppSizes.paddingMedium,
                ),
                child: OrderCard(order: orders[index]),              ),
          ],
        ),
      ),
    );
  }
}
