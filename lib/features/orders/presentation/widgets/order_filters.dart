import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../providers/orders_provider.dart';

/// Widget para filtros de pedidos com estado visual aprimorado
class OrderFilters extends ConsumerWidget {
  const OrderFilters({super.key});  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStatusFilter = ref.watch(selectedStatusFilterProvider);
    final selectedPeriodFilter = ref.watch(selectedPeriodFilterProvider);
    final orders = ref.watch(ordersListProvider);
    final isLoading = ref.watch(isLoadingOrdersProvider);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
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
        children: [          // Header
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
              Expanded(
                child: Row(
                  children: [
                    Text(
                      'Filtros',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    if (!isLoading) ...[
                      const SizedBox(width: AppSizes.paddingSmall),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.info.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.info.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          '${orders.length} ${orders.length == 1 ? 'pedido' : 'pedidos'}',
                          style: TextStyle(
                            color: AppColors.info,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),              // Indicador de filtros ativos
              if (selectedStatusFilter != StatusFilter.all || 
                  selectedPeriodFilter != PeriodFilter.all) ...[
                const SizedBox(width: AppSizes.paddingSmall),
                Tooltip(
                  message: 'Limpar filtros',
                  child: Button(
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.all(6),
                      ),
                      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                        if (states.contains(WidgetState.hovered)) {
                          return AppColors.error.withValues(alpha: 0.1);
                        }
                        return AppColors.warning.withValues(alpha: 0.15);
                      }),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                          side: BorderSide(
                            color: AppColors.warning.withValues(alpha: 0.4),
                            width: 1,
                          ),
                        ),
                      ),
                    ),                    onPressed: () {
                      // Limpa todos os filtros - o filterWatcherProvider aplicará automaticamente
                      ref.read(selectedStatusFilterProvider.notifier).state = StatusFilter.all;
                      ref.read(selectedPeriodFilterProvider.notifier).state = PeriodFilter.all;
                    },
                    child: Icon(
                      FluentIcons.clear_filter,
                      color: AppColors.warning,
                      size: 12,
                    ),
                  ),
                ),
              ],
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
                StatusFilter.all,
                ref,
                icon: FluentIcons.all_apps,
                isSelected: selectedStatusFilter == StatusFilter.all,
              ),
              _buildFilterButton(
                'Pendente',
                StatusFilter.pending,
                ref,
                icon: FluentIcons.clock,
                isSelected: selectedStatusFilter == StatusFilter.pending,
              ),
              _buildFilterButton(
                'Processando',
                StatusFilter.processing,
                ref,
                icon: FluentIcons.processing,
                isSelected: selectedStatusFilter == StatusFilter.processing,
              ),
              _buildFilterButton(
                'Concluído',
                StatusFilter.completed,
                ref,
                icon: FluentIcons.completed,
                isSelected: selectedStatusFilter == StatusFilter.completed,
              ),
              _buildFilterButton(
                'Cancelado',
                StatusFilter.cancelled,
                ref,
                icon: FluentIcons.cancel,
                isSelected: selectedStatusFilter == StatusFilter.cancelled,
              ),
            ],
          ),          
          const SizedBox(height: AppSizes.paddingMedium),
          
          // Period filters header
          Row(
            children: [
              Icon(
                FluentIcons.calendar,
                color: AppColors.secondaryAccent,
                size: 14,
              ),
              const SizedBox(width: AppSizes.paddingSmall),
              Text(
                'Período',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppSizes.paddingSmall),

          // Period filters
          Row(
            children: [
              Expanded(
                child: _buildPeriodButton(
                  'Todos',
                  PeriodFilter.all,
                  ref,
                  icon: FluentIcons.all_apps,
                  isSelected: selectedPeriodFilter == PeriodFilter.all,
                ),
              ),
              const SizedBox(width: AppSizes.paddingSmall),
              Expanded(
                child: _buildPeriodButton(
                  'Hoje',
                  PeriodFilter.today,
                  ref,
                  icon: FluentIcons.calendar_day,
                  isSelected: selectedPeriodFilter == PeriodFilter.today,
                ),
              ),
              const SizedBox(width: AppSizes.paddingSmall),
              Expanded(
                child: _buildPeriodButton(
                  'Semana',
                  PeriodFilter.week,
                  ref,
                  icon: FluentIcons.calendar_week,
                  isSelected: selectedPeriodFilter == PeriodFilter.week,
                ),
              ),
              const SizedBox(width: AppSizes.paddingSmall),
              Expanded(
                child: _buildPeriodButton(
                  'Mês',
                  PeriodFilter.month,
                  ref,
                  icon: FluentIcons.calendar,
                  isSelected: selectedPeriodFilter == PeriodFilter.month,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }  Widget _buildFilterButton(
    String label,
    StatusFilter statusFilter,
    WidgetRef ref, {
    required IconData icon,
    required bool isSelected,
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
          if (isSelected) {
            return AppColors.primaryAccent.withValues(alpha: 0.15);
          }
          if (states.contains(WidgetState.hovered)) {
            return AppColors.primaryAccent.withValues(alpha: 0.08);
          }
          return Colors.transparent;
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (isSelected) {
            return AppColors.primaryAccent;
          }
          return AppColors.textSecondary;
        }),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            side: BorderSide(
              color: isSelected 
                  ? AppColors.primaryAccent.withValues(alpha: 0.6)
                  : AppColors.border.withValues(alpha: 0.3),
              width: isSelected ? 1.5 : 1,
            ),
          ),
        ),
      ),      onPressed: () {
        // Atualiza o filtro selecionado - o filterWatcherProvider aplicará automaticamente
        ref.read(selectedStatusFilterProvider.notifier).state = statusFilter;
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon, 
            size: 14,
            color: isSelected ? AppColors.primaryAccent : AppColors.textSecondary,
          ),
          const SizedBox(width: AppSizes.paddingSmall),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? AppColors.primaryAccent : AppColors.textSecondary,
            ),
          ),
          // Indicador visual adicional quando selecionado
          if (isSelected) ...[
            const SizedBox(width: AppSizes.paddingSmall),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.primaryAccent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPeriodButton(
    String label,
    PeriodFilter periodFilter,
    WidgetRef ref, {
    required IconData icon,
    required bool isSelected,
  }) {
    return Button(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingSmall,
            vertical: AppSizes.paddingSmall,
          ),
        ),
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (isSelected) {
            return AppColors.secondaryAccent.withValues(alpha: 0.15);
          }
          if (states.contains(WidgetState.hovered)) {
            return AppColors.secondaryAccent.withValues(alpha: 0.08);
          }
          return AppColors.surfaceVariant.withValues(alpha: 0.3);
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (isSelected) {
            return AppColors.secondaryAccent;
          }
          return AppColors.textSecondary;
        }),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            side: BorderSide(
              color: isSelected 
                  ? AppColors.secondaryAccent.withValues(alpha: 0.6)
                  : AppColors.border.withValues(alpha: 0.2),
              width: isSelected ? 1.5 : 1,
            ),
          ),
        ),
      ),      onPressed: () {
        // Atualiza o filtro selecionado - o filterWatcherProvider aplicará automaticamente
        ref.read(selectedPeriodFilterProvider.notifier).state = periodFilter;
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon, 
            size: 14,
            color: isSelected ? AppColors.secondaryAccent : AppColors.textSecondary,
          ),
          const SizedBox(width: AppSizes.paddingSmall),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.secondaryAccent : AppColors.textSecondary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Indicador visual adicional quando selecionado
          if (isSelected) ...[
            const SizedBox(width: 4),
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.secondaryAccent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
