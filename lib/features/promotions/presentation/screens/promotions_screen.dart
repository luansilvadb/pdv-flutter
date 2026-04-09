import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/promotions_provider.dart';
import '../../domain/entities/promotion.dart';
import '../../../../core/constants/app_constants.dart';

class PromotionsScreen extends ConsumerWidget {
  const PromotionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promotionsAsync = ref.watch(promotionsProvider);

    return ScaffoldPage(
      header: PageHeader(
        title: const Text('Sistema de Promoções'),
        commandBar: CommandBar(
          mainAxisAlignment: MainAxisAlignment.end,
          primaryItems: [
            CommandBarButton(
              icon: const Icon(FluentIcons.add),
              label: const Text('Nova Promoção'),
              onPressed: () => _showAddPromotionDialog(context, ref),
            ),
          ],
        ),
      ),
      content: promotionsAsync.when(
        data: (promotions) => ListView.builder(
          padding: const EdgeInsets.all(AppSizes.paddingMedium),
          itemCount: promotions.length,
          itemBuilder: (context, index) {
            final promo = promotions[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(promo.name),
                subtitle: Text('${promo.type.name.toUpperCase()} - Valor: ${promo.value}'),
                trailing: IconButton(
                  icon: const Icon(FluentIcons.delete),
                  onPressed: () => ref.read(promotionsProvider.notifier).removePromotion(promo.id),
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: ProgressRing()),
        error: (e, st) => Center(child: Text('Erro: $e')),
      ),
    );
  }

  void _showAddPromotionDialog(BuildContext context, WidgetRef ref) {
    // Simplified dialog for adding a fixed test promotion
    showDialog(
      context: context,
      builder: (context) => ContentDialog(
        title: const Text('Adicionar Promoção de Teste'),
        content: const Text('Deseja adicionar uma promoção de 10% de desconto para pedidos acima de R\$ 50?'),
        actions: [
          Button(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          FilledButton(
            child: const Text('Adicionar'),
            onPressed: () {
              final promo = Promotion(
                id: 'promo_${DateTime.now().millisecondsSinceEpoch}',
                name: 'Desconto 10%',
                type: PromotionType.percentage,
                value: 0.10,
                conditions: {'min_subtotal': 50.0},
              );
              ref.read(promotionsProvider.notifier).addPromotion(promo);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
