import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

/// Type alias para Either com Failure
typedef FutureEither<T> = Future<Either<Failure, T>>;

/// Type alias para Either sem Future
typedef EitherResult<T> = Either<Failure, T>;

/// Type alias para função que retorna `Future<void>`
typedef VoidCallback = Future<void> Function();

/// Type alias para função que retorna `Future<bool>`
typedef BoolCallback = Future<bool> Function();

/// Type alias para função que retorna `Future<String>`
typedef StringCallback = Future<String> Function();

/// Type alias para mapa de parâmetros
typedef Params = Map<String, dynamic>;

/// Type alias para lista de objetos dinâmicos
typedef DataList = List<Map<String, dynamic>>;

/// Type alias para JSON object
typedef Json = Map<String, dynamic>;
