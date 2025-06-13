import type {ReactNode} from 'react';
import clsx from 'clsx';
import styles from './styles.module.css';

interface StatsData {
  number: string;
  label: string;
  icon: string;
  description?: string;
}

interface StatsProps {
  title?: string;
  subtitle?: string;
  stats: StatsData[];
  className?: string;
}

export default function Stats({ 
  title = "PDV Restaurant em Números",
  subtitle = "Dados que demonstram a eficiência do nosso sistema",
  stats,
  className 
}: StatsProps): ReactNode {
  return (
    <section className={clsx(styles.statsSection, className)}>
      <div className="container">
        <div className={clsx(styles.header, 'animate-fade-in-up')}>
          <h2 className={styles.title}>{title}</h2>
          <p className={styles.subtitle}>{subtitle}</p>
        </div>
        
        <div className="row">
          {stats.map((stat, index) => (
            <div key={index} className="col col--3">
              <div 
                className={clsx(
                  styles.statCard,
                  'glassmorphism',
                  'animate-fade-in-up'
                )}
                style={{ animationDelay: `${index * 100}ms` }}
              >
                <div className={styles.statIcon}>
                  <span>{stat.icon}</span>
                </div>
                <div className={clsx(styles.statNumber, 'gradient-text')}>
                  {stat.number}
                </div>
                <div className={styles.statLabel}>{stat.label}</div>
                {stat.description && (
                  <div className={styles.statDescription}>
                    {stat.description}
                  </div>
                )}
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
