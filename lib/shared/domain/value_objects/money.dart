import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

/// Value Object para representar valores monetários
class Money extends Equatable {
  final double value;

  const Money(this.value);

  /// Valor zero
  static const Money zero = Money(0.0);

  /// Formata o valor monetário
  String get formatted => NumberFormat.currency(
    symbol: 'R\$',
    decimalDigits: 2,
    locale: 'pt_BR',
  ).format(value);

  /// Formata o valor sem símbolo
  String get formattedWithoutSymbol =>
      NumberFormat.currency(
        symbol: '',
        decimalDigits: 2,
        locale: 'pt_BR',
      ).format(value).trim();

  /// Verifica se é zero
  bool get isZero => value == 0.0;

  /// Verifica se é positivo
  bool get isPositive => value > 0.0;

  /// Verifica se é negativo
  bool get isNegative => value < 0.0;

  /// Valor absoluto
  Money get abs => Money(value.abs());

  /// Operações matemáticas
  Money operator +(Money other) => Money(value + other.value);
  Money operator -(Money other) => Money(value - other.value);
  Money operator *(double multiplier) => Money(value * multiplier);
  Money operator /(double divisor) => Money(value / divisor);

  /// Operadores de comparação
  bool operator >(Money other) => value > other.value;
  bool operator <(Money other) => value < other.value;
  bool operator >=(Money other) => value >= other.value;
  bool operator <=(Money other) => value <= other.value;

  /// Calcula porcentagem
  Money percentage(double percent) => Money(value * (percent / 100));

  /// Aplica desconto
  Money discount(double percent) => Money(value * (1 - percent / 100));

  /// Aplica taxa/imposto
  Money tax(double percent) => Money(value * (1 + percent / 100));

  /// Arredonda para cima
  Money ceil() => Money(value.ceilToDouble());

  /// Arredonda para baixo
  Money floor() => Money(value.floorToDouble());

  /// Arredonda
  Money round() => Money(value.roundToDouble());

  /// Converte para string
  @override
  String toString() => formatted;

  @override
  List<Object?> get props => [value];
}
