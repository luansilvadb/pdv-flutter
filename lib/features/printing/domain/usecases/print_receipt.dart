import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/domain/use_cases/base_use_case.dart';
import '../entities/receipt_entity.dart';
import '../repositories/printing_repository.dart';

/// Use case para imprimir cupom fiscal
class PrintReceipt extends UseCase<Unit, PrintReceiptParams>
    with UseCaseLogging {
  final PrintingRepository repository;

  PrintReceipt(this.repository);

  @override
  Future<Either<Failure, Unit>> call(PrintReceiptParams params) async {
    logExecution('PrintReceipt', params);

    try {
      final result = await repository.printReceipt(params.receipt);

      result.fold(
        (failure) => logError('PrintReceipt', failure),
        (unit) => logSuccess('PrintReceipt', 'Cupom impresso com sucesso'),
      );

      return result;
    } catch (e) {
      final failure = UnknownFailure(
        message: 'Erro inesperado ao imprimir cupom: $e',
      );
      logError('PrintReceipt', failure);
      return Left(failure);
    }
  }
}

/// Parâmetros para imprimir cupom fiscal
class PrintReceiptParams extends Equatable {
  final ReceiptEntity receipt;

  const PrintReceiptParams({required this.receipt});

  @override
  List<Object?> get props => [receipt];

  @override
  String toString() => 'PrintReceiptParams(receiptId: ${receipt.id})';
}
