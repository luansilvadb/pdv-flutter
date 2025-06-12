import 'package:dartz/dartz.dart';
import '../utils/logger.dart';
import '../errors/failures.dart';
import '../errors/exceptions.dart';

/// Exceção de regra de negócio
class BusinessRuleException extends AppException {
  const BusinessRuleException({
    super.message = 'Regra de negócio violada',
    super.code,
    super.cause,
  });
}

/// Falha de regra de negócio
class BusinessRuleFailure extends Failure {
  const BusinessRuleFailure({
    super.message = 'Regra de negócio violada',
    super.code,
    super.error,
  });
}

/// Manipulador centralizado de erros da aplicação
class ErrorHandler {
  /// Converte exceções em failures
  static Failure handleException(Exception exception) {
    AppLogger.error('Exception handled: ${exception.toString()}', exception);

    switch (exception.runtimeType) {
      case ServerException _:
        return ServerFailure(message: 'Erro no servidor');
      case CacheException _:
        return CacheFailure(message: 'Erro no cache local');
      case NetworkException _:
        return NetworkFailure(message: 'Erro de conexão');
      case ValidationException _:
        final validationException = exception as ValidationException;
        return ValidationFailure(message: validationException.message);
      case BusinessRuleException _:
        final businessException = exception as BusinessRuleException;
        return BusinessRuleFailure(message: businessException.message);
      case StorageException _:
        final storageException = exception as StorageException;
        return StorageFailure(message: storageException.message);
      case TimeoutException _:
        final timeoutException = exception as TimeoutException;
        return TimeoutFailure(message: timeoutException.message);
      case ParseException _:
        final parseException = exception as ParseException;
        return ParseFailure(message: parseException.message);
      case NotFoundException _:
        final notFoundException = exception as NotFoundException;
        return NotFoundFailure(message: notFoundException.message);
      case PermissionException _:
        final permissionException = exception as PermissionException;
        return PermissionFailure(message: permissionException.message);
      default:
        return UnknownFailure(
          message: 'Erro desconhecido: ${exception.toString()}',
        );
    }
  }

  /// Executa uma operação com tratamento de erro
  static Future<Either<Failure, T>> handleAsyncOperation<T>(
    Future<T> Function() operation, {
    String? context,
  }) async {
    try {
      AppLogger.debug('Executing operation: ${context ?? 'Unknown'}');
      final result = await operation();
      AppLogger.debug(
        'Operation completed successfully: ${context ?? 'Unknown'}',
      );
      return Right(result);
    } on Exception catch (exception, stackTrace) {
      AppLogger.error(
        'Operation failed: ${context ?? 'Unknown'}',
        exception,
        stackTrace,
      );
      return Left(handleException(exception));
    } catch (error, stackTrace) {
      AppLogger.error(
        'Unexpected error in operation: ${context ?? 'Unknown'}',
        error,
        stackTrace,
      );
      return Left(
        UnknownFailure(message: 'Erro inesperado: ${error.toString()}'),
      );
    }
  }

  /// Executa uma operação síncrona com tratamento de erro
  static Either<Failure, T> handleSyncOperation<T>(
    T Function() operation, {
    String? context,
  }) {
    try {
      AppLogger.debug('Executing sync operation: ${context ?? 'Unknown'}');
      final result = operation();
      AppLogger.debug(
        'Sync operation completed successfully: ${context ?? 'Unknown'}',
      );
      return Right(result);
    } on Exception catch (exception, stackTrace) {
      AppLogger.error(
        'Sync operation failed: ${context ?? 'Unknown'}',
        exception,
        stackTrace,
      );
      return Left(handleException(exception));
    } catch (error, stackTrace) {
      AppLogger.error(
        'Unexpected error in sync operation: ${context ?? 'Unknown'}',
        error,
        stackTrace,
      );
      return Left(
        UnknownFailure(message: 'Erro inesperado: ${error.toString()}'),
      );
    }
  }

  /// Registra um erro crítico
  static void reportCriticalError(
    dynamic error,
    StackTrace stackTrace, {
    String? context,
    Map<String, dynamic>? metadata,
  }) {
    AppLogger.error(
      'CRITICAL ERROR: ${context ?? 'Unknown context'}',
      error,
      stackTrace,
    );

    // Em produção, enviar para serviço de crash reporting
    // FirebaseCrashlytics.instance.recordError(error, stackTrace);
  }
}
