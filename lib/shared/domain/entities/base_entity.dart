import 'package:equatable/equatable.dart';

/// Classe base para todas as entidades do domínio
abstract class Entity extends Equatable {
  /// Identificador único da entidade
  String get id;

  /// Data de criação da entidade
  DateTime get createdAt;

  /// Data da última atualização
  DateTime get updatedAt;

  const Entity();

  @override
  List<Object?> get props => [id];

  @override
  bool get stringify => true;
}

/// Mixin para entidades que podem ser marcadas como ativas/inativas
mixin ActivatableMixin {
  bool get isActive;

  Entity activate();
  Entity deactivate();
}

/// Mixin para entidades que possuem timestamp de criação e atualização
mixin TimestampMixin {
  DateTime get createdAt;
  DateTime get updatedAt;

  Entity updateTimestamp();
}

/// Mixin para entidades que podem ser versionadas
mixin VersionableMixin {
  int get version;

  Entity incrementVersion();
}
