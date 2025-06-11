import 'package:equatable/equatable.dart';

/// Estado da navegação da aplicação
class NavigationState extends Equatable {
  /// Índice da tela atualmente selecionada
  final int selectedIndex;

  /// Indica se o sidebar está collapsed
  final bool isCollapsed;

  const NavigationState({
    this.selectedIndex = 1, // Inicia no Menu (index 1)
    this.isCollapsed = false,
  });

  /// Cria uma nova instância com valores atualizados
  NavigationState copyWith({int? selectedIndex, bool? isCollapsed}) {
    return NavigationState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isCollapsed: isCollapsed ?? this.isCollapsed,
    );
  }

  @override
  List<Object> get props => [selectedIndex, isCollapsed];

  @override
  String toString() =>
      'NavigationState(selectedIndex: $selectedIndex, isCollapsed: $isCollapsed)';
}
