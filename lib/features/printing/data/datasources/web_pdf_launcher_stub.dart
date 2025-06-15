/// Stub para plataformas não-web
/// Serviço específico para abrir PDFs no navegador web
class WebPdfLauncher {
  /// Abre PDF no navegador usando Blob API (stub para não-web)
  static void openPdfInBrowser(List<int> pdfBytes) {
    throw UnsupportedError('WebPdfLauncher só funciona em plataformas web');
  }
}
