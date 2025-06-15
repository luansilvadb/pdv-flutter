import 'dart:io';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import '../../domain/entities/receipt_entity.dart';
import 'pdf_generator.dart';

/// Serviço de impressão
abstract class PrintingService {
  /// Imprime o cupom fiscal
  Future<void> printReceipt(ReceiptEntity receipt);
  
  /// Salva o PDF do cupom fiscal
  Future<String> saveReceiptPdf(ReceiptEntity receipt, String directoryPath);
  
  /// Exibe o PDF em uma visualização
  Future<void> previewReceiptPdf(ReceiptEntity receipt);
  
  /// Gera PDF e retorna os bytes para visualização interna
  Future<List<int>> generatePdfBytes(ReceiptEntity receipt);
}

/// Implementação do serviço de impressão
class PrintingServiceImpl implements PrintingService {
  final PdfGenerator pdfGenerator;

  PrintingServiceImpl({required this.pdfGenerator});

  @override
  Future<void> printReceipt(ReceiptEntity receipt) async {
    final pdfBytes = await pdfGenerator.generateReceiptPdf(receipt);
    
    // Tenta imprimir diretamente se tiver impressora disponível
    try {
      await Printing.layoutPdf(
        onLayout: (format) async => pdfBytes,
        name: 'Cupom_Fiscal_${receipt.receiptNumber}',
        format: PdfPageFormat.a4,
      );
    } catch (e) {
      // Se não conseguir imprimir, apenas ignora o erro
      // pois o usuário pode não ter impressora
      rethrow;
    }
  }

  @override
  Future<String> saveReceiptPdf(ReceiptEntity receipt, String directoryPath) async {
    final pdfBytes = await pdfGenerator.generateReceiptPdf(receipt);
    
    // Cria o diretório se não existir
    final directory = Directory(directoryPath);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    
    // Define o nome do arquivo
    final fileName = 'Cupom_Fiscal_${receipt.receiptNumber}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final filePath = '$directoryPath/$fileName';
    
    // Salva o arquivo
    final file = File(filePath);
    await file.writeAsBytes(pdfBytes);
    
    return filePath;
  }

  @override
  Future<void> previewReceiptPdf(ReceiptEntity receipt) async {
    // Esta função não é mais usada diretamente
    // A prévia é gerenciada pelo widget PdfPreviewDialog
    final pdfBytes = await pdfGenerator.generateReceiptPdf(receipt);
    
    await Printing.layoutPdf(
      onLayout: (format) async => pdfBytes,
      name: 'Preview_Cupom_Fiscal_${receipt.receiptNumber}',
      format: PdfPageFormat.a4,
    );
  }
  
  @override
  Future<List<int>> generatePdfBytes(ReceiptEntity receipt) async {
    final pdfBytes = await pdfGenerator.generateReceiptPdf(receipt);
    return pdfBytes;
  }
}
