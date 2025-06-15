import 'dart:typed_data';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfx/pdfx.dart';
import '../../core/constants/app_constants.dart';
import '../../features/printing/domain/entities/receipt_entity.dart';
import '../../providers/printing_providers.dart';

/// Widget para visualização de PDF do cupom fiscal
class PdfPreviewDialog extends ConsumerStatefulWidget {
  final Uint8List pdfBytes;
  final ReceiptEntity receipt;

  const PdfPreviewDialog({
    super.key,
    required this.pdfBytes,
    required this.receipt,
  });

  @override
  ConsumerState<PdfPreviewDialog> createState() => _PdfPreviewDialogState();
}

class _PdfPreviewDialogState extends ConsumerState<PdfPreviewDialog> {
  PdfController? _pdfController;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializePdf();
  }

  Future<void> _initializePdf() async {
    try {
      _pdfController = PdfController(
        document: PdfDocument.openData(widget.pdfBytes),
      );
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'Erro ao carregar PDF: $e';
        });
      }
    }
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: null,
      content: SizedBox(
        width: 600,
        height: 700,
        child: Column(
          children: [
            // Header customizado
            _buildHeader(),
            
            const SizedBox(height: AppSizes.paddingMedium),
            
            // Conteúdo do PDF
            Expanded(
              child: _buildPdfContent(),
            ),
            
            const SizedBox(height: AppSizes.paddingMedium),
            
            // Botões de ação
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryAccent.withValues(alpha: 0.15),
            AppColors.primaryAccent.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(
          color: AppColors.primaryAccent.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryAccent.withValues(alpha: 0.3),
                  AppColors.primaryAccent,
                ],
              ),
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryAccent.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              FluentIcons.receipt_processing,
              color: Colors.white,
              size: AppSizes.iconMedium,
            ),
          ),
          const SizedBox(width: AppSizes.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cupom Fiscal',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Nº ${widget.receipt.receiptNumber}',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPdfContent() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProgressRing(strokeWidth: 3, activeColor: AppColors.primaryAccent),
            const SizedBox(height: AppSizes.paddingMedium),
            Text(
              'Carregando cupom fiscal...',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FluentIcons.error,
              size: 48,
              color: AppColors.error,
            ),
            const SizedBox(height: AppSizes.paddingMedium),
            Text(
              'Erro ao carregar cupom',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.paddingSmall),
            Text(
              _error!,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (_pdfController == null) {
      return Center(
        child: Text(
          'PDF não disponível',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: PdfView(
          controller: _pdfController!,
          backgroundDecoration: const BoxDecoration(
            color: Colors.white,
          ),
          scrollDirection: Axis.vertical,
          pageSnapping: false,
        ),
      ),
    );
  }  Widget _buildActionButtons() {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Botão Fechar - seguindo padrão do design system
          Expanded(
            child: Button(
              style: ButtonStyle(
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingSmall,
                    vertical: AppSizes.paddingSmall,
                  ),
                ),
                backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.pressed)) {
                    return AppColors.surfaceVariant.withValues(alpha: 0.5);
                  }
                  if (states.contains(WidgetState.hovered)) {
                    return AppColors.surfaceVariant.withValues(alpha: 0.3);
                  }
                  return AppColors.surfaceVariant.withValues(alpha: 0.1);
                }),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FluentIcons.cancel,
                    size: AppSizes.iconSmall,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppSizes.paddingSmall),
                  Flexible(
                    child: Text(
                      'Fechar',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          
          // Espaçamento entre os botões
          const SizedBox(width: AppSizes.paddingSmall),
          
          // Botão Salvar PDF - com estilo secundário
          Expanded(
            child: Button(
              style: ButtonStyle(
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingSmall,
                    vertical: AppSizes.paddingSmall,
                  ),
                ),
                backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.pressed)) {
                    return AppColors.secondaryAccent.withValues(alpha: 0.8);
                  }
                  if (states.contains(WidgetState.hovered)) {
                    return AppColors.secondaryAccent.withValues(alpha: 0.9);
                  }
                  return AppColors.secondaryAccent;
                }),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FluentIcons.save,
                    size: AppSizes.iconSmall,
                    color: Colors.white,
                  ),
                  const SizedBox(width: AppSizes.paddingSmall),
                  Flexible(
                    child: Text(
                      'Salvar PDF',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              onPressed: () => _savePdf(),
            ),
          ),
          
          // Espaçamento entre os botões
          const SizedBox(width: AppSizes.paddingSmall),
          
          // Botão Imprimir - botão primário principal
          Expanded(
            child: FilledButton(
              style: ButtonStyle(
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingSmall,
                    vertical: AppSizes.paddingSmall,
                  ),
                ),
                backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.pressed)) {
                    return AppColors.primaryAccentPressed;
                  }
                  if (states.contains(WidgetState.hovered)) {
                    return AppColors.primaryAccentHover;
                  }
                  return AppColors.primaryAccent;
                }),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FluentIcons.print,
                    size: AppSizes.iconSmall,
                    color: Colors.white,
                  ),
                  const SizedBox(width: AppSizes.paddingSmall),
                  Flexible(
                    child: Text(
                      'Imprimir',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              onPressed: () => _printPdf(),
            ),
          ),
        ],
      ),
    );
  }
  void _savePdf() {
    // Exibe menu de opções para salvar
    _showSaveOptionsDialog();
  }

  void _showSaveOptionsDialog() {
    showDialog(
      context: context,
      builder: (context) => ContentDialog(
        title: Row(
          children: [
            Icon(FluentIcons.save, color: AppColors.secondaryAccent),
            const SizedBox(width: 8),
            const Text('Salvar PDF'),
          ],
        ),
        content: const Text('Escolha onde deseja salvar o PDF do cupom fiscal:'),        actions: [
          // Cancelar
          Button(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          // Pasta Padrão
          Button(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(AppColors.surfaceVariant),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(FluentIcons.folder, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'Pasta Padrão',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Fecha o diálogo de opções
              ref.read(printingProvider.notifier).saveOrderReceiptPdf(widget.receipt.order);
              Navigator.of(context).pop(); // Fecha o diálogo do PDF
            },
          ),
          // Escolher Pasta
          FilledButton(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(FluentIcons.folder_open, size: 14, color: Colors.white),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'Escolher Pasta',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Fecha o diálogo de opções
              ref.read(printingProvider.notifier).saveOrderReceiptPdfWithPicker(widget.receipt.order);
              Navigator.of(context).pop(); // Fecha o diálogo do PDF
            },
          ),
        ],
      ),
    );
  }

  void _printPdf() {
    // Tenta imprimir (se tiver impressora disponível)
    ref.read(printingProvider.notifier).printOrderReceipt(widget.receipt.order);
    Navigator.of(context).pop();
  }
}
