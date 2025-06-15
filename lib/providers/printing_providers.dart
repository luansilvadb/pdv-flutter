import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/dependency_injection.dart';
import '../features/printing/domain/usecases/generate_receipt_pdf.dart';
import '../features/printing/domain/usecases/generate_pdf_bytes.dart';
import '../features/printing/domain/usecases/save_receipt_pdf.dart';
import '../features/printing/presentation/providers/printing_provider.dart';
import '../features/printing/presentation/providers/printing_state.dart';

/// Provider para o PrintingNotifier
final printingProvider = StateNotifierProvider<PrintingNotifier, PrintingState>((ref) {
  return PrintingNotifier(
    generateReceiptPdf: sl<GenerateReceiptPdf>(),
    generatePdfBytes: sl<GeneratePdfBytes>(),
    saveReceiptPdf: sl<SaveReceiptPdf>(),
    logger: sl(),
  );
});

/// Provider para verificar se está imprimindo
final isPrintingProvider = Provider<bool>((ref) {
  final state = ref.watch(printingProvider);
  return state is PrintingLoading;
});

/// Provider para obter erro de impressão
final printingErrorProvider = Provider<String?>((ref) {
  final state = ref.watch(printingProvider);
  if (state is PrintingError) {
    return state.message;
  }
  return null;
});

/// Provider para verificar se último cupom foi impresso com sucesso
final lastReceiptPrintedProvider = Provider<bool>((ref) {
  final state = ref.watch(printingProvider);
  return state is PrintingCompleted;
});

/// Provider para verificar se último PDF foi gerado com sucesso
final lastPdfGeneratedProvider = Provider<bool>((ref) {
  final state = ref.watch(printingProvider);
  return state is PdfGenerated;
});

/// Provider para verificar se último PDF foi salvo com sucesso
final lastPdfSavedProvider = Provider<String?>((ref) {
  final state = ref.watch(printingProvider);
  if (state is PdfSaved) {
    return state.filePath;
  }
  return null;
});
