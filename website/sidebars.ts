import type {SidebarsConfig} from '@docusaurus/plugin-content-docs';

// This runs in Node.js - Don't use client-side code here (browser APIs, JSX...)

/**
 * Creating a sidebar enables you to:
 - create an ordered group of docs
 - render a sidebar for each doc of that group
 - provide next/previous navigation

 The sidebars can be generated from the filesystem, or explicitly defined here.

 Create as many sidebars as you want.
 */
const sidebars: SidebarsConfig = {
  // Sidebar principal da documentação
  tutorialSidebar: [
    'intro',
    {
      type: 'category',
      label: '🚀 Começando',
      collapsed: false,
      items: [
        'getting-started',
        {
          type: 'category',
          label: 'Instalação',
          items: [
            'installation/prerequisites',
            'installation/flutter-setup',
            'installation/project-setup',
            'installation/troubleshooting',
          ],
        },
        {
          type: 'category',
          label: 'Primeiros Passos',
          items: [
            'first-steps/running-app',
            'first-steps/understanding-structure',
            'first-steps/basic-usage',
          ],
        },
      ],
    },
    {
      type: 'category',
      label: '🏗️ Arquitetura',
      collapsed: false,
      items: [
        'architecture',
        {
          type: 'category',
          label: 'Clean Architecture',
          items: [
            'architecture/clean-architecture-overview',
            'architecture/domain-layer',
            'architecture/data-layer',
            'architecture/presentation-layer',
          ],
        },
      ],
    },
    {
      type: 'category',
      label: '✨ Funcionalidades',
      collapsed: false,
      items: [
        'features',
        {
          type: 'category',
          label: 'Interface do Usuário',
          items: [
            'features/ui/modern-interface',
          ],
        },
        {
          type: 'category',
          label: 'Catálogo de Produtos',
          items: [
            'features/products/product-catalog',
          ],
        },
      ],
    },
    {
      type: 'category',
      label: '🔧 Desenvolvimento',
      collapsed: true,
      items: [
        'api-reference',
      ],
    },
    {
      type: 'category',
      label: '📋 Referência',
      collapsed: true,
      items: [
        'changelog',
      ],
    },
    {
      type: 'category',
      label: '🎓 Tutoriais',
      collapsed: true,
      items: [
        'tutorial-basics/create-a-document',
        'tutorial-basics/create-a-page',
        'tutorial-basics/create-a-blog-post',
        'tutorial-basics/markdown-features',
        'tutorial-basics/deploy-your-site',
        'tutorial-basics/congratulations',
      ],
    },
  ],
};

export default sidebars;
