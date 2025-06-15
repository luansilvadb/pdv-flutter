import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import '../../../orders/domain/entities/order_entity.dart';
import '../../data/datasources/web_pdf_launcher_stub.dart'
  if (dart.library.html) '../../data/datasources/web_pdf_launcher.dart';
import '../../domain/entities/receipt_entity.dart';
import '../../domain/usecases/generate_receipt_pdf.dart';
import '../../domain/usecases/generate_pdf_bytes.dart';
import '../../domain/usecases/save_receipt_pdf.dart';
import '../../../../widgets/pdf_preview_dialog.dart';
import '../../../../core/utils/path_utils.dart';
import 'printing_state.dart';

/// Notifier para gerenciar o estado de impressão
class PrintingNotifier extends StateNotifier<PrintingState> {
  final GenerateReceiptPdf _generateReceiptPdf;
  final GeneratePdfBytes _generatePdfBytes;
  final SaveReceiptPdf _saveReceiptPdf;
  final Logger _logger;

  PrintingNotifier({
    required GenerateReceiptPdf generateReceiptPdf,
    required GeneratePdfBytes generatePdfBytes,
    required SaveReceiptPdf saveReceiptPdf,
    required Logger logger,
  }) : _generateReceiptPdf = generateReceiptPdf,
       _generatePdfBytes = generatePdfBytes,
       _saveReceiptPdf = saveReceiptPdf,
       _logger = logger,
       super(const PrintingInitial());
  /// Gera e imprime o cupom fiscal para um pedido usando o navegador
  Future<void> printOrderReceiptInBrowser(OrderEntity order) async {
    _logger.d('Iniciando impressão do cupom fiscal no navegador para pedido: ${order.id}');
    state = const PrintingLoading();

    try {
      // Cria o cupom fiscal a partir do pedido
      final receipt = ReceiptEntity.fromOrder(order: order);

      // Gera os bytes do PDF
      final pdfParams = GeneratePdfBytesParams(receipt: receipt);
      final pdfResult = await _generatePdfBytes(pdfParams);      pdfResult.fold(
        (failure) {
          _logger.e('Erro ao gerar PDF para impressão no navegador: ${failure.message}');
          state = PrintingError(message: 'Erro ao gerar PDF: ${failure.message}');
        },
        (pdfBytes) async {
          _logger.d('PDF gerado com sucesso, abrindo no navegador');
          
          try {
            if (kIsWeb) {
              // Para web, cria data URL e abre em nova aba
              await _openPdfInWebBrowser(pdfBytes, receipt);
            } else {
              // Para desktop, usa arquivo temporário que é mais confiável
              _logger.d('Plataforma desktop detectada, usando arquivo temporário');
              await _openPdfFileInBrowser(pdfBytes, receipt);
            }
            
            state = PrintingCompleted(receipt: receipt);
          } catch (e) {
            _logger.e('Erro ao abrir PDF no navegador: $e');
            state = PrintingError(message: 'Erro ao abrir PDF no navegador: $e');
          }
        },
      );
    } catch (e) {
      _logger.e('Erro inesperado ao abrir PDF no navegador', error: e);
      state = PrintingError(message: 'Erro inesperado ao abrir PDF no navegador: $e');
    }
  }  /// Método auxiliar para abrir PDF no navegador web
  Future<void> _openPdfInWebBrowser(List<int> pdfBytes, ReceiptEntity receipt) async {
    try {
      if (kIsWeb) {
        // Para web, usa o WebPdfLauncher que encapsula a lógica de dart:html
        WebPdfLauncher.openPdfInBrowser(pdfBytes);
        _logger.d('PDF aberto no navegador via WebPdfLauncher');
      } else {
        // Para outras plataformas, usa url_launcher com data URL
        final base64String = base64Encode(pdfBytes);
        final dataUrl = 'data:application/pdf;base64,$base64String';
        await launchUrl(Uri.parse(dataUrl), mode: LaunchMode.externalApplication);
        _logger.d('PDF aberto no navegador via url_launcher');
      }
    } catch (e) {
      _logger.w('Erro ao abrir PDF no navegador web: $e');
      rethrow;
    }
  }
  /// Método auxiliar para abrir PDF em arquivo temporário no navegador
  Future<void> _openPdfFileInBrowser(List<int> pdfBytes, ReceiptEntity receipt) async {
    try {
      _logger.d('Criando arquivo temporário para abrir no navegador');
      
      // Usa o diretório temporário do sistema
      final tempDir = await _getDefaultSaveDirectory();
      
      // Cria um receipt temporário com nome específico
      final tempReceipt = ReceiptEntity(
        id: 'temp_${receipt.id}_${DateTime.now().millisecondsSinceEpoch}',
        receiptNumber: 'TEMP${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        order: receipt.order,
        issuedAt: DateTime.now(),
        establishmentName: receipt.establishmentName,
        establishmentAddress: receipt.establishmentAddress,
        establishmentPhone: receipt.establishmentPhone,
        establishmentCnpj: receipt.establishmentCnpj,
      );
      
      // Salva temporariamente
      final saveParams = SaveReceiptPdfParams(
        receipt: tempReceipt,
        directoryPath: tempDir,
      );
      
      final saveResult = await _saveReceiptPdf(saveParams);
      
      saveResult.fold(
        (failure) {
          _logger.e('Erro ao salvar arquivo temporário: ${failure.message}');
          throw Exception('Não foi possível criar arquivo temporário');
        },
        (filePath) async {
          _logger.d('Arquivo temporário criado: $filePath');
          
          // Tenta abrir o arquivo no navegador padrão
          final fileUri = Uri.file(filePath);
          
          try {
            _logger.d('Tentando abrir arquivo no navegador: ${fileUri.toString()}');
            
            // Tenta primeiro com modo externo
            if (await canLaunchUrl(fileUri)) {
              await launchUrl(fileUri, mode: LaunchMode.externalApplication);
              _logger.d('Arquivo aberto com sucesso no navegador');
            } else {
              // Fallback: tenta com modo platform default
              _logger.d('Tentando modo platform default');
              await launchUrl(fileUri, mode: LaunchMode.platformDefault);
              _logger.d('Arquivo aberto com modo platform default');
            }
          } catch (e) {
            _logger.e('Erro ao abrir arquivo no navegador: $e');
            throw Exception('Não foi possível abrir o navegador. Verifique se há um navegador padrão configurado.');
          }
        },
      );
    } catch (e) {
      _logger.e('Erro ao abrir PDF via arquivo temporário: $e');
      rethrow;
    }
  }

  /// Gera e imprime o cupom fiscal para um pedido (método original mantido para compatibilidade)
  Future<void> printOrderReceipt(OrderEntity order) async {
    // Redireciona para o novo método do navegador
    await printOrderReceiptInBrowser(order);
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
      final receipt = ReceiptEntity.fromOrder(order: order);      // Define o diretório para salvar
      String directoryPath;
      if (customPath != null) {
        directoryPath = customPath;
      } else {
        directoryPath = await _getDefaultSaveDirectory();
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
  }  /// Salva PDF do cupom fiscal com seleção de pasta
  Future<void> saveOrderReceiptPdfWithPicker(OrderEntity order) async {
    _logger.d('Iniciando seleção de pasta para salvar PDF do pedido: ${order.id}');
    
    try {
      if (kIsWeb) {
        // Para web, salva diretamente (download via navegador)
        _logger.d('Plataforma web detectada, iniciando download direto');
        await saveOrderReceiptPdf(order);
      } else {
        // Para desktop/mobile, abre o seletor de pasta
        _logger.d('Abrindo seletor de pasta para salvar PDF');
        
        final selectedDirectory = await FilePicker.platform.getDirectoryPath(
          dialogTitle: 'Escolha onde salvar o cupom fiscal',
          lockParentWindow: true,
        );
        
        if (selectedDirectory == null) {
          // Usuário cancelou a seleção
          _logger.d('Seleção de pasta cancelada pelo usuário');
          // Não altera o estado, apenas retorna
          return;
        }
        
        // Verifica se o diretório é válido e acessível
        if (selectedDirectory.trim().isEmpty) {
          _logger.e('Diretório selecionado é inválido: vazio');
          state = PrintingError(message: 'Pasta selecionada é inválida');
          return;
        }
        
        _logger.d('Pasta selecionada: $selectedDirectory');
        
        // Salva o PDF na pasta selecionada
        await saveOrderReceiptPdf(order, customPath: selectedDirectory);
      }
    } catch (e) {
      _logger.e('Erro ao salvar PDF com seletor de pasta', error: e);
      state = PrintingError(message: 'Erro ao selecionar pasta para salvar PDF: $e');
    }
  }

  /// Método auxiliar para obter diretório padrão de forma segura
  Future<String> _getDefaultSaveDirectory() async {
    try {
      return await PathUtils.getCuponsDirectory();
    } catch (e) {
      _logger.w('Erro ao obter diretório padrão via PathUtils: $e');
      
      // Fallback final baseado na plataforma
      if (kIsWeb) {
        return '/downloads';
      } else {
        // Para Windows/Desktop
        return r'C:\Users\Public\Documents\PDV_Restaurant\cupons_fiscais';
      }
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
