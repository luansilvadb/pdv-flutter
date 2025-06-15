import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../../domain/entities/receipt_entity.dart';

/// Gerador de PDF para cupons fiscais
abstract class PdfGenerator {
  /// Gera PDF do cupom fiscal
  Future<Uint8List> generateReceiptPdf(ReceiptEntity receipt);
}

/// Implementação do gerador de PDF
class PdfGeneratorImpl implements PdfGenerator {
  @override
  Future<Uint8List> generateReceiptPdf(ReceiptEntity receipt) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss', 'pt_BR');
    final currencyFormat = NumberFormat.currency(
      symbol: 'R\$',
      decimalDigits: 2,
      locale: 'pt_BR',
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Cabeçalho do estabelecimento
              _buildHeader(receipt),
              
              pw.SizedBox(height: 20),
              
              // Separador
              pw.Divider(thickness: 2),
              
              pw.SizedBox(height: 10),
              
              // Título do cupom
              pw.Center(
                child: pw.Text(
                  'CUPOM FISCAL',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              
              pw.SizedBox(height: 10),
              
              // Informações do cupom
              _buildReceiptInfo(receipt, dateFormat),
              
              pw.SizedBox(height: 20),
              
              // Itens do pedido
              _buildItemsSection(receipt, currencyFormat),
              
              pw.SizedBox(height: 20),
              
              // Totais
              _buildTotalsSection(receipt, currencyFormat),
              
              pw.SizedBox(height: 20),
              
              // Informações de pagamento
              _buildPaymentInfo(receipt),
              
              pw.SizedBox(height: 30),
              
              // Rodapé
              _buildFooter(receipt, dateFormat),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  /// Constrói o cabeçalho do estabelecimento
  pw.Widget _buildHeader(ReceiptEntity receipt) {
    return pw.Container(
      alignment: pw.Alignment.center,
      child: pw.Column(
        children: [
          pw.Text(
            receipt.establishmentName ?? 'PDV Restaurant',
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          if (receipt.establishmentAddress != null) ...[
            pw.SizedBox(height: 5),
            pw.Text(
              receipt.establishmentAddress!,
              style: const pw.TextStyle(fontSize: 12),
            ),
          ],
          if (receipt.establishmentPhone != null) ...[
            pw.SizedBox(height: 2),
            pw.Text(
              'Tel: ${receipt.establishmentPhone!}',
              style: const pw.TextStyle(fontSize: 12),
            ),
          ],
          if (receipt.establishmentCnpj != null) ...[
            pw.SizedBox(height: 2),
            pw.Text(
              'CNPJ: ${receipt.establishmentCnpj!}',
              style: const pw.TextStyle(fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  /// Constrói as informações do cupom
  pw.Widget _buildReceiptInfo(ReceiptEntity receipt, DateFormat dateFormat) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'Cupom Nº: ${receipt.receiptNumber}',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              'Pedido: #${receipt.order.id.substring(receipt.order.id.length - 8)}',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),
        pw.SizedBox(height: 5),
        pw.Text('Data/Hora: ${dateFormat.format(receipt.issuedAt)}'),
        if (receipt.order.customerName != null) ...[
          pw.SizedBox(height: 5),
          pw.Text('Cliente: ${receipt.order.customerName!}'),
        ],
      ],
    );
  }

  /// Constrói a seção de itens
  pw.Widget _buildItemsSection(ReceiptEntity receipt, NumberFormat currencyFormat) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'ITENS',
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        
        // Cabeçalho da tabela
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 5),
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(width: 1),
              top: pw.BorderSide(width: 1),
            ),
          ),
          child: pw.Row(
            children: [
              pw.Expanded(flex: 1, child: pw.Text('QTD', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
              pw.Expanded(flex: 3, child: pw.Text('DESCRIÇÃO', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
              pw.Expanded(flex: 2, child: pw.Text('PREÇO UNIT.', style: pw.TextStyle(fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right)),
              pw.Expanded(flex: 2, child: pw.Text('TOTAL', style: pw.TextStyle(fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right)),
            ],
          ),
        ),
        
        // Itens
        ...receipt.order.items.map((item) => pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 3),
          child: pw.Row(
            children: [
              pw.Expanded(flex: 1, child: pw.Text('${item.quantity.value}')),
              pw.Expanded(flex: 3, child: pw.Text(item.productName)),
              pw.Expanded(flex: 2, child: pw.Text(currencyFormat.format(item.price.value), textAlign: pw.TextAlign.right)),
              pw.Expanded(flex: 2, child: pw.Text(currencyFormat.format(item.totalPrice.value), textAlign: pw.TextAlign.right)),
            ],
          ),
        )),
        
        pw.Container(
          margin: const pw.EdgeInsets.only(top: 5),
          decoration: const pw.BoxDecoration(
            border: pw.Border(top: pw.BorderSide(width: 1)),
          ),
        ),
      ],
    );
  }

  /// Constrói a seção de totais
  pw.Widget _buildTotalsSection(ReceiptEntity receipt, NumberFormat currencyFormat) {
    return pw.Column(
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Subtotal:'),
            pw.Text(currencyFormat.format(receipt.order.subtotal.value)),
          ],
        ),
        pw.SizedBox(height: 5),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Taxa de Serviço (10%):'),
            pw.Text(currencyFormat.format(receipt.order.tax.value)),
          ],
        ),
        pw.SizedBox(height: 5),
        if (receipt.order.discount.value > 0) ...[
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Desconto:'),
              pw.Text('-${currencyFormat.format(receipt.order.discount.value)}'),
            ],
          ),
          pw.SizedBox(height: 5),
        ],
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 8),
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              top: pw.BorderSide(width: 2),
              bottom: pw.BorderSide(width: 2),
            ),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'TOTAL:',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                currencyFormat.format(receipt.order.total.value),
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Constrói as informações de pagamento
  pw.Widget _buildPaymentInfo(ReceiptEntity receipt) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'FORMA DE PAGAMENTO',
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 5),
        pw.Text(receipt.order.paymentMethod.displayName),
      ],
    );
  }

  /// Constrói o rodapé
  pw.Widget _buildFooter(ReceiptEntity receipt, DateFormat dateFormat) {
    return pw.Column(
      children: [
        pw.Divider(),
        pw.SizedBox(height: 10),
        pw.Center(
          child: pw.Text(
            'Obrigado pela preferência!',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.SizedBox(height: 5),
        pw.Center(
          child: pw.Text(
            'Volte sempre!',
            style: const pw.TextStyle(fontSize: 12),
          ),
        ),
        pw.SizedBox(height: 20),
        pw.Center(
          child: pw.Text(
            'Este cupom não tem valor fiscal',
            style: const pw.TextStyle(fontSize: 10),
          ),
        ),
        pw.SizedBox(height: 5),
        pw.Center(
          child: pw.Text(
            'Emitido em: ${dateFormat.format(receipt.issuedAt)}',
            style: const pw.TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }
}
