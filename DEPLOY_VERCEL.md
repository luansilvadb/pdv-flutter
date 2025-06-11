# 🚀 Deploy no Vercel - PDV Restaurant Flutter

Este documento contém as instruções completas para fazer deploy do sistema PDV Restaurant no Vercel.

## ✅ Pré-requisitos

- [Flutter SDK](https://flutter.dev/docs/get-started/install) >= 3.7.2
- [Node.js](https://nodejs.org/) >= 18.0.0
- Conta no [Vercel](https://vercel.com/)
- [Vercel CLI](https://vercel.com/cli) (opcional, mas recomendado)

## 📋 Verificação da Configuração

### 1. Suporte Web no Flutter
✅ O projeto já está configurado com suporte web através do Flutter SDK.

### 2. Dependências Web
✅ Todas as dependências são compatíveis com Flutter Web:
- `fluent_ui`: UI framework otimizado para web
- `riverpod`: State management compatível com web
- `go_router`: Navegação web-friendly
- `hive_flutter`: Storage local para web

### 3. Arquivos de Configuração
✅ Arquivos criados/otimizados:
- `vercel.json` - Configuração principal do Vercel
- `web/index.html` - HTML otimizado com SEO e performance
- `web/manifest.json` - PWA manifest atualizado
- `package.json` - Scripts de build e deploy
- `.vercelignore` - Exclusão de arquivos desnecessários

## 🔧 Configuração Local

### 1. Instalar dependências Flutter
```bash
flutter pub get
```

### 2. Instalar Vercel CLI (opcional)
```bash
npm install -g vercel
```

### 3. Testar build local
```bash
# Build otimizado para produção
npm run build

# Ou usando Flutter diretamente
flutter build web --release --no-tree-shake-icons --dart-define=WEB_RENDERER=canvaskit
```

### 4. Servir localmente (teste)
```bash
npm run serve
```

## 🚀 Deploy no Vercel

### Opção 1: Via GitHub (Recomendado)

1. **Conectar repositório ao Vercel:**
   - Acesse [vercel.com](https://vercel.com/)
   - Clique em "New Project"
   - Importe seu repositório GitHub

2. **Configuração automática:**
   - O Vercel detectará automaticamente as configurações do `vercel.json`
   - Build Command: `flutter build web --release --no-tree-shake-icons --dart-define=WEB_RENDERER=canvaskit`
   - Output Directory: `build/web`

3. **Deploy:**
   - Clique em "Deploy"
   - Aguarde o processo de build (5-10 minutos)

### Opção 2: Via CLI

1. **Login no Vercel:**
```bash
vercel login
```

2. **Deploy:**
```bash
# Deploy de teste
vercel

# Deploy para produção
vercel --prod
```

## ⚙️ Scripts Disponíveis

```bash
# Desenvolvimento
npm run dev              # Executar em modo desenvolvimento
npm run dev:html         # Desenvolvimento com HTML renderer

# Build
npm run build            # Build para produção (CanvasKit)
npm run build:vercel     # Build otimizado para Vercel
npm run build:html       # Build com HTML renderer

# Utilitários
npm run clean            # Limpar cache e reinstalar dependências
npm run analyze          # Análise estática do código
npm run test             # Executar testes
npm run format           # Formatar código
npm run lint             # Verificar linting

# Deploy
npm run deploy:vercel    # Deploy para produção
npm run preview          # Deploy de preview
```

## 🎯 Otimizações Implementadas

### Performance
- **CanvasKit Renderer**: Melhor performance para UIs complexas
- **Tree-shaking desabilitado**: Evita problemas com ícones
- **Preload de recursos**: Fontes e recursos críticos
- **Cache otimizado**: Headers de cache configurados

### SEO e Meta Tags
- **Open Graph**: Compartilhamento social otimizado
- **Twitter Cards**: Cartões do Twitter configurados
- **Viewport**: Responsividade otimizada
- **Descrições**: Meta descriptions relevantes

### PWA (Progressive Web App)
- **Manifest**: Configuração completa para PWA
- **Service Worker**: Cache automático pelo Flutter
- **Ícones**: Múltiplos tamanhos e formatos
- **Shortcuts**: Acesso rápido a funcionalidades

### Segurança
- **Headers de segurança**: XSS, clickjacking, etc.
- **HTTPS**: Forçado pelo Vercel
- **Content-Type**: Proteção contra MIME sniffing

## 🌐 URLs e Rotas

### Configuração SPA
O projeto está configurado como Single Page Application (SPA):
- Todas as rotas redirecionam para `/index.html`
- Navegação gerenciada pelo `go_router`
- URLs limpos sem `#` (hash routing)

### Rotas Principais
- `/` - Tela principal do PDV
- `/produtos` - Gestão de produtos
- `/vendas` - Histórico de vendas
- `/carrinho` - Carrinho de compras

## 🔍 Monitoramento e Logs

### Vercel Analytics
- Métricas de performance automáticas
- Core Web Vitals
- Logs de build e runtime

### Debugging
```bash
# Logs de build
vercel logs [deployment-url]

# Logs em tempo real
vercel logs --follow
```

## 🛠️ Solução de Problemas

### Build Falha
1. Verificar versão do Flutter (`flutter --version`)
2. Limpar cache: `npm run clean`
3. Verificar dependências no `pubspec.yaml`

### Performance Lenta
1. Usar CanvasKit renderer (padrão)
2. Verificar tamanho dos assets
3. Otimizar imagens na pasta `assets/`

### Rotas não Funcionam
1. Verificar configuração do `go_router`
2. Verificar `vercel.json` rewrites
3. Testar localmente com `npm run serve`

## 📝 Próximos Passos

Após o deploy:

1. **Configurar domínio personalizado** (opcional)
2. **Configurar variáveis de ambiente** para APIs
3. **Implementar CI/CD** com GitHub Actions
4. **Monitorar performance** com Vercel Analytics
5. **Configurar notificações** de deploy

## 🔗 Links Úteis

- [Documentação Flutter Web](https://flutter.dev/web)
- [Documentação Vercel](https://vercel.com/docs)
- [Flutter PWA Guide](https://flutter.dev/web/pwa)
- [Vercel CLI Reference](https://vercel.com/docs/cli)

---

**Desenvolvido com ❤️ pela equipe PDV Restaurant**