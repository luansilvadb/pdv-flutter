# 🤝 Guia de Contribuição

Obrigado por considerar contribuir para o PDV Restaurant! Este documento fornece diretrizes para contribuir com o projeto.

## 📋 Índice

- [Código de Conduta](#código-de-conduta)
- [Como Contribuir](#como-contribuir)
- [Configuração do Ambiente](#configuração-do-ambiente)
- [Padrões de Código](#padrões-de-código)
- [Processo de Pull Request](#processo-de-pull-request)
- [Reportar Bugs](#reportar-bugs)
- [Sugerir Funcionalidades](#sugerir-funcionalidades)

## 📜 Código de Conduta

Este projeto adere ao [Código de Conduta do Contributor Covenant](https://www.contributor-covenant.org/). Ao participar, você deve seguir este código.

## 🚀 Como Contribuir

### 1. Fork do Projeto

```bash
# Clone seu fork
git clone https://github.com/SEU_USERNAME/pdv-flutter.git
cd pdv-flutter

# Adicione o repositório original como upstream
git remote add upstream https://github.com/luansilvadb/pdv-flutter.git
```

### 2. Crie uma Branch

```bash
# Crie uma branch para sua feature/fix
git checkout -b feature/nome-da-feature
# ou
git checkout -b fix/nome-do-bug
```

### 3. Faça suas Alterações

- Siga os [padrões de código](#padrões-de-código)
- Adicione testes para novas funcionalidades
- Mantenha a documentação atualizada

### 4. Commit suas Alterações

```bash
# Adicione os arquivos modificados
git add .

# Faça commit com mensagem descritiva
git commit -m "feat: adiciona nova funcionalidade X"
```

### 5. Push e Pull Request

```bash
# Envie para seu fork
git push origin feature/nome-da-feature

# Abra um Pull Request no GitHub
```

## ⚙️ Configuração do Ambiente

### Pré-requisitos

- Flutter SDK 3.7.2+
- Dart SDK 3.0+
- IDE (VS Code recomendado)

### Configuração

1. **Clone e configure**
   ```bash
   git clone https://github.com/luansilvadb/pdv-flutter.git
   cd pdv-flutter
   flutter pub get
   ```

2. **Execute os testes**
   ```bash
   flutter test
   ```

3. **Execute o projeto**
   ```bash
   flutter run
   ```

## 📝 Padrões de Código

### Estrutura de Arquivos

```
lib/
├── core/                   # Configurações centrais
├── features/              # Funcionalidades por domínio
│   └── feature_name/
│       ├── data/         # Repositórios e data sources
│       ├── domain/       # Entidades e use cases
│       └── presentation/ # UI e providers
├── shared/               # Código compartilhado
└── widgets/              # Componentes reutilizáveis
```

### Convenções de Nomenclatura

- **Arquivos**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variáveis/Funções**: `camelCase`
- **Constantes**: `UPPER_SNAKE_CASE`

### Padrões de Commit

Use [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` Nova funcionalidade
- `fix:` Correção de bug
- `docs:` Documentação
- `style:` Formatação
- `refactor:` Refatoração
- `test:` Testes
- `chore:` Tarefas de manutenção

Exemplos:
```
feat: adiciona carrinho de compras
fix: corrige cálculo de impostos
docs: atualiza README com instruções
```

### Testes

- **Testes Unitários**: Para lógica de negócio
- **Testes de Widget**: Para componentes UI
- **Testes de Integração**: Para fluxos completos

```bash
# Execute todos os testes
flutter test

# Testes com cobertura
flutter test --coverage
```

### Documentação

- Documente APIs públicas
- Use comentários para lógica complexa
- Mantenha README atualizado

## 🔄 Processo de Pull Request

### Checklist

Antes de abrir um PR, verifique:

- [ ] Código segue os padrões estabelecidos
- [ ] Testes passam (`flutter test`)
- [ ] Cobertura de testes mantida/melhorada
- [ ] Documentação atualizada
- [ ] Commit messages seguem convenção
- [ ] Branch está atualizada com main

### Template de PR

```markdown
## Descrição
Breve descrição das mudanças

## Tipo de Mudança
- [ ] Bug fix
- [ ] Nova funcionalidade
- [ ] Breaking change
- [ ] Documentação

## Como Testar
1. Passos para testar
2. Cenários de teste
3. Resultados esperados

## Screenshots (se aplicável)
Adicione screenshots das mudanças visuais

## Checklist
- [ ] Testes passam
- [ ] Documentação atualizada
- [ ] Código revisado
```

## 🐛 Reportar Bugs

### Antes de Reportar

1. Verifique se o bug já foi reportado
2. Teste na versão mais recente
3. Colete informações do ambiente

### Template de Bug Report

```markdown
**Descrição do Bug**
Descrição clara e concisa do problema

**Passos para Reproduzir**
1. Vá para '...'
2. Clique em '...'
3. Veja o erro

**Comportamento Esperado**
O que deveria acontecer

**Screenshots**
Se aplicável, adicione screenshots

**Ambiente:**
- OS: [e.g. Windows 10]
- Flutter: [e.g. 3.7.2]
- Versão do App: [e.g. 2.0.0]

**Informações Adicionais**
Qualquer contexto adicional
```

## 💡 Sugerir Funcionalidades

### Template de Feature Request

```markdown
**Problema Relacionado**
Descrição do problema que esta feature resolveria

**Solução Proposta**
Descrição clara da solução desejada

**Alternativas Consideradas**
Outras soluções que você considerou

**Informações Adicionais**
Contexto adicional, screenshots, etc.
```

## 🏷️ Labels

Usamos labels para categorizar issues e PRs:

- `bug` - Bugs reportados
- `enhancement` - Melhorias
- `feature` - Novas funcionalidades
- `documentation` - Documentação
- `good first issue` - Bom para iniciantes
- `help wanted` - Precisa de ajuda
- `priority: high` - Alta prioridade

## 🎯 Áreas de Contribuição

### Frontend (Flutter)
- Componentes UI
- Telas e navegação
- Animações e transições
- Responsividade

### Backend/Data
- Repositórios
- Data sources
- Storage local
- APIs (futuro)

### Testes
- Testes unitários
- Testes de widget
- Testes de integração
- Mocks e fixtures

### Documentação
- README e guias
- Comentários de código
- Documentação de API
- Tutoriais

## 📞 Suporte

Precisa de ajuda? Entre em contato:

- **Issues**: [GitHub Issues](https://github.com/luansilvadb/pdv-flutter/issues)
- **Discussões**: [GitHub Discussions](https://github.com/luansilvadb/pdv-flutter/discussions)
- **Email**: support@pdv-restaurant.com

## 🙏 Reconhecimento

Todos os contribuidores serão reconhecidos no README do projeto. Obrigado por ajudar a tornar o PDV Restaurant melhor!

---

*Este guia é baseado nas melhores práticas da comunidade open source.*