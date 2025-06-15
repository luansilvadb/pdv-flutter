import 'dart:convert';
import 'dart:js_interop';
import 'package:web/web.dart';
import 'package:flutter/foundation.dart';

/// Serviço específico para abrir PDFs no navegador web
class WebPdfLauncher {
  /// Abre PDF no navegador usando Blob API
  static void openPdfInBrowser(List<int> pdfBytes) {
    if (kIsWeb) {
      try {
        // Converte List<int> para Uint8List
        final uint8List = Uint8List.fromList(pdfBytes);
        
        // Cria um blob com os bytes do PDF usando a nova API
        final blob = Blob([uint8List.toJS].toJS, BlobPropertyBag(type: 'application/pdf'));
        
        // Cria uma URL para o blob
        final url = URL.createObjectURL(blob);
        
        // Abre em nova janela/aba
        window.open(url, '_blank');
        
        // Limpa a URL após um tempo para economizar memória
        Future.delayed(const Duration(seconds: 10), () {
          URL.revokeObjectURL(url);
        });
      } catch (e) {
        // Fallback: usa data URL
        final dataUrl = 'data:application/pdf;base64,${base64Encode(pdfBytes)}';
        window.open(dataUrl, '_blank');
      }
    }
  }
}
