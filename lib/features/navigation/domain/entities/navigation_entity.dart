/// Enum representando as telas principais da aplicação
/// Torna mais segura a navegação, evitando erros de digitação ou índices incorretos
enum NavigationScreen {
  home,      // Índice 0
  menu,      // Índice 1
  history,   // Índice 2
  promotions, // Índice 3
  settings   // Índice 4
}

/// Entidade que representa um item de navegação
class NavigationItemEntity {
  final String name;
  final String icon;
  final NavigationScreen screen;

  const NavigationItemEntity({
    required this.name,
    required this.icon,
    required this.screen,
  });
  
  /// Converte o enum para o índice correspondente
  int get index {
    return screen.index;
  }
}
