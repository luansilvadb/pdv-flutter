import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/reports_provider.dart';
import '../../../../core/constants/app_constants.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reports = ref.watch(reportsProvider);

    return ScaffoldPage(
      header: const PageHeader(title: Text('Relatórios Detalhados')),
      content: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSalesChart(reports.salesReport),
            const SizedBox(height: 32),
            _buildProductsTable(reports.productsReport),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesChart(AsyncValue reportAsync) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Vendas por Período', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          SizedBox(
            height: 300,
            child: reportAsync.when(
              data: (report) {
                if (report == null || report.data.isEmpty) return const Center(child: Text('Sem dados'));
                return LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: true),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: report.data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.value)).toList(),
                        isCurved: true,
                        color: AppColors.primaryAccent,
                        barWidth: 4,
                        dotData: const FlDotData(show: true),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: ProgressRing()),
              error: (e, st) => Center(child: Text('Erro: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsTable(AsyncValue reportAsync) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Produtos Mais Vendidos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          reportAsync.when(
            data: (report) {
              if (report == null) return const Center(child: Text('Sem dados'));
              return Column(
                children: report.data.map<Widget>((p) => ListTile(
                  title: Text(p.label),
                  subtitle: Text('${p.count} unidades'),
                  trailing: Text('R\$ ${p.value.toStringAsFixed(2)}'),
                )).toList(),
              );
            },
            loading: () => const Center(child: ProgressRing()),
            error: (e, st) => Center(child: Text('Erro: $e')),
          ),
        ],
      ),
    );
  }
}
