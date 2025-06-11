# 🚀 Guia de Deploy - Vercel (Auto-Detecção)

Este guia explica como fazer deploy automático do projeto Flutter Web no Vercel com detecção automática de framework.

## ✅ Configurações Otimizadas

O projeto já está configurado para **auto-detecção** do Vercel. As seguintes otimizações foram aplicadas:

### 📁 Arquivos de Configuração

- **`vercel.json`** - Configurado sem `framework: null` para permitir auto-detecção
- **`package.json`** - Simplificado com informações essenciais para detecção
- **`pubspec.yaml`** - Configurações explícitas de Flutter Web
- **`.nvmrc`** - Especifica versão do Node.js (18)

## 🎯 Como Importar no Vercel (Site)

### 1. Acesse o Vercel Dashboard
```
https://vercel.com/dashboard
```

### 2. Clique em "Add New..." → "Project"

### 3. Conecte seu Repositório GitHub
- Selecione "Import Git Repository"
- Autorize o Vercel a acessar seu GitHub (se necessário)
- Escolha o repositório `pdv-restaurant-flutter`

### 4. ✨ Configuração Automática
O Vercel deve **detectar automaticamente**:

```
✅ Framework Preset: Flutter
✅ Build Command: flutter build web --release --tree-shake-icons --source-maps --base-href /
✅ Output Directory: build/web
✅ Install Command: flutter pub get
```

### 5. Se a Auto-Detecção Falhar
**Caso o Vercel não detecte automaticamente**, configure manualmente:

#### Framework Settings:
- **Framework Preset**: `Other`
- **Build Command**: 
  ```bash
  flutter build web --release --tree-shake-icons --source-maps --base-href /
  ```
- **Output Directory**: `build/web`
- **Install Command**: `flutter pub get`

#### Environment Variables (opcional):
```
FLUTTER_WEB_CANVASKIT_URL=https://unpkg.com/canvaskit-wasm@latest/bin/
```

### 6. Deploy
- Clique em **"Deploy"**
- O Vercel irá:
  1. Instalar Flutter SDK
  2. Executar `flutter pub get`
  3. Fazer build do projeto
  4. Deploy automático

## 🔄 Deploy Automático (GitHub Integration)

### Configuração do GitHub
Após o primeiro deploy, o Vercel automaticamente:

1. **Monitora o repositório** - Detecta novos commits
2. **Deploy automático** - A cada push na branch principal
3. **Preview deploys** - Para Pull Requests
4. **Rollback fácil** - Se necessário

### Branches Configuradas
- **Production**: `main` ou `master`
- **Preview**: Todas as outras branches e PRs

## 🛠️ Comandos Locais para Teste

### Testar Build Local
```bash
# Limpar e instalar dependências
flutter clean && flutter pub get

# Build otimizado (igual ao Vercel)
flutter build web --release --tree-shake-icons --source-maps --base-href /

# Servir localmente para teste
cd build/web && python -m http.server 8080
```

### Verificar Configuração
```bash
# Verificar versão Flutter
flutter --version

# Verificar dependências
flutter doctor

# Analisar código
flutter analyze
```

## 🔍 Verificações Pós-Deploy

### 1. Teste a Aplicação
- ✅ Carregamento inicial
- ✅ Navegação entre telas
- ✅ Funcionalidades do carrinho
- ✅ Responsividade (desktop/mobile)

### 2. Performance Checks
- ✅ Lighthouse Score
- ✅ Tempo de carregamento
- ✅ Tamanho do bundle
- ✅ Service Worker funcionando

### 3. URLs de Verificação
```
https://seu-projeto.vercel.app/              # Página inicial
https://seu-projeto.vercel.app/manifest.json  # PWA manifest
https://seu-projeto.vercel.app/favicon.png    # Favicon
```

## 🚨 Troubleshooting

### Problema: "Framework não detectado"
**Solução**: Verifique se os arquivos estão no root:
- `pubspec.yaml` ✅
- `package.json` ✅
- `.nvmrc` ✅
- `vercel.json` ✅

### Problema: "Build Command Failed"
**Solução**: Verifique Flutter SDK no ambiente:
```bash
# No terminal local, teste:
flutter build web --release
```

### Problema: "Assets não carregam"
**Solução**: Verifique `base-href` no build command:
```bash
flutter build web --release --base-href /
```

### Problema: "Routing não funciona"
**Solução**: Verifique rewrites no `vercel.json`:
```json
"rewrites": [
  {
    "source": "/(.*)",
    "destination": "/index.html"
  }
]
```

## ⚡ Otimizações Aplicadas

### Build Otimizado
- ✅ **Tree shaking** - Remove código não usado
- ✅ **Source maps** - Para debug em produção
- ✅ **Icon optimization** - Otimização de ícones
- ✅ **Release mode** - Performance máxima

### Configurações de Cache
- ✅ **Static assets** - Cache de 1 ano
- ✅ **HTML** - Cache de 1 hora
- ✅ **Service Worker** - Sem cache (sempre atualizado)

### Headers de Segurança
- ✅ **CSP** - Content Security Policy
- ✅ **XSS Protection** - Proteção contra XSS
- ✅ **HSTS** - HTTPS obrigatório
- ✅ **Permissions Policy** - Controle de permissões

## 📊 Monitoramento

### Vercel Analytics
- Ative o Vercel Analytics para métricas detalhadas
- Monitore Core Web Vitals
- Acompanhe tempos de carregamento

### Logs de Deploy
- Acesse logs em tempo real durante deploy
- Verifique erros de build
- Monitore uso de recursos

## 🎉 Conclusão

Com essas configurações, seu projeto Flutter Web está otimizado para:

1. ✅ **Auto-detecção** no Vercel
2. ✅ **Deploy automático** via GitHub
3. ✅ **Performance otimizada**
4. ✅ **Segurança** configurada
5. ✅ **Monitoramento** integrado

O deploy deve funcionar automaticamente ao fazer push para o GitHub!