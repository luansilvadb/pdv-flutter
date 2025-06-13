import type {ReactNode} from 'react';
import clsx from 'clsx';
import Heading from '@theme/Heading';
import FeatureCard from '@site/src/components/FeatureCard';
import Stats from '@site/src/components/Stats';
import TechStack from '@site/src/components/TechStack';
import styles from './styles.module.css';

type FeatureItem = {
  title: string;
  icon: string;
  description: ReactNode;
  badge?: string;
  badgeType?: 'primary' | 'secondary' | 'success' | 'warning';
};

const FeatureList: FeatureItem[] = [
  {
    title: 'Interface Moderna',
    icon: '🎨',
    badge: 'UI/UX',
    badgeType: 'primary',
    description: (
      <>
        Design baseado no <strong>Fluent UI</strong> com tema dark profissional, 
        proporcionando uma experiência visual moderna e intuitiva 
        para operadores de restaurantes com foco na usabilidade.
      </>
    ),
  },
  {
    title: 'Clean Architecture',
    icon: '🏗️',
    badge: 'Padrões',
    badgeType: 'secondary',
    description: (
      <>
        Arquitetura limpa e bem estruturada seguindo os princípios <strong>SOLID</strong>,
        garantindo código maintível, testável e escalável para 
        futuras funcionalidades e integrações.
      </>
    ),
  },
  {
    title: 'Multi-plataforma',
    icon: '📱',
    badge: 'Flutter',
    badgeType: 'success',
    description: (
      <>
        Desenvolvido com <strong>Flutter</strong>, funciona perfeitamente em Desktop, 
        Mobile e Web, oferecendo flexibilidade total para diferentes 
        ambientes de restaurante sem comprometer a performance.
      </>
    ),
  },
  {
    title: 'Performance Otimizada',
    icon: '⚡',
    badge: 'Velocidade',
    badgeType: 'warning',
    description: (
      <>
        Sistema otimizado para <strong>alta performance</strong> com cache inteligente,
        operações offline e sincronização automática, garantindo
        eficiência mesmo em ambientes com conectividade limitada.
      </>
    ),
  },
  {
    title: 'Segurança Avançada',
    icon: '🔒',
    badge: 'Seguro',
    badgeType: 'primary',
    description: (
      <>
        Implementação de <strong>criptografia</strong> de ponta a ponta,
        autenticação robusta e backup automático de dados,
        protegendo informações sensíveis do seu negócio.
      </>
    ),
  },
  {
    title: 'Relatórios Inteligentes',
    icon: '📊',
    badge: 'Analytics',
    badgeType: 'secondary',
    description: (
      <>
        Dashboard com <strong>analytics em tempo real</strong>, relatórios
        customizáveis e insights de vendas para tomada de
        decisões estratégicas baseadas em dados.
      </>
    ),
  },
];

const statsData = [
  {
    number: '10ms',
    label: 'Tempo de Resposta',
    icon: '⚡',
    description: 'Processamento ultrarrápido de pedidos'
  },
  {
    number: '99.9%',
    label: 'Uptime',
    icon: '🛡️',
    description: 'Disponibilidade garantida'
  },
  {
    number: '5 Seg',
    label: 'Setup',
    icon: '🚀',
    description: 'Configuração rápida e simples'
  },
  {
    number: '24/7',
    label: 'Suporte',
    icon: '💬',
    description: 'Suporte técnico sempre disponível'
  },
];

const techStack = [
  {
    name: 'Flutter',
    icon: '💙',
    description: 'Framework multiplataforma para desenvolvimento nativo',
    color: '#02569B',
    url: 'https://flutter.dev'
  },
  {
    name: 'Dart',
    icon: '🎯',
    description: 'Linguagem moderna, rápida e produtiva',
    color: '#0175C2',
    url: 'https://dart.dev'
  },
  {
    name: 'SQLite',
    icon: '🗄️',
    description: 'Banco de dados local robusto e confiável',
    color: '#003B57',
    url: 'https://sqlite.org'
  },
  {
    name: 'Provider',
    icon: '🔄',
    description: 'Gerenciamento de estado reativo',
    color: '#FF6B35'
  },
  {
    name: 'Hive',
    icon: '📦',
    description: 'Cache NoSQL ultrarrápido',
    color: '#FFA000'
  },
  {
    name: 'Clean Code',
    icon: '✨',
    description: 'Princípios SOLID e boas práticas',
    color: '#4CAF50'
  },
];

export default function HomepageFeatures(): ReactNode {
  return (
    <>
      <section className={styles.features}>
        <div className="container">
          <div className={clsx(styles.featuresHeader, 'animate-fade-in-up')}>
            <Heading as="h2" className={clsx(styles.featuresTitle, 'gradient-text')}>
              Principais Funcionalidades
            </Heading>
            <p className={styles.featuresSubtitle}>
              Descubra os recursos que tornam o PDV Restaurant a escolha ideal 
              para estabelecimentos que buscam excelência operacional
            </p>
          </div>
          
          <div className="row">
            {FeatureList.map((props, idx) => (
              <div key={idx} className="col col--4">
                <FeatureCard 
                  {...props} 
                  delay={idx * 100}
                />
              </div>
            ))}
          </div>
        </div>
      </section>

      <Stats stats={statsData} />
      
      <TechStack technologies={techStack} />
    </>
  );
}
