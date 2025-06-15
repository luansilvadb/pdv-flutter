import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Utilitários para manipulação de caminhos com fallbacks
class PathUtils {
  /// Obtém o diretório de documentos com fallback para diferentes plataformas
  static Future<String> getDocumentsDirectory() async {
    try {
      if (kIsWeb) {
        // Para web, retorna um path simbólico
        return '/downloads';
      }
      
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    } catch (e) {
      // Fallback para quando getApplicationDocumentsDirectory falha
      return _getDefaultDocumentsPath();
    }
  }
  
  /// Obtém o diretório para cupons fiscais
  static Future<String> getCuponsDirectory() async {
    final documentsPath = await getDocumentsDirectory();
    return '$documentsPath/PDV_Restaurant/cupons_fiscais';
  }
  
  /// Path padrão para documentos quando o plugin falha
  static String _getDefaultDocumentsPath() {
    if (kIsWeb) {
      return '/downloads';
    }
    
    // Para Windows
    return r'C:\Users\Public\Documents';
  }
}
