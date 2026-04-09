import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/reports_provider.dart';
import '../../../../core/constants/app_constants.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reportsProvider);

    return ScaffoldPage(
      header: PageHeader(
        title: const Text('Relatórios Detalhados'),
        commandBar: Button(
          child: const Text('Gerar Relatório de Vendas (7 dias)'),
          onPressed: () {
            ref.read(reportsProvider.notifier).generateSalesReport(
              DateTime.now().subtract(const Duration(days: 7)),
              DateTime.now(),
            );
          },
        ),
      ),
      content: state.isLoading
        ? const Center(child: ProgressRing())
        : state.reports.isEmpty
          ? const Center(child: Text('Nenhum relatório gerado ainda'))
          : ListView.builder(
              itemCount: state.reports.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final report = state.reports[index];
                return Expander(
                  header: Text('Relatório de Vendas: ${report.start.day}/${report.start.month} - ${report.end.day}/${report.end.month}'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Valor Total: R\$ ${report.totalValue.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('Total de Pedidos: ${report.totalCount}'),
                      const SizedBox(height: 16),
                      const Text('Dados por Período:', style: TextStyle(fontWeight: FontWeight.bold)),
                      ...report.data.map((dp) => ListTile(
                        title: Text(dp.label),
                        subtitle: Text('R\$ ${dp.value.toStringAsFixed(2)} (${dp.count} pedidos)'),
                        trailing: Text('${dp.percentage.toStringAsFixed(1)}%'),
                      )),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
