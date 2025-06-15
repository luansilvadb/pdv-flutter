import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/domain/use_cases/base_use_case.dart';
import '../entities/receipt_entity.dart';
import '../repositories/printing_repository.dart';

/// Use case para salvar PDF do cupom fiscal
class SaveReceiptPdf extends UseCase<String, SaveReceiptPdfParams>
    with UseCaseLogging {
  final PrintingRepository repository;

  SaveReceiptPdf(this.repository);

  @override
  Future<Either<Failure, String>> call(SaveReceiptPdfParams params) async {
    logExecution('SaveReceiptPdf', params);

    try {
      final result = await repository.saveReceiptPdf(
        params.receipt,
        params.directoryPath,
      );

      result.fold(
        (failure) => logError('SaveReceiptPdf', failure),
        (filePath) => logSuccess('SaveReceiptPdf', 'PDF salvo em: $filePath'),
      );

      return result;
    } catch (e) {
      final failure = UnknownFailure(
        message: 'Erro inesperado ao salvar PDF: $e',
      );
      logError('SaveReceiptPdf', failure);
      return Left(failure);
    }
  }
}

/// Parâmetros para salvar PDF do cupom fiscal
class SaveReceiptPdfParams extends Equatable {
  final ReceiptEntity receipt;
  final String directoryPath;

  const SaveReceiptPdfParams({
    required this.receipt,
    required this.directoryPath,
  });

  @override
  List<Object?> get props => [receipt, directoryPath];

  @override
  String toString() => 'SaveReceiptPdfParams(receiptId: ${receipt.id}, directoryPath: $directoryPath)';
}
