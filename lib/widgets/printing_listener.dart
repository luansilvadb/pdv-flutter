import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/printing_providers.dart';
import '../features/printing/presentation/providers/printing_state.dart';
import '../shared/presentation/widgets/custom_toast.dart';
import '../core/constants/app_constants.dart';

/// Listener para exibir notificações baseadas no estado de impressão
class PrintingListener extends ConsumerWidget {
  final Widget child;

  const PrintingListener({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuta mudanças no estado de impressão
    ref.listen<PrintingState>(
      printingProvider,
      (previous, next) {
        if (next is PrintingCompleted) {
          // Sucesso na impressão
          showCustomToast(
            context,
            title: 'Cupom Impresso',
            message: 'Cupom fiscal ${next.receipt.receiptNumber} impresso com sucesso!',
            icon: FluentIcons.print,
            color: AppColors.success,
            duration: const Duration(seconds: 4),
          );
        } else if (next is PdfSaved) {
          // PDF salvo com sucesso
          showCustomToast(
            context,
            title: 'PDF Salvo',
            message: 'PDF salvo em: ${_getShortPath(next.filePath)}',
            icon: FluentIcons.save,
            color: AppColors.success,
            duration: const Duration(seconds: 5),
          );
        } else if (next is PrintingError) {
          // Erro na impressão
          showCustomToast(
            context,
            title: 'Erro de Impressão',
            message: next.message,
            icon: FluentIcons.error,
            color: AppColors.error,
            duration: const Duration(seconds: 6),
          );
        } else if (next is PrintingPreviewShown) {
          // Prévia exibida com sucesso
          showCustomToast(
            context,
            title: 'Prévia do Cupom',
            message: 'Cupom fiscal ${next.receipt.receiptNumber} aberto para visualização',
            icon: FluentIcons.view,
            color: AppColors.info,
            duration: const Duration(seconds: 3),
          );
        }
      },
    );

    return child;
  }

  /// Obtém um caminho mais curto para exibição
  String _getShortPath(String fullPath) {
    final parts = fullPath.split('\\');
    if (parts.length > 3) {
      return '...\\${parts.skip(parts.length - 2).join('\\')}';
    }
    return fullPath;
  }
}
