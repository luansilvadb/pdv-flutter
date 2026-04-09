import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/promotions_provider.dart';
import '../../../../core/constants/app_constants.dart';

class PromotionsScreen extends ConsumerStatefulWidget {
  const PromotionsScreen({super.key});

  @override
  ConsumerState<PromotionsScreen> createState() => _PromotionsScreenState();
}

class _PromotionsScreenState extends ConsumerState<PromotionsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(promotionsProvider.notifier).loadActivePromotions());
  }

  @override
  Widget build(BuildContext context) {
    final promos = ref.watch(promotionsProvider);

    return ScaffoldPage(
      header: const PageHeader(title: Text('Sistema de Promoções')),
      content: promos.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(FluentIcons.emoji, size: 64, color: AppColors.textTertiary),
                const SizedBox(height: 16),
                const Text('Nenhuma promoção ativa no momento'),
              ],
            ),
          )
        : ListView.builder(
            itemCount: promos.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final promo = promos[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(promo.name),
                  subtitle: Text('Tipo: ${promo.type.name} | Valor: ${promo.value}'),
                  trailing: const Icon(FluentIcons.tag, color: AppColors.primaryAccent),
                ),
              );
            },
          ),
    );
  }
}
