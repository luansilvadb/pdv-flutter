import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dashboard_provider.dart';
import '../../../../core/constants/app_constants.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kpis = ref.watch(dashboardProvider);

    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('Dashboard Gerencial')),
      children: [
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 4,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _buildKPICard('Faturamento do Dia', 'R\$ ${kpis.dailyRevenue.toStringAsFixed(2)}', FluentIcons.money, AppColors.success),
            _buildKPICard('Pedidos Ativos', kpis.activeOrdersCount.toString(), FluentIcons.delivery_truck, AppColors.info),
            _buildKPICard('Ticket Médio', 'R\$ ${kpis.averageTicket.toStringAsFixed(2)}', FluentIcons.calculator, AppColors.secondaryAccent),
            _buildKPICard('Alertas de Estoque', kpis.lowStockAlerts.toString(), FluentIcons.warning, kpis.lowStockAlerts > 0 ? AppColors.error : AppColors.success),
          ],
        ),
        const SizedBox(height: 32),
        const Text('Indicadores em Tempo Real', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildKPICard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
