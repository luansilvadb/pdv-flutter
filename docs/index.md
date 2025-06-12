---
layout: default
title: Home
nav_order: 1
description: "PDV Restaurant - Sistema de Ponto de Venda Moderno para Restaurantes"
permalink: /
---

# PDV Restaurant
{: .fs-9 }

Sistema de Ponto de Venda Moderno para Restaurantes
{: .fs-6 .fw-300 }

[Começar agora](getting-started){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 .mr-2 }
[Ver no GitHub](https://github.com/{{ site.github_repo }}){: .btn .fs-5 .mb-4 .mb-md-0 }

---

## 🎯 Sobre o Projeto

O **PDV Restaurant** é um sistema de ponto de venda moderno e intuitivo, desenvolvido especificamente para restaurantes que buscam eficiência e uma experiência de usuário excepcional. Construído com Flutter e seguindo os princípios da Clean Architecture, oferece uma solução robusta, escalável e multiplataforma.

### ✨ Principais Características

- 🎨 **Interface Moderna**: Design baseado no Fluent UI com tema dark profissional
- 🏗️ **Arquitetura Limpa**: Implementação seguindo Clean Architecture principles
- 📱 **Multi-plataforma**: Funciona em Desktop, Mobile e Web
- ⚡ **Performance**: Otimizado para uso em ambiente de alta demanda
- 🔄 **Estado Reativo**: Gerenciamento de estado com Riverpod
- 💾 **Persistência Local**: Armazenamento offline com Hive

---

## 🚀 Versões

<div class="version-grid">
{% for version in site.versions %}
  <div class="version-card version-{{ version.status }}">
    <h3>{{ version.version }}</h3>
    <span class="version-status">{{ version.status | capitalize }}</span>
    <p class="version-description">{{ version.description }}</p>
    <p class="version-date">📅 {{ version.release_date }}</p>
    
    <div class="version-features">
      <h4>Funcionalidades:</h4>
      <ul>
        {% for feature in version.features %}
          <li>{{ feature }}</li>
        {% endfor %}
      </ul>
    </div>
    
    {% if version.status == 'stable' %}
      <a href="/versions/{{ version.version | replace: '.', '-' }}" class="btn btn-primary">Ver Documentação</a>
    {% elsif version.status == 'development' %}
      <a href="/versions/{{ version.version | replace: '.', '-' }}" class="btn btn-outline">Em Desenvolvimento</a>
    {% else %}
      <span class="btn btn-disabled">Planejado</span>
    {% endif %}
  </div>
{% endfor %}
</div>

---

## 📋 Funcionalidades Principais

### 🏠 Interface Principal
- Sidebar moderna com navegação intuitiva
- Design responsivo para diferentes tamanhos de tela
- Tema dark profissional baseado no Fluent UI
- Animações suaves e feedback visual

### 🛍️ Catálogo de Produtos
- Organização por categorias (Hambúrguers, Pizzas, Bebidas)
- Cards visuais com imagens, descrições e preços
- Sistema de busca em tempo real
- Controle de disponibilidade e estoque
- Filtros por categoria

### 🛒 Carrinho de Compras
- Adição/remoção de produtos com um clique
- Controle de quantidade por item
- Cálculo automático de subtotal e impostos
- Interface lateral dedicada e sempre visível
- Persistência local dos dados

---

## 🏗️ Arquitetura

O projeto segue os princípios da **Clean Architecture**, garantindo separação de responsabilidades e facilidade de manutenção.

```
lib/
├── 📁 core/                    # Configurações centrais
├── 📁 features/               # Módulos de funcionalidades
│   ├── 📁 products/           # Gestão de produtos
│   ├── 📁 cart/               # Carrinho de compras
│   └── 📁 navigation/         # Sistema de navegação
├── 📁 shared/                 # Código compartilhado
└── 📁 widgets/                # Componentes reutilizáveis
```

[Saiba mais sobre a arquitetura](architecture){: .btn .btn-outline }

---

## 🛠️ Stack Tecnológico

| Categoria | Tecnologia | Versão | Propósito |
|-----------|------------|--------|-----------|
| **Framework** | Flutter | 3.7.2+ | Desenvolvimento multiplataforma |
| **UI Library** | Fluent UI | 4.8.6 | Design system moderno |
| **State Management** | Riverpod | 2.4.9 | Gerenciamento de estado reativo |
| **Dependency Injection** | GetIt | 7.6.4 | Injeção de dependências |
| **Local Storage** | Hive | 2.2.3 | Persistência de dados local |

---

## 🚀 Começar Rapidamente

### 1. Pré-requisitos
- Flutter SDK 3.7.2+
- Dart SDK 3.0+
- IDE (VS Code recomendado)

### 2. Instalação
```bash
git clone https://github.com/{{ site.github_repo }}.git
cd pdv-flutter
flutter pub get
flutter run
```

[Guia completo de instalação](getting-started){: .btn .btn-primary }

---

## 📖 Documentação

<div class="doc-grid">
  <div class="doc-card">
    <h3>🚀 Começando</h3>
    <p>Guia de instalação e configuração inicial</p>
    <a href="getting-started">Ler mais →</a>
  </div>
  
  <div class="doc-card">
    <h3>🏗️ Arquitetura</h3>
    <p>Entenda a estrutura e padrões do projeto</p>
    <a href="architecture">Ler mais →</a>
  </div>
  
  <div class="doc-card">
    <h3>✨ Funcionalidades</h3>
    <p>Explore todas as funcionalidades disponíveis</p>
    <a href="features">Ler mais →</a>
  </div>
  
  <div class="doc-card">
    <h3>📚 Guias</h3>
    <p>Tutoriais e guias práticos</p>
    <a href="guides">Ler mais →</a>
  </div>
</div>

---

## 🤝 Contribuição

Contribuições são sempre bem-vindas! Veja nosso [guia de contribuição](https://github.com/{{ site.github_repo }}/blob/main/docs/CONTRIBUTING.md) para começar.

### Como Contribuir
1. Fork o projeto
2. Crie uma branch para sua feature
3. Commit suas mudanças
4. Abra um Pull Request

[Guia de Contribuição](https://github.com/{{ site.github_repo }}/blob/main/docs/CONTRIBUTING.md){: .btn .btn-outline }

---

## 📞 Suporte

Precisa de ajuda? Entre em contato:

- 🐛 [Issues no GitHub](https://github.com/{{ site.github_repo }}/issues)
- 💬 [Discussões](https://github.com/{{ site.github_repo }}/discussions)
- 📧 Email: support@pdv-restaurant.com

---

<style>
.version-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 1.5rem;
  margin: 2rem 0;
}

.version-card {
  border: 1px solid #e1e4e8;
  border-radius: 8px;
  padding: 1.5rem;
  background: #f6f8fa;
}

.version-stable {
  border-color: #28a745;
  background: #f0fff4;
}

.version-development {
  border-color: #ffc107;
  background: #fffbf0;
}

.version-planned {
  border-color: #6c757d;
  background: #f8f9fa;
}

.version-status {
  display: inline-block;
  padding: 0.25rem 0.5rem;
  border-radius: 4px;
  font-size: 0.75rem;
  font-weight: bold;
  text-transform: uppercase;
}

.version-stable .version-status {
  background: #28a745;
  color: white;
}

.version-development .version-status {
  background: #ffc107;
  color: #212529;
}

.version-planned .version-status {
  background: #6c757d;
  color: white;
}

.doc-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1rem;
  margin: 2rem 0;
}

.doc-card {
  border: 1px solid #e1e4e8;
  border-radius: 8px;
  padding: 1.5rem;
  background: #fff;
  transition: transform 0.2s;
}

.doc-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0,0,0,0.1);
}

.doc-card h3 {
  margin-top: 0;
  color: #0366d6;
}

.doc-card a {
  color: #0366d6;
  text-decoration: none;
  font-weight: 500;
}

.doc-card a:hover {
  text-decoration: underline;
}
</style>