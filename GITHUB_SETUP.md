# 🚀 Configuração GitHub Actions + Docker Hub

> **Guia completo para configurar CI/CD automático com GitHub Actions e Docker Hub**

## 📋 Pré-requisitos

1. ✅ Conta no [Docker Hub](https://hub.docker.com)
2. ✅ Repositório no GitHub
3. ✅ Token de acesso do Docker Hub

---

## 🐳 Configuração Docker Hub

### 1. Criar Repositório no Docker Hub

1. Acesse [hub.docker.com](https://hub.docker.com)
2. Clique em **"Create Repository"**
3. Configure:
   - **Repository Name**: `pdv-restaurant`
   - **Visibility**: Public ou Private
   - **Description**: Sistema PDV moderno para restaurantes

### 2. Gerar Token de Acesso

1. Vá em **Account Settings** → **Security**
2. Clique em **"New Access Token"**
3. Configure:
   - **Token Name**: `github-actions-pdv`
   - **Permissions**: Read, Write, Delete
4. **Copie o token** (você não verá novamente!)

---

## 🔧 Configuração GitHub

### 1. Configurar Secrets

No seu repositório GitHub:

1. Vá em **Settings** → **Secrets and variables** → **Actions**
2. Clique em **"New repository secret"**
3. Adicione os seguintes secrets:

```bash
DOCKER_USERNAME     # Seu username do Docker Hub
DOCKER_PASSWORD     # O token gerado acima
```

**Opcional** (para notificações):
```bash
SLACK_WEBHOOK_URL   # Webhook do Slack para notificações
```

### 2. Habilitar GitHub Actions

1. Vá em **Actions** no repositório
2. Se necessário, clique em **"I understand my workflows, go ahead and enable them"**

---

## 🚀 Testando o Pipeline

### 1. Primeiro Deploy

```bash
# Fazer commit e push para main
git add .
git commit -m "feat: configurar Docker + CI/CD"
git push origin main
```

### 2. Acompanhar Execução

1. Vá em **Actions** no GitHub
2. Clique no workflow **"🐳 Docker Build & Deploy"**
3. Acompanhe os logs em tempo real

### 3. Verificar no Docker Hub

1. Acesse seu repositório no Docker Hub
2. Verifique se a imagem foi criada com as tags:
   - `latest`
   - `main-{commit-hash}`

---

## 🏷️ Versionamento

### Tags Automáticas

O pipeline cria automaticamente:

```bash
latest              # Sempre da branch main
main-abc123         # Commit específico da main
v1.0.0              # Tags de release
v1.0                # Versão major.minor
v1                  # Versão major
```

### Criar Release

```bash
# Criar tag de versão
git tag v2.0.0
git push origin v2.0.0

# Ou via GitHub interface:
# Releases → Create new release → v2.0.0
```

---

## 🔍 Monitoramento

### 1. Logs do Pipeline

```yaml
# Ver logs no GitHub Actions
Actions → Workflow → Job → Step
```

### 2. Status da Build

O pipeline inclui:
- ✅ **Tests** - Testes Flutter
- ✅ **Build** - Multi-arch (AMD64/ARM64)
- ✅ **Security Scan** - Trivy scan
- ✅ **Push** - Para Docker Hub
- ✅ **Smoke Tests** - Testes básicos

### 3. Notificações

Configure Slack para receber notificações:

```bash
# No repositório GitHub, adicione:
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK
```

---

## 🛠️ Customização

### 1. Modificar Pipeline

Edite [`.github/workflows/docker-build.yml`](.github/workflows/docker-build.yml):

```yaml
# Alterar Flutter version
env:
  FLUTTER_VERSION: 3.24.5

# Alterar plataformas
- platforms: linux/amd64,linux/arm64

# Alterar branch de deploy
on:
  push:
    branches: [ main, develop ]  # Adicionar develop
```

### 2. Variáveis de Ambiente

Configure no GitHub Actions:

```yaml
# .github/workflows/docker-build.yml
env:
  REGISTRY: ghcr.io              # Usar GitHub Container Registry
  IMAGE_NAME: ${{ github.repository }}
```

### 3. Múltiplos Ambientes

```yaml
# Deploy para staging
- name: Deploy to Staging
  if: github.ref == 'refs/heads/develop'
  
# Deploy para produção
- name: Deploy to Production
  if: github.ref == 'refs/heads/main'
```

---

## 🔒 Segurança

### 1. Scan de Vulnerabilidades

O pipeline inclui automaticamente:

```yaml
- name: Run Trivy vulnerability scanner
  uses: aquasecurity/trivy-action@master
  with:
    image-ref: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ steps.meta.outputs.version }}
```

### 2. Assinatura de Imagens

```yaml
# Build com provenance e SBOM
- provenance: true
- sbom: true
```

### 3. Proteção de Secrets

- ✅ Secrets nunca aparecem nos logs
- ✅ Tokens com permissões mínimas
- ✅ Acesso apenas em branches protegidas

---

## 🎯 Troubleshooting

### Problemas Comuns

#### 1. Falha na Autenticação Docker Hub

```bash
Error: buildx failed with: ERROR: failed to solve: failed to push
```

**Solução:**
- Verificar `DOCKER_USERNAME` e `DOCKER_PASSWORD`
- Confirmar que o token tem permissões Write
- Verificar se o repositório existe no Docker Hub

#### 2. Falha no Build Flutter

```bash
Error: Flutter build failed
```

**Solução:**
- Verificar se `pubspec.yaml` está correto
- Confirmar versão do Flutter no pipeline
- Verificar logs detalhados no GitHub Actions

#### 3. Falha no Push Multi-Arch

```bash
Error: failed to push manifest
```

**Solução:**
- Verificar se Docker Hub suporta multi-arch
- Tentar build apenas AMD64 primeiro
- Verificar conectividade de rede

### Comandos de Debug

```bash
# Ver logs detalhados
docker buildx build --progress=plain

# Testar localmente
docker build -t test .
docker run -p 8080:8080 test

# Verificar imagem
docker inspect pdv-restaurant:latest
```

---

## 📈 Métricas

### Pipeline Performance

| Métrica | Valor Típico | Meta |
|---------|--------------|------|
| **Build Time** | 5-8 min | < 10 min |
| **Image Size** | ~20MB | < 50MB |
| **Test Coverage** | >80% | >90% |
| **Security Score** | A | A+ |

### Monitoramento

```bash
# Via GitHub API
curl -H "Authorization: token $GITHUB_TOKEN" \
  https://api.github.com/repos/USER/REPO/actions/runs

# Métricas Docker Hub
https://hub.docker.com/repository/docker/USER/pdv-restaurant/tags
```

---

## 🔄 Atualizações

### Manter Pipeline Atualizado

```bash
# Dependabot para Actions
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
```

### Versionamento de Actions

```yaml
# Usar versões específicas
uses: actions/checkout@v4
uses: docker/build-push-action@v5
uses: docker/setup-buildx-action@v3
```

---

## 🎉 Próximos Passos

Após configurar o CI/CD:

1. 📊 **Configurar monitoramento** com Grafana
2. 🚀 **Deploy automático** para Kubernetes
3. 🔍 **Testes de performance** automatizados
4. 📱 **Multi-platform testing** 
5. 🔐 **Enhanced security scanning**

---

## 📞 Suporte

Se precisar de ajuda:

1. 📖 **Documentação**: [GitHub Actions Docs](https://docs.github.com/en/actions)
2. 🐳 **Docker Hub**: [Docker Hub Docs](https://docs.docker.com/docker-hub/)
3. 💬 **Community**: [GitHub Discussions](https://github.com/discussions)

---

<div align="center">

**🚀 CI/CD configurado com sucesso!**

*Agora seus commits automaticamente geram novas imagens Docker*

[![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-Ready-green?logo=github-actions)](https://github.com)
[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-Ready-blue?logo=docker)](https://hub.docker.com)

</div>