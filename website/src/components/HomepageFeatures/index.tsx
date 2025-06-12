import type {ReactNode} from 'react';
import clsx from 'clsx';
import Heading from '@theme/Heading';
import styles from './styles.module.css';

type FeatureItem = {
  title: string;
  Svg: React.ComponentType<React.ComponentProps<'svg'>>;
  description: ReactNode;
};

const FeatureList: FeatureItem[] = [
  {
    title: '🎨 Interface Moderna',
    Svg: require('@site/static/img/undraw_docusaurus_mountain.svg').default,
    description: (
      <>
        Design baseado no Fluent UI com tema dark profissional, 
        proporcionando uma experiência visual moderna e intuitiva 
        para operadores de restaurantes.
      </>
    ),
  },
  {
    title: '🏗️ Clean Architecture',
    Svg: require('@site/static/img/undraw_docusaurus_tree.svg').default,
    description: (
      <>
        Arquitetura limpa e bem estruturada seguindo os princípios SOLID,
        garantindo código maintível, testável e escalável para 
        futuras funcionalidades.
      </>
    ),
  },
  {
    title: '📱 Multi-plataforma',
    Svg: require('@site/static/img/undraw_docusaurus_react.svg').default,
    description: (
      <>
        Desenvolvido com Flutter, funciona perfeitamente em Desktop, 
        Mobile e Web, oferecendo flexibilidade total para diferentes 
        ambientes de restaurante.
      </>
    ),
  },
];

function Feature({title, Svg, description}: FeatureItem) {
  return (
    <div className={clsx('col col--4')}>
      <div className="text--center">
        <Svg className={styles.featureSvg} role="img" />
      </div>
      <div className="text--center padding-horiz--md">
        <Heading as="h3">{title}</Heading>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures(): ReactNode {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
