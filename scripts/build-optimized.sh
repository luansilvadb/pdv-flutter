#!/bin/bash

# Script de build otimizado para Flutter Web - Vercel Deploy
echo "🚀 Iniciando build otimizado para produção..."

# Limpar builds anteriores
echo "🧹 Limpando builds anteriores..."
flutter clean

# Obter dependências
echo "📦 Obtendo dependências..."
flutter pub get

# Build com otimizações máximas (sintaxe correta Flutter)
echo "🔧 Executando build otimizado..."
flutter build web \
  --release \
  --tree-shake-icons \
  --source-maps \
  --optimization-level=4 \
  --dart-define=FLUTTER_WEB_CANVASKIT_URL=https://unpkg.com/canvaskit-wasm@latest/bin/ \
  --base-href="/"

# Verificar se o build foi bem-sucedido
if [ $? -eq 0 ]; then
    echo "✅ Build concluído com sucesso!"
    
    # Mostrar estatísticas do build
    echo "📊 Estatísticas do build:"
    echo "Tamanho total do diretório build/web:"
    du -sh build/web/
    
    echo ""
    echo "Arquivos principais:"
    ls -lh build/web/*.{js,html,json} 2>/dev/null || echo "Nenhum arquivo principal encontrado"
    
    echo ""
    echo "Ícones gerados:"
    ls -lh build/web/icons/ 2>/dev/null || echo "Diretório de ícones não encontrado"
    
    echo ""
    echo "📈 Executando análise de bundle..."
    node scripts/analyze-bundle.js
    
else
    echo "❌ Erro no build!"
    exit 1
fi

echo "🎉 Build otimizado pronto para deploy na Vercel!"
echo "🌐 Para testar localmente: npm run serve:local"