import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/domain/use_cases/base_use_case.dart';
import '../entities/receipt_entity.dart';
import '../repositories/printing_repository.dart';

/// Use case para gerar bytes do PDF para visualização interna
class GeneratePdfBytes extends UseCase<List<int>, GeneratePdfBytesParams>
    with UseCaseLogging {
  final PrintingRepository repository;

  GeneratePdfBytes(this.repository);

  @override
  Future<Either<Failure, List<int>>> call(GeneratePdfBytesParams params) async {
    logExecution('GeneratePdfBytes', params);

    try {
      final result = await repository.generatePdfBytes(params.receipt);

      result.fold(
        (failure) => logError('GeneratePdfBytes', failure),
        (pdfBytes) => logSuccess('GeneratePdfBytes', 'PDF bytes gerados: ${pdfBytes.length}'),
      );

      return result;
    } catch (e) {
      final failure = UnknownFailure(
        message: 'Erro inesperado ao gerar PDF bytes: $e',
      );
      logError('GeneratePdfBytes', failure);
      return Left(failure);
    }
  }
}

/// Parâmetros para gerar bytes do PDF
class GeneratePdfBytesParams extends Equatable {
  final ReceiptEntity receipt;

  const GeneratePdfBytesParams({required this.receipt});

  @override
  List<Object?> get props => [receipt];

  @override
  String toString() => 'GeneratePdfBytesParams(receiptId: ${receipt.id})';
}
