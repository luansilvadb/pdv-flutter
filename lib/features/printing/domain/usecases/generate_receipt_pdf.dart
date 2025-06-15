import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/domain/use_cases/base_use_case.dart';
import '../entities/receipt_entity.dart';
import '../repositories/printing_repository.dart';

/// Use case para gerar PDF do cupom fiscal
class GenerateReceiptPdf extends UseCase<List<int>, GenerateReceiptPdfParams>
    with UseCaseLogging {
  final PrintingRepository repository;

  GenerateReceiptPdf(this.repository);

  @override
  Future<Either<Failure, List<int>>> call(GenerateReceiptPdfParams params) async {
    logExecution('GenerateReceiptPdf', params);

    try {
      final result = await repository.generateReceiptPdf(params.receipt);

      result.fold(
        (failure) => logError('GenerateReceiptPdf', failure),
        (pdfBytes) => logSuccess('GenerateReceiptPdf', 'PDF gerado com ${pdfBytes.length} bytes'),
      );

      return result;
    } catch (e) {
      final failure = UnknownFailure(
        message: 'Erro inesperado ao gerar PDF: $e',
      );
      logError('GenerateReceiptPdf', failure);
      return Left(failure);
    }
  }
}

/// Parâmetros para gerar PDF do cupom fiscal
class GenerateReceiptPdfParams extends Equatable {
  final ReceiptEntity receipt;

  const GenerateReceiptPdfParams({required this.receipt});

  @override
  List<Object?> get props => [receipt];

  @override
  String toString() => 'GenerateReceiptPdfParams(receiptId: ${receipt.id})';
}
