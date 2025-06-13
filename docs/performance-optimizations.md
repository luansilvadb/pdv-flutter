# Otimizações de Performance de Navegação

## Visão Geral

Este documento descreve as otimizações realizadas para melhorar a performance do sistema de navegação no projeto PDV-Flutter. O foco principal foi reduzir o tempo de troca entre telas e minimizar a reconstrução desnecessária de widgets.

## Problemas Identificados

1. **Reconstrução Completa de Telas** - A cada troca de tela, todo o conteúdo era reconstruído, incluindo widgets pesados
2. **Perda de Estado** - O estado das telas não era preservado durante a navegação 
3. **Carregamentos Repetidos** - Dados eram carregados novamente a cada visita à mesma tela
4. **Múltiplos Rebuilds** - Mudanças em estados irrelevantes causavam reconstruções desnecessárias

## Soluções Implementadas

### 1. IndexedStack para Manter Estado das Telas

Implementamos um `IndexedStack` no `MainScreen` para preservar o estado das telas enquanto o usuário navega entre elas:

```dart
Widget _buildMainContent(NavigationState navigationState) {
  return IndexedStack(
    index: navigationState.selectedIndex,
    children: [
      _buildHomeScreen(),
      _buildMenuWithCart(),
      _buildHistoryScreen(),
      _buildPromosScreen(),
      _buildSettingsScreen(),
    ],
  );
}
```

### 2. Lazy Loading com Inicialização Única

Cada tela agora implementa inicialização única dos dados para evitar carregamentos repetidos:

```dart
bool _hasInitialized = false;

@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!_hasInitialized) {
      // Carregar dados apenas uma vez
      ref.read(productsNotifierProvider.notifier).loadAvailableProducts();
      _hasInitialized = true;
    }
  });
}
```

### 3. Controladores de Scroll Persistentes

Adicionamos controladores de scroll persistentes para manter a posição de rolagem quando o usuário retorna a uma tela:

```dart
final ScrollController _scrollController = ScrollController();

@override
void dispose() {
  _scrollController.dispose();
  super.dispose();
}
```

### 4. Otimização de Providers do Riverpod

Implementamos otimizações nos providers para reduzir rebuilds desnecessários:

```dart
// Antes
final navigationState = ref.watch(navigationProvider);

// Depois (otimizado)
final isSelected = ref.watch(
  navigationProvider.select((state) => state.selectedIndex == index)
);
```

### 5. Verificação de Índice no NavigationProvider

Adicionamos uma verificação para evitar atualizações de estado desnecessárias:

```dart
void setSelectedIndex(int index) {
  // Evita rebuilds desnecessários se o índice já for o atual
  if (state.selectedIndex == index) return;
  state = state.copyWith(selectedIndex: index);
}
```

### 6. Otimização do Grid de Produtos

Implementamos técnicas avançadas para o grid de produtos:

```dart
GridView.builder(
  // Usar valor de key único para cada produto para manter estado dos widgets
  itemBuilder: (context, index) => ProductCard(
    product: products[index],
    key: ValueKey('product-${products[index].id}'),
  ),
  // Usar cache para os itens que saem da tela
  cacheExtent: 500,
)
```

### 7. Performance Monitor

Criamos uma classe `PerformanceMonitor` para rastrear a performance do app:

```dart
// Disponível em lib/core/utils/performance_monitor.dart
PerformanceMonitor.measureOperation(
  operationName: 'Carregamento de Produtos', 
  operation: () => loadProducts(),
);
```

## Resultados Esperados

- **Navegação mais Rápida** - Troca entre telas instantânea por não reconstruir todo o conteúdo
- **Preservação de Estado** - Estado dos widgets e posição de scroll mantidos entre navegações
- **Menor Uso de Recursos** - Redução no uso de CPU/memória por evitar reconstruções desnecessárias
- **Experiência Mais Fluida** - Menos atrasos e engasgos durante o uso do app

## Próximos Passos

- **Medição de Performance** - Implementar métricas para validar as melhorias
- **Widget Memoization** - Considerar uso de pacotes como `flutter_hooks` para memoização adicional
- **Decomposição de Widgets** - Dividir widgets grandes em componentes menores para reduzir rebuilds
- **Cache de Imagens** - Otimizar carregamento e cache de imagens

## Manutenção

Ao adicionar novas funcionalidades ou modificar o sistema de navegação existente, mantenha estas práticas em mente para garantir uma experiência de usuário fluida e responsiva.
