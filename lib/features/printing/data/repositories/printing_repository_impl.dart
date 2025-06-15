import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/receipt_entity.dart';
import '../../domain/repositories/printing_repository.dart';
import '../datasources/pdf_generator.dart';
import '../datasources/printing_service.dart';

/// Implementação do repositório de impressão
class PrintingRepositoryImpl implements PrintingRepository {
  final PdfGenerator pdfGenerator;
  final PrintingService printingService;
  final Logger logger;

  PrintingRepositoryImpl({
    required this.pdfGenerator,
    required this.printingService,
    required this.logger,
  });

  @override
  Future<Either<Failure, List<int>>> generateReceiptPdf(ReceiptEntity receipt) async {
    try {
      logger.d('Gerando PDF do cupom fiscal: ${receipt.receiptNumber}');
      
      final pdfBytes = await pdfGenerator.generateReceiptPdf(receipt);
      
      logger.d('PDF gerado com sucesso: ${pdfBytes.length} bytes');
      return Right(pdfBytes);
    } catch (e) {
      logger.e('Erro ao gerar PDF do cupom fiscal', error: e);
      return Left(UnknownFailure(message: 'Erro ao gerar PDF: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> printReceipt(ReceiptEntity receipt) async {
    try {
      logger.d('Imprimindo cupom fiscal: ${receipt.receiptNumber}');
      
      await printingService.printReceipt(receipt);
      
      logger.d('Cupom fiscal impresso com sucesso');
      return const Right(unit);
    } catch (e) {
      logger.e('Erro ao imprimir cupom fiscal', error: e);
      return Left(UnknownFailure(message: 'Erro ao imprimir cupom: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> saveReceiptPdf(ReceiptEntity receipt, String directoryPath) async {
    try {
      logger.d('Salvando PDF do cupom fiscal: ${receipt.receiptNumber}');
      
      final filePath = await printingService.saveReceiptPdf(receipt, directoryPath);
      
      logger.d('PDF salvo com sucesso em: $filePath');
      return Right(filePath);
    } catch (e) {
      logger.e('Erro ao salvar PDF do cupom fiscal', error: e);
      return Left(UnknownFailure(message: 'Erro ao salvar PDF: $e'));
    }
  }
  @override
  Future<Either<Failure, Unit>> previewReceiptPdf(ReceiptEntity receipt) async {
    try {
      logger.d('Exibindo prévia do PDF: ${receipt.receiptNumber}');
      
      await printingService.previewReceiptPdf(receipt);
      
      logger.d('Prévia do PDF exibida com sucesso');
      return const Right(unit);
    } catch (e) {
      logger.e('Erro ao exibir prévia do PDF', error: e);
      return Left(UnknownFailure(message: 'Erro ao exibir prévia: $e'));
    }
  }

  @override
  Future<Either<Failure, List<int>>> generatePdfBytes(ReceiptEntity receipt) async {
    try {
      logger.d('Gerando bytes do PDF: ${receipt.receiptNumber}');
      
      final pdfBytes = await printingService.generatePdfBytes(receipt);
      
      logger.d('Bytes do PDF gerados com sucesso: ${pdfBytes.length} bytes');
      return Right(pdfBytes);
    } catch (e) {
      logger.e('Erro ao gerar bytes do PDF', error: e);
      return Left(UnknownFailure(message: 'Erro ao gerar bytes do PDF: $e'));
    }
  }
}
