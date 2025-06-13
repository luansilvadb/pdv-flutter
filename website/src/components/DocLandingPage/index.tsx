import React from 'react';
import type {ReactElement} from 'react';
import clsx from 'clsx';
import Link from '@docusaurus/Link';
import styles from './styles.module.css';
import Heading from '@theme/Heading';

interface DocCategory {
  title: string;
  description: string;
  icon: string;
  color: string;
  link: string;
  items?: Array<{
    title: string;
    link: string;
  }>;
}

interface DocLandingPageProps {
  categories: DocCategory[];
  title?: string;
  description?: string;
}

export default function DocLandingPage({
  categories,
  title = 'Documentação',
  description = 'Explore nossa documentação completa para aproveitar ao máximo o PDV Restaurant',
}: DocLandingPageProps) {
  return (
    <div className={styles.docLanding}>
      <div className={styles.docHeader}>
        <Heading as="h1" className={styles.docTitle}>
          {title}
        </Heading>
        <p className={styles.docDescription}>{description}</p>
      </div>

      <div className={styles.categoryGrid}>
        {categories.map((category, idx) => (
          <div 
            key={idx} 
            className={clsx(styles.categoryCard, 'animate-fade-in-up')} 
            style={{ animationDelay: `${idx * 100}ms` }}
          >
            <Link to={category.link} className={styles.categoryLink}>
              <div 
                className={styles.iconWrapper} 
                style={{ backgroundColor: `${category.color}20`, color: category.color }}
              >
                <span className={styles.icon}>{category.icon}</span>
              </div>
              
              <Heading as="h3" className={styles.categoryTitle}>
                {category.title}
              </Heading>
              
              <p className={styles.categoryDescription}>
                {category.description}
              </p>
              
              {category.items && category.items.length > 0 && (
                <ul className={styles.subItems}>
                  {category.items.map((item, itemIdx) => (
                    <li key={itemIdx}>
                      <Link to={item.link}>
                        {item.title}
                      </Link>
                    </li>
                  ))}
                </ul>
              )}
              
              <div className={styles.learnMore}>
                <span>Explorar</span>
                <svg 
                  xmlns="http://www.w3.org/2000/svg" 
                  width="16" 
                  height="16" 
                  viewBox="0 0 24 24" 
                  fill="none" 
                  stroke="currentColor" 
                  strokeWidth="2" 
                  strokeLinecap="round" 
                  strokeLinejoin="round"
                >
                  <line x1="5" y1="12" x2="19" y2="12"></line>
                  <polyline points="12 5 19 12 12 19"></polyline>
                </svg>
              </div>
            </Link>
          </div>
        ))}
      </div>
    </div>
  );
}
