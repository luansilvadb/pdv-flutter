# PDV Restaurant - Documentação

Este diretório contém a documentação oficial do PDV Restaurant, hospedada no GitHub Pages.

## 🌐 Site da Documentação

A documentação está disponível em: **https://luansilvadb.github.io/pdv-flutter**

## 📁 Estrutura

```
docs/
├── _config.yml              # Configuração do Jekyll
├── _layouts/                # Templates do Jekyll
├── _includes/               # Componentes reutilizáveis
├── _versions/               # Documentação por versão
├── _guides/                 # Guias e tutoriais
├── assets/                  # CSS, JS e imagens
├── index.md                 # Página inicial
├── getting-started.md       # Guia de instalação
├── architecture.md          # Arquitetura do projeto
├── features.md              # Funcionalidades
├── changelog.md             # Histórico de versões
└── Gemfile                  # Dependências Ruby/Jekyll
```

## 🚀 Executar Localmente

### Pré-requisitos
- Ruby 3.1+
- Bundler

### Instalação
```bash
cd docs
bundle install
```

### Executar
```bash
bundle exec jekyll serve
```

A documentação estará disponível em `http://localhost:4000/pdv-flutter`

## 📝 Contribuindo

Para contribuir com a documentação:

1. Edite os arquivos Markdown em `docs/`
2. Teste localmente com Jekyll
3. Faça commit das mudanças
4. O GitHub Actions fará o deploy automaticamente

## 🔧 Tecnologias

- **Jekyll** - Gerador de sites estáticos
- **GitHub Pages** - Hospedagem
- **Markdown** - Formato dos documentos
- **Liquid** - Template engine
- **SCSS** - Estilos customizados

## 📞 Suporte

Para problemas com a documentação:
- [Issues do GitHub](https://github.com/luansilvadb/pdv-flutter/issues)
- Email: support@pdv-restaurant.com