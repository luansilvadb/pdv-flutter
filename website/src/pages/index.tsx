import type {ReactNode} from 'react';
import clsx from 'clsx';
import Link from '@docusaurus/Link';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import Layout from '@theme/Layout';
import HomepageFeatures from '@site/src/components/HomepageFeatures';
import Heading from '@theme/Heading';

import styles from './index.module.css';

function HomepageHeader() {
  const {siteConfig} = useDocusaurusContext();
  return (
    <header className={clsx('hero hero--primary', styles.heroBanner)}>
      <div className="container">
        <div className={clsx(styles.heroContent, 'animate-fade-in-up')}>
          <div className={styles.heroBadge}>
            <span className="badge badge--primary">✨ Versão 2.0 Disponível</span>
          </div>
          
          <Heading as="h1" className="hero__title">
            {siteConfig.title}
          </Heading>
          
          <p className="hero__subtitle">
            {siteConfig.tagline}
          </p>
          
          <p className={styles.heroDescription}>
            Transforme seu restaurante com nossa solução completa de ponto de venda. 
            Interface moderna, arquitetura robusta e performance excepcional em uma 
            única plataforma multiplataforma.
          </p>
          
          <div className={styles.buttons}>
            <Link
              className={clsx(
                "button button--secondary button--lg shine-effect",
                styles.getStartedButton
              )}
              to="/docs/intro">
              🚀 Começar Agora
            </Link>
            <Link
              className={clsx(
                "button button--outline button--lg",
                styles.githubButton
              )}
              to="https://github.com/luansilvadb/pdv-flutter">
              <span className={styles.githubIcon}>⭐</span>
              Ver no GitHub
            </Link>
          </div>
          
          <div className={styles.heroStats}>
            <div className={styles.statItem}>
              <span className={styles.statNumber}>10ms</span>
              <span className={styles.statLabel}>Resposta</span>
            </div>
            <div className={styles.statItem}>
              <span className={styles.statNumber}>99.9%</span>
              <span className={styles.statLabel}>Uptime</span>
            </div>
            <div className={styles.statItem}>
              <span className={styles.statNumber}>5 Seg</span>
              <span className={styles.statLabel}>Setup</span>
            </div>
          </div>
        </div>
      </div>
      
      <div className={styles.heroBackground}>
        <div className={styles.heroShape1}></div>
        <div className={styles.heroShape2}></div>
        <div className={styles.heroShape3}></div>
      </div>
    </header>
  );
}

function CallToAction(): ReactNode {
  return (
    <section className={styles.ctaSection}>
      <div className="container">
        <div className={clsx(styles.ctaContent, 'animate-fade-in-up')}>
          <h2 className={clsx(styles.ctaTitle, 'gradient-text')}>
            Pronto para Revolucionar seu Restaurante?
          </h2>
          <p className={styles.ctaDescription}>
            Junte-se a centenas de estabelecimentos que já transformaram 
            suas operações com o PDV Restaurant. Comece gratuitamente hoje mesmo!
          </p>
          <div className={styles.ctaButtons}>
            <Link
              className="button button--primary button--lg"
              to="/docs/getting-started">
              🎯 Guia de Instalação
            </Link>
            <Link
              className="button button--secondary button--lg"
              to="/docs/features">
              📚 Ver Funcionalidades
            </Link>
          </div>
        </div>
      </div>
    </section>
  );
}

export default function Home(): ReactNode {
  const {siteConfig} = useDocusaurusContext();
  return (
    <Layout
      title={`${siteConfig.title} - Sistema de PDV Moderno`}
      description="Sistema de Ponto de Venda moderno para restaurantes, desenvolvido com Flutter e Clean Architecture. Interface intuitiva, performance excepcional e recursos avançados.">
      <HomepageHeader />
      <main>
        <HomepageFeatures />
        <CallToAction />
      </main>
    </Layout>
  );
}
