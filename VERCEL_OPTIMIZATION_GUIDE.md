# 🚀 Guia de Otimização Vercel - PDV Restaurant

## ✅ Melhorias Implementadas

### 🎯 1. Configuração Vercel Otimizada (`vercel.json`)

**Headers de Cache Implementados:**
- **Recursos estáticos**: Cache de 1 ano (imutável)
- **HTML**: Cache de 1 hora com revalidação
- **Imagens**: Cache de 1 semana
- **Service Worker**: Sem cache (sempre atualizado)

**Headers de Segurança:**
- `X-Content-Type-Options: nosniff`
- `X-Frame-Options: DENY`
- `X-XSS-Protection: 1; mode=block`
- `Content-Security-Policy` configurado
- `Referrer-Policy: strict-origin-when-cross-origin`
- `Permissions-Policy` restritivo

**Otimizações:**
- `cleanUrls: true` - URLs sem extensão
- `trailingSlash: false` - URLs sem barra final
- Rewrite rules para SPA Flutter

### 🔧 2. Scripts de Build Otimizados

**Arquivos Criados:**
- [`scripts/build-optimized.sh`](scripts/build-optimized.sh) (Linux/Mac)
- [`scripts/build-optimized.bat`](scripts/build-optimized.bat) (Windows)

**Flags de Otimização Flutter:**
```bash
flutter build web \
  --release \
  --web-renderer canvaskit \
  --tree-shake-icons \
  --split-debug-info=build/web/debug_symbols \
  --source-maps \
  --dart-define=FLUTTER_WEB_CANVASKIT_URL=https://unpkg.com/canvaskit-wasm@latest/bin/
```

### 📱 3. PWA Melhorada

**`web/manifest.json` Aprimorado:**
- `display_override` para melhor experiência
- `shortcuts` para acesso rápido
- `share_target` para compartilhamento
- `file_handlers` para importação de dados
- `protocol_handlers` para integração sistema

**`web/index.html` Otimizado:**
- Meta tags SEO completas
- Open Graph e Twitter Cards
- JSON-LD structured data
- Preconnect para recursos críticos
- Loading screen melhorado com progress bar
- Performance timing e error handling

### 🤖 4. CI/CD Automático

**GitHub Actions (`.github/workflows/deploy-vercel.yml`):**
- **Test & Lint**: Formatação, análise e testes
- **Build**: Build otimizado com análise de bundle
- **Deploy Preview**: Para Pull Requests
- **Deploy Production**: Para branch main/master
- **Lighthouse Audit**: Análise de performance automática

### 📊 5. Monitoramento de Performance

**Lighthouse CI (`lighthouserc.js`):**
- Auditorias automáticas de performance
- Core Web Vitals monitoring
- Thresholds configurados para alertas
- Relatórios para múltiplas páginas

**Análise de Bundle (`scripts/analyze-bundle.js`):**
- Análise detalhada de tamanhos
- Identificação de arquivos grandes
- Recomendações automáticas
- Relatório JSON para tracking

### 📦 6. Package.json Atualizado

**Scripts Adicionados:**
```json
{
  "build:optimized": "Script multiplataforma de build",
  "build:analyze": "Build com análise de tamanho",
  "performance:audit": "Auditoria Lighthouse local",
  "analyze:bundle-size": "Análise detalhada do bundle",
  "serve:local": "Servidor local com CORS"
}
```

---

## 🛠️ Configurações Adicionais Recomendadas

### 1. Vercel Analytics (Opcional)

Para habilitar analytics avançado:

```bash
npm install @vercel/analytics
```

Adicionar no `web/index.html`:
```html
<script>
  window.va = window.va || function () { (window.vaq = window.vaq || []).push(arguments); };
</script>
<script defer src="/_vercel/insights/script.js"></script>
```

### 2. Domínio Personalizado

**Passos para configurar:**

1. **No painel Vercel:**
   - Vá em Settings → Domains
   - Adicione seu domínio personalizado
   - Configure DNS conforme instruções

2. **Configuração DNS:**
   ```
   CNAME: www.seudominio.com → cname.vercel-dns.com
   A: seudominio.com → 76.76.19.61
   ```

3. **SSL Automático:**
   - Vercel configura SSL automaticamente
   - Certificado Let's Encrypt renovado automaticamente

### 3. Variáveis de Ambiente

**Para produção, configure:**

```bash
# No painel Vercel ou via CLI
vercel env add NODE_ENV
vercel env add FLUTTER_WEB_CANVASKIT_URL
```

**Valores recomendados:**
```
NODE_ENV=production
FLUTTER_WEB_CANVASKIT_URL=https://unpkg.com/canvaskit-wasm@latest/bin/
```

### 4. Configuração Git para CI/CD

**Secrets necessários no GitHub:**

```bash
VERCEL_TOKEN=<seu_token_vercel>
VERCEL_ORG_ID=<id_da_organizacao>
VERCEL_PROJECT_ID=<id_do_projeto>
```

**Como obter:**
1. Vercel Token: Settings → Tokens
2. Org/Project ID: `vercel link` no projeto

---

## 📈 Métricas de Performance Esperadas

### Antes das Otimizações:
- **FCP**: ~3-4s
- **LCP**: ~5-6s
- **Bundle Size**: ~8-12MB
- **Lighthouse**: ~60-70

### Após Otimizações:
- **FCP**: ~1.5-2s (-40%)
- **LCP**: ~2.5-3s (-50%)
- **Bundle Size**: ~5-8MB (-30%)
- **Lighthouse**: ~85-95 (+25%)

---

## 🔍 Como Monitorar

### 1. Performance em Tempo Real

```bash
# Análise local
npm run performance:audit

# Análise de bundle
npm run analyze:bundle-size

# Build otimizado
npm run build:optimized
```

### 2. Vercel Analytics

- Acesse: vercel.com/[seu-projeto]/analytics
- Monitore: Page Views, Core Web Vitals, Top Pages

### 3. Lighthouse CI

- Relatórios automáticos a cada deploy
- Histórico de performance no GitHub Actions

---

## 🚨 Alertas e Thresholds

### Performance Budget:
- **FCP**: < 2s (crítico)
- **LCP**: < 4s (crítico)
- **CLS**: < 0.1 (crítico)
- **Bundle Total**: < 10MB
- **Lighthouse Performance**: > 80

### Ações se Limites Excedidos:
1. Verificar [`scripts/analyze-bundle.js`](scripts/analyze-bundle.js)
2. Otimizar imagens grandes (WebP)
3. Verificar tree-shaking
4. Implementar lazy loading

---

## 🎯 Próximos Passos

### Curto Prazo:
- [ ] Configurar domínio personalizado
- [ ] Habilitar Vercel Analytics
- [ ] Configurar secrets GitHub
- [ ] Testar CI/CD pipeline

### Médio Prazo:
- [ ] Implementar Service Worker customizado
- [ ] Adicionar cache estratégico
- [ ] Configurar notificações push
- [ ] Implementar background sync

### Longo Prazo:
- [ ] Edge Functions para APIs
- [ ] CDN otimizado para imagens
- [ ] A/B testing
- [ ] Real User Monitoring (RUM)

---

## 📞 Suporte e Troubleshooting

### Problemas Comuns:

**1. Build falhando:**
```bash
flutter clean
flutter pub get
npm run build:optimized
```

**2. Performance baixa:**
```bash
npm run analyze:bundle-size
# Verificar relatório em build/web/bundle-analysis.json
```

**3. CI/CD não funcionando:**
- Verificar secrets GitHub
- Confirmar permissões Vercel token
- Checar syntax do YAML

### Links Úteis:
- [Vercel Docs](https://vercel.com/docs)
- [Flutter Web Performance](https://docs.flutter.dev/perf/web-performance)
- [Lighthouse CI](https://github.com/GoogleChrome/lighthouse-ci)

---

**🎉 Deploy atual otimizado disponível em:**
https://pdv-flutterr-okbg0yuqe-luandevuxs-projects.vercel.app

**Performance Score atual:** 🎯 Esperado 85-95 pontos Lighthouse