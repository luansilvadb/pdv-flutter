@echo off
echo 🚀 Iniciando build otimizado para produção...

REM Limpar builds anteriores
echo 🧹 Limpando builds anteriores...
call flutter clean

REM Obter dependências
echo 📦 Obtendo dependências...
call flutter pub get

REM Build com otimizações máximas (sintaxe correta Flutter)
echo 🔧 Executando build otimizado...
call flutter build web ^
  --release ^
  --tree-shake-icons ^
  --source-maps ^
  --optimization-level=4 ^
  --dart-define=FLUTTER_WEB_CANVASKIT_URL=https://unpkg.com/canvaskit-wasm@latest/bin/ ^
  --base-href="/"

if %ERRORLEVEL% equ 0 (
    echo ✅ Build concluído com sucesso!
    
    echo 📊 Estatísticas do build:
    echo Tamanho total do diretório build/web:
    dir build\web /s | find "bytes"
    
    echo.
    echo Arquivos principais:
    if exist "build\web\*.js" dir build\web\*.js
    if exist "build\web\*.html" dir build\web\*.html
    if exist "build\web\*.json" dir build\web\*.json
    
    echo.
    echo Ícones gerados:
    if exist "build\web\icons\" dir build\web\icons\
    
    echo.
    echo 📈 Executando análise de bundle...
    node scripts/analyze-bundle.js
    
) else (
    echo ❌ Erro no build!
    exit /b 1
)

echo 🎉 Build otimizado pronto para deploy na Vercel!
echo 🌐 Para testar localmente: npm run serve:local
pause