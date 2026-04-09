import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dashboard_provider.dart';
import '../../../../core/constants/app_constants.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardProvider);

    return ScaffoldPage(
      header: const PageHeader(title: Text('Dashboard Gerencial')),
      content: GridView.count(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        crossAxisCount: 4,
        crossAxisSpacing: AppSizes.paddingMedium,
        mainAxisSpacing: AppSizes.paddingMedium,
        children: [
          _buildKpiCard(
            'Faturamento Hoje',
            'R\$ ${dashboard.todaySales.toStringAsFixed(2)}',
            FluentIcons.money,
            AppColors.success,
          ),
          _buildKpiCard(
            'Pedidos Ativos',
            dashboard.activeOrders.toString(),
            FluentIcons.waitlist_confirm,
            AppColors.info,
          ),
          _buildKpiCard(
            'Ticket Médio',
            'R\$ ${dashboard.averageTicket.toStringAsFixed(2)}',
            FluentIcons.calculator,
            AppColors.secondaryAccent,
          ),
          _buildKpiCard(
            'Estoque Crítico',
            dashboard.lowStockItems.toString(),
            FluentIcons.warning,
            dashboard.lowStockItems > 0 ? AppColors.error : AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
