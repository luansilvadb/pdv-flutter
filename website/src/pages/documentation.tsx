import type {ReactNode} from 'react';
import clsx from 'clsx';
import Layout from '@theme/Layout';
import DocLandingPage from '@site/src/components/DocLandingPage';
import styles from './styles.module.css';

const docCategories = [
  {
    title: 'Começando',
    description: 'Tutoriais, instalação e primeiros passos para iniciar com o PDV Restaurant',
    icon: '🚀',
    color: '#FF6B35',
    link: '/docs/intro',
    items: [
      { title: 'Instalação', link: '/docs/getting-started' },
      { title: 'Primeiros Passos', link: '/docs/intro' },
      { title: 'Configuração Inicial', link: '/docs/intro#configuracao' }
    ]
  },
  {
    title: 'Arquitetura',
    description: 'Entenda a estrutura e os princípios arquiteturais do PDV Restaurant',
    icon: '🏗️',
    color: '#00D4FF',
    link: '/docs/architecture',
    items: [
      { title: 'Clean Architecture', link: '/docs/architecture#clean-arch' },
      { title: 'Camadas', link: '/docs/architecture#camadas' },
      { title: 'Diagramas', link: '/docs/architecture#diagramas' }
    ]
  },
  {
    title: 'Funcionalidades',
    description: 'Explore todas as funcionalidades e capacidades do sistema',
    icon: '✨',
    color: '#10B981',
    link: '/docs/features',
    items: [
      { title: 'Vendas', link: '/docs/features#vendas' },
      { title: 'Estoque', link: '/docs/features#estoque' },
      { title: 'Relatórios', link: '/docs/features#relatorios' }
    ]
  },
  {
    title: 'API Reference',
    description: 'Referência completa da API para desenvolvedores e integrações',
    icon: '📚',
    color: '#3B82F6',
    link: '/docs/api-reference',
    items: [
      { title: 'Endpoints', link: '/docs/api-reference#endpoints' },
      { title: 'Autenticação', link: '/docs/api-reference#auth' },
      { title: 'Exemplos', link: '/docs/api-reference#exemplos' }
    ]
  },
  {
    title: 'Performance',
    description: 'Otimizações e dicas para manter o sistema com performance máxima',
    icon: '⚡',
    color: '#F59E0B',
    link: '/docs/performance-optimization',
    items: [
      { title: 'Benchmarks', link: '/docs/performance-optimization#benchmarks' },
      { title: 'Otimizações', link: '/docs/performance-optimization#otimizacoes' },
      { title: 'Boas Práticas', link: '/docs/performance-optimization#praticas' }
    ]
  },
  {
    title: 'Changelog',
    description: 'Histórico de mudanças e novidades em cada versão do sistema',
    icon: '📋',
    color: '#8B5CF6',
    link: '/docs/changelog',
    items: [
      { title: 'Versão 2.0', link: '/docs/changelog#v2' },
      { title: 'Versão 1.5', link: '/docs/changelog#v1-5' },
      { title: 'Versão 1.0', link: '/docs/changelog#v1' }
    ]
  },
];

export default function Documentation(): ReactNode {
  return (
    <Layout
      title="Documentação"
      description="Explore a documentação completa do PDV Restaurant, com guias, tutoriais, referências de API e muito mais.">
      <main className={clsx(styles.docMain)}>
        <div className={styles.docHero}>
          <div className="container">
            <div className={styles.docHeroBadge}>
              <span className="badge badge--primary">Documentação Interativa</span>
            </div>
            <h1 className={styles.docHeroTitle}>Centro de Documentação</h1>
            <p className={styles.docHeroSubtitle}>
              Todo o conhecimento que você precisa para aproveitar ao máximo o PDV Restaurant
            </p>
            
            <div className={styles.searchContainer}>
              <div className={styles.searchWrapper}>
                <input
                  type="text"
                  className={styles.searchInput}
                  placeholder="Buscar na documentação..."
                  aria-label="Buscar na documentação"
                />
                <div className={styles.searchIcon}>
                  <svg
                    width="20"
                    height="20"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="currentColor"
                    strokeWidth="2"
                    strokeLinecap="round"
                    strokeLinejoin="round"
                  >
                    <circle cx="11" cy="11" r="8"></circle>
                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                  </svg>
                </div>
              </div>
              <p className={styles.searchHint}>
                Pressione <kbd>/</kbd> para pesquisar
              </p>
            </div>
          </div>
        </div>
        
        <div className="container">
          <DocLandingPage 
            categories={docCategories}
            title="Explore Nossa Documentação"
            description="Nossa documentação completa para ajudar você a entender e aproveitar ao máximo o PDV Restaurant."
          />
        </div>
      </main>
    </Layout>
  );
}
