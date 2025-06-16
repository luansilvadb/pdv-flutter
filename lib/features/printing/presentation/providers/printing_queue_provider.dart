import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../../../providers/printing_providers.dart';

/// Notifier para gerenciar fila de previews de PDF
class PrintingQueueNotifier extends StateNotifier<List<_QueueItem>> {
  final Ref ref;
  bool _isProcessing = false;

  PrintingQueueNotifier(this.ref) : super([]);

  void addToQueue(BuildContext context, OrderEntity order) {
    state = [...state, _QueueItem(context, order)];
    _processQueue();
  }

  Future<void> _processQueue() async {
    if (_isProcessing || state.isEmpty) return;
    _isProcessing = true;
    while (state.isNotEmpty) {
      final item = state.first;
      try {
        await ref.read(printingProvider.notifier).showInternalPreview(item.context, item.order);
      } catch (_) {}
      state = state.sublist(1);
    }
    _isProcessing = false;
  }
}

class _QueueItem {
  final BuildContext context;
  final OrderEntity order;
  _QueueItem(this.context, this.order);
}

final printingQueueProvider = StateNotifierProvider<PrintingQueueNotifier, List<_QueueItem>>(
  (ref) => PrintingQueueNotifier(ref),
);
