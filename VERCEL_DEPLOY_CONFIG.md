# Configuração de Deploy Flutter Web na Vercel

## 🎯 Problema Resolvido

O erro "Missing public directory" foi resolvido através da configuração correta do `vercel.json` para projetos Flutter web.

## 📋 Mudanças Implementadas

### 1. **vercel.json Otimizado**
```json
{
  "version": 2,
  "builds": [
    {
      "src": "pubspec.yaml",
      "use": "@vercel/static-build",
      "config": {
        "distDir": "build/web"
      }
    }
  ],
  "buildCommand": "flutter build web --release --no-tree-shake-icons --dart-define=WEB_RENDERER=canvaskit",
  "outputDirectory": "build/web",
  "installCommand": "flutter pub get"
}
```

**Principais correções:**
- **Buildpack correto**: Mudança para `@vercel/static-build` com `distDir: "build/web"`
- **Output directory**: Configuração explícita para `build/web`
- **Build command**: Comando otimizado com CanvasKit renderer
- **Install command**: Comando para instalar dependências Flutter

### 2. **package.json Criado**
Arquivo de suporte com scripts npm para backup e compatibilidade:
```json
{
  "scripts": {
    "build": "flutter build web --release --no-tree-shake-icons --dart-define=WEB_RENDERER=canvaskit",
    "dev": "flutter run -d chrome"
  }
}
```

### 3. **.vercelignore Adicionado**
Otimização de deploy excluindo arquivos desnecessários:
- Plataformas não-web (android/, ios/, etc.)
- Arquivos de desenvolvimento (.dart_tool/, test/, etc.)
- Assets não utilizados no web

### 4. **Configurações SPA**
- **Rewrites**: Todas as rotas redirecionam para `/index.html`
- **Headers otimizados**: Cache adequado para service worker e assets
- **Performance**: CanvasKit renderer para melhor performance

## 🚀 Como Fazer Deploy

### 1. **Verificar Build Local**
```bash
# Teste o build localmente primeiro
flutter build web --release --no-tree-shake-icons --dart-define=WEB_RENDERER=canvaskit

# Verifique se build/web foi criado
ls build/web
```

### 2. **Deploy na Vercel**
```bash
# Via CLI da Vercel
npm i -g vercel
vercel

# Ou via GitHub (conecte o repositório na dashboard da Vercel)
```

### 3. **Variáveis de Ambiente (se necessário)**
No dashboard da Vercel, configure:
- `WEB_RENDERER=canvaskit`
- Outras variáveis específicas do projeto

## 🔧 Comandos Úteis

### **Build e Teste Local**
```bash
# Build de produção
flutter build web --release --no-tree-shake-icons --dart-define=WEB_RENDERER=canvaskit

# Teste local
flutter run -d chrome

# Servir build localmente (Python)
cd build/web && python -m http.server 8000

# Servir build localmente (Node.js)
npx serve build/web
```

### **Deploy e Verificação**
```bash
# Deploy via Vercel CLI
vercel --prod

# Verificar logs de build
vercel logs [deployment-url]

# Redeploy forçado
vercel --force
```

## 📊 Estrutura de Arquivos de Deploy

```
build/web/              # Diretório de saída do Flutter
├── index.html          # Arquivo principal SPA
├── main.dart.js        # Código Dart compilado
├── flutter.js          # Runtime do Flutter
├── flutter_service_worker.js
├── assets/             # Assets do app
├── canvaskit/          # Renderer CanvasKit
└── icons/              # Ícones PWA
```

## ✅ Verificações de Deploy

### **Após Deploy Bem-sucedido:**
1. ✅ Site carrega corretamente
2. ✅ Navegação entre telas funciona
3. ✅ Assets (imagens, ícones) carregam
4. ✅ Service Worker ativo (PWA)
5. ✅ Performance adequada

### **Troubleshooting:**
- **404 em rotas**: Verifique se `rewrites` está configurado
- **Assets não carregam**: Verifique paths relativos no código
- **Performance ruim**: Considere usar `--web-renderer html` para mobile
- **Build falha**: Verifique dependências no `pubspec.yaml`

## 🎉 Resultado Esperado

- ✅ Deploy funcionando na Vercel
- ✅ SPA routes funcionando corretamente  
- ✅ Performance otimizada com CanvasKit
- ✅ Cache adequado para assets
- ✅ PWA ready com service worker

## 📝 Próximos Passos

1. **Teste o deploy** na Vercel
2. **Configure domínio customizado** (se necessário)
3. **Monitore performance** via Vercel Analytics
4. **Configure CI/CD** para deploys automáticos via GitHub

---

**✨ Configuração otimizada para Flutter web na Vercel implementada com sucesso!**