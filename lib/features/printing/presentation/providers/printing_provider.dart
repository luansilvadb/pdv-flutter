import 'dart:typed_data';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../domain/entities/receipt_entity.dart';
import '../../domain/usecases/generate_receipt_pdf.dart';
import '../../domain/usecases/generate_pdf_bytes.dart';
import '../../domain/usecases/print_receipt.dart';
import '../../domain/usecases/save_receipt_pdf.dart';
import '../../../../widgets/pdf_preview_dialog.dart';
import 'printing_state.dart';

/// Notifier para gerenciar o estado de impressão
class PrintingNotifier extends StateNotifier<PrintingState> {
  final GenerateReceiptPdf _generateReceiptPdf;
  final GeneratePdfBytes _generatePdfBytes;
  final PrintReceipt _printReceipt;
  final SaveReceiptPdf _saveReceiptPdf;
  final Logger _logger;

  PrintingNotifier({
    required GenerateReceiptPdf generateReceiptPdf,
    required GeneratePdfBytes generatePdfBytes,
    required PrintReceipt printReceipt,
    required SaveReceiptPdf saveReceiptPdf,
    required Logger logger,
  }) : _generateReceiptPdf = generateReceiptPdf,
       _generatePdfBytes = generatePdfBytes,
       _printReceipt = printReceipt,
       _saveReceiptPdf = saveReceiptPdf,
       _logger = logger,
       super(const PrintingInitial());

  /// Gera e imprime o cupom fiscal para um pedido
  Future<void> printOrderReceipt(OrderEntity order) async {
    _logger.d('Iniciando impressão do cupom fiscal para pedido: ${order.id}');
    state = const PrintingLoading();

    try {
      // Cria o cupom fiscal a partir do pedido
      final receipt = ReceiptEntity.fromOrder(order: order);

      // Imprime o cupom
      final printParams = PrintReceiptParams(receipt: receipt);
      final printResult = await _printReceipt(printParams);

      printResult.fold(
        (failure) {
          _logger.e('Erro ao imprimir cupom fiscal: ${failure.message}');
          state = PrintingError(message: failure.message);
        },
        (_) {
          _logger.d('Cupom fiscal impresso com sucesso');
          state = PrintingCompleted(receipt: receipt);
        },
      );
    } catch (e) {
      _logger.e('Erro inesperado ao imprimir cupom fiscal', error: e);
      state = PrintingError(message: 'Erro inesperado ao imprimir: $e');
    }
  }

  /// Gera PDF do cupom fiscal
  Future<void> generateOrderReceiptPdf(OrderEntity order) async {
    _logger.d('Gerando PDF do cupom fiscal para pedido: ${order.id}');
    state = const PrintingLoading();

    try {
      // Cria o cupom fiscal a partir do pedido
      final receipt = ReceiptEntity.fromOrder(order: order);

      // Gera o PDF
      final pdfParams = GenerateReceiptPdfParams(receipt: receipt);
      final pdfResult = await _generateReceiptPdf(pdfParams);

      pdfResult.fold(
        (failure) {
          _logger.e('Erro ao gerar PDF do cupom fiscal: ${failure.message}');
          state = PrintingError(message: failure.message);
        },
        (pdfBytes) {
          _logger.d('PDF do cupom fiscal gerado com sucesso');
          state = PdfGenerated(pdfBytes: pdfBytes, receipt: receipt);
        },
      );
    } catch (e) {
      _logger.e('Erro inesperado ao gerar PDF do cupom fiscal', error: e);
      state = PrintingError(message: 'Erro inesperado ao gerar PDF: $e');
    }
  }

  /// Salva PDF do cupom fiscal
  Future<void> saveOrderReceiptPdf(OrderEntity order, {String? customPath}) async {
    _logger.d('Salvando PDF do cupom fiscal para pedido: ${order.id}');
    state = const PrintingLoading();

    try {
      // Cria o cupom fiscal a partir do pedido
      final receipt = ReceiptEntity.fromOrder(order: order);

      // Define o diretório para salvar
      String directoryPath;
      if (customPath != null) {
        directoryPath = customPath;
      } else {
        final documentsDir = await getApplicationDocumentsDirectory();
        directoryPath = '${documentsDir.path}/cupons_fiscais';
      }

      // Salva o PDF
      final saveParams = SaveReceiptPdfParams(
        receipt: receipt,
        directoryPath: directoryPath,
      );
      final saveResult = await _saveReceiptPdf(saveParams);

      saveResult.fold(
        (failure) {
          _logger.e('Erro ao salvar PDF do cupom fiscal: ${failure.message}');
          state = PrintingError(message: failure.message);
        },
        (filePath) {
          _logger.d('PDF do cupom fiscal salvo com sucesso em: $filePath');
          state = PdfSaved(filePath: filePath, receipt: receipt);
        },
      );
    } catch (e) {
      _logger.e('Erro inesperado ao salvar PDF do cupom fiscal', error: e);
      state = PrintingError(message: 'Erro inesperado ao salvar PDF: $e');
    }
  }
  /// Gera e exibe prévia do PDF interno
  Future<void> showInternalPreview(BuildContext context, OrderEntity order) async {
    _logger.d('Exibindo prévia interna do PDF para pedido: ${order.id}');
    state = const PrintingLoading();

    try {
      // Cria o cupom fiscal a partir do pedido
      final receipt = ReceiptEntity.fromOrder(order: order);

      // Gera os bytes do PDF
      final pdfParams = GeneratePdfBytesParams(receipt: receipt);
      final pdfResult = await _generatePdfBytes(pdfParams);

      pdfResult.fold(
        (failure) {
          _logger.e('Erro ao gerar PDF para prévia: ${failure.message}');
          state = PrintingError(message: failure.message);
        },
        (pdfBytes) {
          _logger.d('PDF gerado para prévia com sucesso');
          state = PrintingPreviewShown(receipt: receipt);
          
          // Exibe o diálogo de prévia
          showDialog(
            context: context,
            builder: (context) => PdfPreviewDialog(
              pdfBytes: Uint8List.fromList(pdfBytes),
              receipt: receipt,
            ),
          );
        },
      );
    } catch (e) {
      _logger.e('Erro inesperado ao exibir prévia interna', error: e);
      state = PrintingError(message: 'Erro inesperado ao exibir prévia: $e');
    }
  }
  /// Salva PDF do cupom fiscal com seleção de pasta
  Future<void> saveOrderReceiptPdfWithPicker(OrderEntity order) async {
    _logger.d('Abrindo seletor de pasta para salvar PDF do pedido: ${order.id}');
    
    try {
      // Abre o seletor de pasta
      final selectedDirectory = await FilePicker.platform.getDirectoryPath();
      
      if (selectedDirectory == null) {
        // Usuário cancelou a seleção
        _logger.d('Seleção de pasta cancelada pelo usuário');
        return;
      }
      
      // Salva o PDF na pasta selecionada
      await saveOrderReceiptPdf(order, customPath: selectedDirectory);
      
    } catch (e) {
      _logger.e('Erro ao abrir seletor de pasta', error: e);
      state = PrintingError(message: 'Erro ao abrir seletor de pasta: $e');
    }
  }

  /// Limpa o estado de erro
  void clearError() {
    if (state is PrintingError) {
      state = const PrintingInitial();
    }
  }

  /// Reseta o estado para inicial
  void reset() {
    state = const PrintingInitial();
  }
}
