import 'package:equatable/equatable.dart';

/// Classe base para representar falhas no sistema
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final dynamic error;

  const Failure({required this.message, this.code, this.error});

  @override
  List<Object?> get props => [message, code, error];
}

/// Falha de servidor
class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'Erro do servidor',
    super.code,
    super.error,
  });
}

/// Falha de cache
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Erro de cache',
    super.code,
    super.error,
  });
}

/// Falha de rede
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Erro de conectividade',
    super.code,
    super.error,
  });
}

/// Falha de validação
class ValidationFailure extends Failure {
  const ValidationFailure({
    super.message = 'Erro de validação',
    super.code,
    super.error,
  });
}

/// Falha não encontrado
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'Recurso não encontrado',
    super.code,
    super.error,
  });
}

/// Falha de permissão
class PermissionFailure extends Failure {
  const PermissionFailure({
    super.message = 'Permissão negada',
    super.code,
    super.error,
  });
}

/// Falha de timeout
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'Timeout na operação',
    super.code,
    super.error,
  });
}

/// Falha de parsing/serialização
class ParseFailure extends Failure {
  const ParseFailure({
    super.message = 'Erro ao processar dados',
    super.code,
    super.error,
  });
}

/// Falha de storage local
class StorageFailure extends Failure {
  const StorageFailure({
    super.message = 'Erro no armazenamento local',
    super.code,
    super.error,
  });
}

/// Falha genérica/desconhecida
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'Erro desconhecido',
    super.code,
    super.error,
  });
}
