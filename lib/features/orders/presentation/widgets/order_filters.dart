import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/order_entity.dart';
import '../providers/orders_provider.dart';

/// Widget para filtros de pedidos
class OrderFilters extends ConsumerWidget {
  const OrderFilters({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {    return Container(
      margin: const EdgeInsets.only(
        left: AppSizes.paddingLarge,
        right: AppSizes.paddingLarge,
        bottom: AppSizes.paddingSmall, // Reduzido
      ),
      padding: const EdgeInsets.all(AppSizes.paddingSmall), // Reduzido ainda mais
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceElevated.withValues(alpha: 0.7),
            AppColors.surfaceContainer.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryAccent.withValues(alpha: 0.2),
                      AppColors.primaryAccent.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                ),
                child: Icon(
                  FluentIcons.filter,
                  color: AppColors.primaryAccent,
                  size: 16,
                ),
              ),
              const SizedBox(width: AppSizes.paddingMedium),
              Text(
                'Filtros',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppSizes.paddingMedium),
          
          // Filter buttons
          Wrap(
            spacing: AppSizes.paddingSmall,
            runSpacing: AppSizes.paddingSmall,
            children: [
              _buildFilterButton(
                'Todos',
                null,
                ref,
                icon: FluentIcons.all_apps,
              ),
              _buildFilterButton(
                'Pendente',
                OrderStatus.pending,
                ref,
                icon: FluentIcons.clock,
              ),
              _buildFilterButton(
                'Processando',
                OrderStatus.processing,
                ref,
                icon: FluentIcons.processing,
              ),
              _buildFilterButton(
                'Concluído',
                OrderStatus.completed,
                ref,
                icon: FluentIcons.completed,
              ),
              _buildFilterButton(
                'Cancelado',
                OrderStatus.cancelled,
                ref,
                icon: FluentIcons.cancel,
              ),
            ],
          ),
          
          const SizedBox(height: AppSizes.paddingMedium),
          
          // Period filters
          Row(
            children: [
              Expanded(
                child: Button(
                  onPressed: () {
                    ref.read(ordersNotifierProvider.notifier).loadTodayOrders();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(FluentIcons.calendar_day, size: 14),
                      const SizedBox(width: AppSizes.paddingSmall),
                      const Text('Hoje', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.paddingSmall),
              Expanded(
                child: Button(
                  onPressed: () {
                    ref.read(ordersNotifierProvider.notifier).loadThisWeekOrders();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(FluentIcons.calendar_week, size: 14),
                      const SizedBox(width: AppSizes.paddingSmall),
                      const Text('Semana', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.paddingSmall),
              Expanded(
                child: Button(
                  onPressed: () {
                    ref.read(ordersNotifierProvider.notifier).loadThisMonthOrders();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(FluentIcons.calendar, size: 14),
                      const SizedBox(width: AppSizes.paddingSmall),
                      const Text('Mês', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(
    String label,
    OrderStatus? status,
    WidgetRef ref, {
    required IconData icon,
  }) {
    return Button(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingMedium,
            vertical: AppSizes.paddingSmall,
          ),
        ),
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.hovered)) {
            return AppColors.primaryAccent.withValues(alpha: 0.1);
          }
          return Colors.transparent;
        }),
        foregroundColor: WidgetStateProperty.all(AppColors.textSecondary),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            side: BorderSide(
              color: AppColors.border.withValues(alpha: 0.3),
            ),
          ),
        ),
      ),
      onPressed: () {
        ref.read(ordersNotifierProvider.notifier).filterOrdersByStatus(status);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: AppSizes.paddingSmall),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
