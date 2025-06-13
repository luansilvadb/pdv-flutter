import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'navigation_state.dart';

/// Provider para gerenciar o estado de navegação da aplicação
final navigationProvider =
    StateNotifierProvider<NavigationNotifier, NavigationState>(
      (ref) => NavigationNotifier(),
    );

/// StateNotifier responsável pela lógica de navegação
class NavigationNotifier extends StateNotifier<NavigationState> {
  NavigationNotifier() : super(const NavigationState());

  /// Define o índice da tela selecionada
  void setSelectedIndex(int index) {
    // Evita rebuilds desnecessários se o índice já for o atual
    if (state.selectedIndex == index) return;
    state = state.copyWith(selectedIndex: index);
  }

  /// Alterna o estado collapsed do sidebar
  void toggleCollapsed() {
    state = state.copyWith(isCollapsed: !state.isCollapsed);
  }

  /// Define o estado collapsed do sidebar
  void setCollapsed(bool collapsed) {
    state = state.copyWith(isCollapsed: collapsed);
  }

  /// Navega para a tela inicial (Home)
  void navigateToHome() {
    setSelectedIndex(0);
  }

  /// Navega para o menu
  void navigateToMenu() {
    setSelectedIndex(1);
  }

  /// Navega para o histórico
  void navigateToHistory() {
    setSelectedIndex(2);
  }

  /// Navega para promoções
  void navigateToPromotions() {
    setSelectedIndex(3);
  }

  /// Navega para configurações
  void navigateToSettings() {
    setSelectedIndex(4);
  }
}
