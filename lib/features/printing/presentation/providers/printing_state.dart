import 'package:equatable/equatable.dart';
import '../../domain/entities/receipt_entity.dart';

/// Estados para a funcionalidade de impressão
abstract class PrintingState extends Equatable {
  const PrintingState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class PrintingInitial extends PrintingState {
  const PrintingInitial();
}

/// Estado de carregamento
class PrintingLoading extends PrintingState {
  const PrintingLoading();
}

/// Estado de PDF gerado com sucesso
class PdfGenerated extends PrintingState {
  final List<int> pdfBytes;
  final ReceiptEntity receipt;

  const PdfGenerated({
    required this.pdfBytes,
    required this.receipt,
  });

  @override
  List<Object?> get props => [pdfBytes, receipt];
}

/// Estado de PDF salvo com sucesso
class PdfSaved extends PrintingState {
  final String filePath;
  final ReceiptEntity receipt;

  const PdfSaved({
    required this.filePath,
    required this.receipt,
  });

  @override
  List<Object?> get props => [filePath, receipt];
}

/// Estado de impressão realizada com sucesso
class PrintingCompleted extends PrintingState {
  final ReceiptEntity receipt;

  const PrintingCompleted({required this.receipt});

  @override
  List<Object?> get props => [receipt];
}

/// Estado de erro
class PrintingError extends PrintingState {
  final String message;

  const PrintingError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Estado de prévia exibida
class PrintingPreviewShown extends PrintingState {
  final ReceiptEntity receipt;

  const PrintingPreviewShown({required this.receipt});

  @override
  List<Object?> get props => [receipt];
}
