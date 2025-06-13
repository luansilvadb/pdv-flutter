import type {ReactNode} from 'react';
import clsx from 'clsx';
import styles from './styles.module.css';

interface FeatureCardProps {
  icon: string;
  title: string;
  description: ReactNode;
  badge?: string;
  badgeType?: 'primary' | 'secondary' | 'success' | 'warning';
  className?: string;
  delay?: number;
}

export default function FeatureCard({ 
  icon, 
  title, 
  description, 
  badge, 
  badgeType = 'primary',
  className,
  delay = 0
}: FeatureCardProps): ReactNode {
  return (
    <div 
      className={clsx(
        'card',
        'glassmorphism',
        'animate-fade-in-up',
        styles.featureCard,
        className
      )}
      style={{ animationDelay: `${delay}ms` }}
    >
      <div className={styles.cardHeader}>
        <div className={clsx(styles.iconContainer, 'animate-float')}>
          <span className={styles.icon}>{icon}</span>
        </div>
        {badge && (
          <span className={clsx('badge', `badge--${badgeType}`, styles.badge)}>
            {badge}
          </span>
        )}
      </div>
      
      <div className={styles.cardBody}>
        <h3 className={clsx(styles.title, 'gradient-text')}>{title}</h3>
        <p className={styles.description}>{description}</p>
      </div>
      
      <div className={styles.cardFooter}>
        <div className={styles.glow}></div>
      </div>
    </div>
  );
}
