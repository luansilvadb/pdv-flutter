import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/receipt_entity.dart';

/// Interface para operações de impressão
abstract class PrintingRepository {
  /// Gera PDF do cupom fiscal
  Future<Either<Failure, List<int>>> generateReceiptPdf(ReceiptEntity receipt);
  
  /// Imprime o cupom fiscal
  Future<Either<Failure, Unit>> printReceipt(ReceiptEntity receipt);
  
  /// Salva o PDF do cupom fiscal
  Future<Either<Failure, String>> saveReceiptPdf(ReceiptEntity receipt, String directoryPath);
  
  /// Exibe o PDF em uma visualização
  Future<Either<Failure, Unit>> previewReceiptPdf(ReceiptEntity receipt);
  
  /// Gera bytes do PDF para visualização interna
  Future<Either<Failure, List<int>>> generatePdfBytes(ReceiptEntity receipt);
}
