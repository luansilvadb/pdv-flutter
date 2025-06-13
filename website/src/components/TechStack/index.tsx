import type {ReactNode} from 'react';
import clsx from 'clsx';
import styles from './styles.module.css';

interface TechStackItem {
  name: string;
  icon: string;
  description: string;
  color: string;
  url?: string;
}

interface TechStackProps {
  title?: string;
  subtitle?: string;
  technologies: TechStackItem[];
  className?: string;
}

export default function TechStack({ 
  title = "Tecnologias Utilizadas",
  subtitle = "Stack moderna e robusta para máxima performance",
  technologies,
  className 
}: TechStackProps): ReactNode {
  return (
    <section className={clsx(styles.techSection, className)}>
      <div className="container">
        <div className={clsx(styles.header, 'animate-fade-in-up')}>
          <h2 className={clsx(styles.title, 'gradient-text')}>{title}</h2>
          <p className={styles.subtitle}>{subtitle}</p>
        </div>
        
        <div className={styles.techGrid}>
          {technologies.map((tech, index) => (
            <div 
              key={index}
              className={clsx(
                styles.techCard,
                'glassmorphism',
                'animate-fade-in-up'
              )}
              style={{ 
                animationDelay: `${index * 100}ms`,
                '--tech-color': tech.color
              } as React.CSSProperties}
            >
              {tech.url ? (
                <a 
                  href={tech.url} 
                  target="_blank" 
                  rel="noopener noreferrer"
                  className={styles.techLink}
                >
                  <TechCardContent tech={tech} />
                </a>
              ) : (
                <TechCardContent tech={tech} />
              )}
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}

function TechCardContent({ tech }: { tech: TechStackItem }): ReactNode {
  return (
    <>
      <div className={styles.techIcon}>
        <span>{tech.icon}</span>
      </div>
      <h3 className={styles.techName}>{tech.name}</h3>
      <p className={styles.techDescription}>{tech.description}</p>
      <div className={styles.techGlow}></div>
    </>
  );
}
