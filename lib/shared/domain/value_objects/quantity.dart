import 'package:equatable/equatable.dart';

/// Value Object para representar quantidades
/// Seguindo Clean Architecture - sem dependências de UI
class Quantity extends Equatable {
  final int value;

  const Quantity(this.value);

  /// Quantidade zero
  static const Quantity zero = Quantity(0);

  /// Quantidade unitária
  static const Quantity one = Quantity(1);

  /// Verifica se é zero
  bool get isEmpty => value == 0;

  /// Verifica se é baixo estoque (<=5)
  bool get isLow => value <= 5 && value > 0;

  /// Verifica se está disponível
  bool get isAvailable => value > 0;

  /// Verifica se é positivo
  bool get isPositive => value > 0;

  /// Verifica se é negativo
  bool get isNegative => value < 0;

  /// Incrementa a quantidade
  Quantity increment() => Quantity(value + 1);

  /// Decrementa a quantidade (não permite valores negativos)
  Quantity decrement() => value > 0 ? Quantity(value - 1) : this;

  /// Adiciona uma quantidade específica
  Quantity add(int amount) => Quantity(value + amount);

  /// Subtrai uma quantidade específica (não permite valores negativos)
  Quantity subtract(int amount) {
    final newValue = value - amount;
    return Quantity(newValue < 0 ? 0 : newValue);
  }

  /// Multiplica a quantidade
  Quantity multiply(int multiplier) => Quantity(value * multiplier);

  /// Status do estoque como enum para manter separação de camadas
  QuantityStatus get status {
    if (isEmpty) return QuantityStatus.unavailable;
    if (isLow) return QuantityStatus.low;
    return QuantityStatus.available;
  }

  /// Texto descritivo do status
  String get statusText {
    switch (status) {
      case QuantityStatus.unavailable:
        return 'Indisponível';
      case QuantityStatus.low:
        return 'Estoque baixo';
      case QuantityStatus.available:
        return 'Disponível';
    }
  }

  /// Operadores de comparação
  bool operator >(Quantity other) => value > other.value;
  bool operator <(Quantity other) => value < other.value;
  bool operator >=(Quantity other) => value >= other.value;
  bool operator <=(Quantity other) => value <= other.value;

  /// Operadores matemáticos
  Quantity operator +(Quantity other) => Quantity(value + other.value);
  Quantity operator -(Quantity other) => subtract(other.value);

  /// Valor absoluto
  Quantity get abs => Quantity(value.abs());

  /// Converte para string
  @override
  String toString() => value.toString();

  /// Formato com unidade
  String format({String unit = 'un'}) => '$value $unit';

  @override
  List<Object?> get props => [value];
}

/// Enum para representar o status do estoque sem dependências de UI
enum QuantityStatus { unavailable, low, available }
