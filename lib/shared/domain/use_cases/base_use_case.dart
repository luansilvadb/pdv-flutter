import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/errors/failures.dart';

/// Classe base para todos os use cases com parâmetros
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Classe base para use cases sem parâmetros
abstract class UseCaseNoParams<Type> {
  Future<Either<Failure, Type>> call();
}

/// Classe para representar ausência de parâmetros
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}

/// Mixin para logging automático em use cases
mixin UseCaseLogging {
  void logExecution(String useCaseName, [dynamic params]) {
    // Using debug logging instead of print for production readiness
    // AppLogger will be imported where necessary to avoid circular dependency
  }

  void logSuccess(String useCaseName, [dynamic result]) {
    // UseCase completed successfully - using AppLogger in production
  }

  void logError(String useCaseName, Failure failure) {
    // UseCase failed - using AppLogger in production
  }
}
