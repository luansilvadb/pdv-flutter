# Otimização de Performance - PDV Restaurant

## 📈 Melhorias Implementadas

### 1. Navegação Otimizada
- **IndexedStack**: Implementado para manter o estado das telas durante a navegação
- **Prevenção de Rebuilds**: Verificação de mudança de estado antes de atualizar índice
- **Providers Otimizados**: Novos providers que observam apenas partes específicas do estado

### 2. Carregamento Lazy e Cache de Estado
- **Inicialização Única**: Telas carregam dados apenas uma vez ao serem criadas
- **Estado Persistente**: O estado das telas é preservado durante a navegação
- **ScrollControllers**: Mantêm a posição de rolagem ao navegar entre telas

### 3. Providers Otimizados com `select()`
- **CartProviders**: Observam apenas partes específicas do carrinho que são relevantes
- **NavigationProviders**: Reduzem rebuilds desnecessários na navegação
- **Memoização**: Provider.family para dados que exigem parâmetros

### 4. Widgets Eficientes
- **Chaves Persistentes**: ValueKey para preservar estado de widgets individuais
- **PerformanceTracker**: Monitora e otimiza rebuilds em widgets críticos
- **LayoutBuilder**: Ajustes dinâmicos de layout que mantêm performance

## 🛠️ Como Usar as Otimizações

### Otimização de Navegação
```dart
// Ao invés de usar switch/case diretamente com rebuilds completos
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

### Providers Otimizados
```dart
// Ao invés de observar o estado completo do carrinho
final cartState = ref.watch(cartProvider);

// Use providers específicos para partes do estado
final totalAmount = ref.watch(cartTotalProvider);
final itemCount = ref.watch(cartItemCountProvider);
final isEmpty = ref.watch(isCartEmptyProvider);

// Para verificar se um produto específico já está no carrinho
final isInCart = ref.watch(isProductInCartProvider(productId));
```

### Inicialização Eficiente
```dart
@override
void initState() {
  super.initState();
  // Carrega os dados apenas uma vez
  if (!_hasInitialized) {
    ref.read(productsNotifierProvider.notifier).loadAvailableProducts();
    _hasInitialized = true;
  }
}
```

### Monitoramento de Performance
```dart
// Envolver widgets críticos com o PerformanceTracker
PerformanceTracker(
  trackerName: 'ProductsList',
  child: _buildProductsGrid(products),
)

// Medir operações custosas
await PerformanceMonitor.measureOperation(
  operationName: 'LoadProducts',
  operation: () => productsRepository.getProducts(),
);
```

## 📋 Checklist de Otimização

- [x] Implementar IndexedStack na navegação principal
- [x] Criar providers otimizados para partes específicas de estados complexos
- [x] Adicionar verificação para evitar rebuilds desnecessários nos Notifiers
- [x] Implementar lazy loading com cache de estados
- [x] Usar ScrollController para manter posições de rolagem
- [x] Adicionar chaves persistentes (ValueKey) nos widgets de listas e grids
- [x] Criar utilitários de monitoramento de performance
- [ ] Analisar e otimizar imagens e assets (próximos passos)
- [ ] Implementar cache de rede para imagens (próximos passos)

## 🔍 Monitoramento Contínuo

Para monitorar a performance da aplicação, use:

```dart
// Ativar logs de performance em desenvolvimento
PerformanceMonitor.enablePerformanceLogs = true;

// Visualizar repinturas de widgets (útil para depuração)
PerformanceMonitor.enableRepaintRainbow();
```

---

*Documento elaborado para a equipe PDV Restaurant - Junho 2025*
