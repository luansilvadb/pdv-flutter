/// Classe base para exceções específicas do domínio
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic cause;

  const AppException({required this.message, this.code, this.cause});

  @override
  String toString() {
    return 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
  }
}

/// Exceção de servidor
class ServerException extends AppException {
  const ServerException({
    super.message = 'Erro do servidor',
    super.code,
    super.cause,
  });
}

/// Exceção de cache
class CacheException extends AppException {
  const CacheException({
    super.message = 'Erro de cache',
    super.code,
    super.cause,
  });
}

/// Exceção de rede
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'Erro de conectividade',
    super.code,
    super.cause,
  });
}

/// Exceção de validação
class ValidationException extends AppException {
  const ValidationException({
    super.message = 'Erro de validação',
    super.code,
    super.cause,
  });
}

/// Exceção não encontrado
class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'Recurso não encontrado',
    super.code,
    super.cause,
  });
}

/// Exceção de permissão
class PermissionException extends AppException {
  const PermissionException({
    super.message = 'Permissão negada',
    super.code,
    super.cause,
  });
}

/// Exceção de timeout
class TimeoutException extends AppException {
  const TimeoutException({
    super.message = 'Timeout na operação',
    super.code,
    super.cause,
  });
}

/// Exceção de parsing/serialização
class ParseException extends AppException {
  const ParseException({
    super.message = 'Erro ao processar dados',
    super.code,
    super.cause,
  });
}

/// Exceção de storage local
class StorageException extends AppException {
  const StorageException({
    super.message = 'Erro no armazenamento local',
    super.code,
    super.cause,
  });
}
