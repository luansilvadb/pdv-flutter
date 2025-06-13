import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/navigation_entity.dart';  
import 'navigation_provider.dart';

/// Provider otimizado para verificar se uma tela específica está selecionada
/// Esta abordagem evita rebuilds desnecessários quando outras propriedades do estado mudam
final isScreenSelectedProvider = Provider.family<bool, int>((ref, screenIndex) {
  return ref.watch(
    navigationProvider.select((state) => state.selectedIndex == screenIndex)
  );
});

/// Provider otimizado para verificar se o sidebar está colapsado
/// Permite que componentes que dependem apenas do estado de colapso 
/// não façam rebuild quando o índice de navegação muda
final isSidebarCollapsedProvider = Provider<bool>((ref) {
  return ref.watch(
    navigationProvider.select((state) => state.isCollapsed)
  );
});

/// Provider para identificar a tela atual usando enum ao invés de int
/// Isso torna o código mais legível e menos propenso a erros
final currentScreenProvider = Provider<NavigationScreen>((ref) {
  final selectedIndex = ref.watch(
    navigationProvider.select((state) => state.selectedIndex)
  );
  
  switch (selectedIndex) {
    case 0:
      return NavigationScreen.home;
    case 1:
      return NavigationScreen.menu;
    case 2:
      return NavigationScreen.history;
    case 3:
      return NavigationScreen.promotions;
    case 4:
      return NavigationScreen.settings;
    default:
      return NavigationScreen.menu; // Fallback para menu se o índice for inválido
  }
});
