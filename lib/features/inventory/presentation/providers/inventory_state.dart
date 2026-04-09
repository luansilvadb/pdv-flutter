import '../../domain/entities/inventory_item.dart';

class InventoryState {
  final List<InventoryItem> items;
  final bool isLoading;
  final String? error;

  const InventoryState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  InventoryState copyWith({
    List<InventoryItem>? items,
    bool? isLoading,
    String? error,
  }) {
    return InventoryState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
