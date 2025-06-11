module.exports = {
  ci: {
    collect: {
      url: [
        'https://pdv-flutterr-okbg0yuqe-luandevuxs-projects.vercel.app/',
        'https://pdv-flutterr-okbg0yuqe-luandevuxs-projects.vercel.app/vendas',
        'https://pdv-flutterr-okbg0yuqe-luandevuxs-projects.vercel.app/produtos'
      ],
      numberOfRuns: 3,
      settings: {
        chromeFlags: '--no-sandbox --disable-dev-shm-usage --headless',
        preset: 'desktop',
        throttling: {
          rttMs: 40,
          throughputKbps: 10240,
          cpuSlowdownMultiplier: 1,
          requestLatencyMs: 0,
          downloadThroughputKbps: 0,
          uploadThroughputKbps: 0
        },
        screenEmulation: {
          mobile: false,
          width: 1350,
          height: 940,
          deviceScaleFactor: 1,
          disabled: false
        },
        formFactor: 'desktop'
      }
    },
    assert: {
      assertions: {
        'categories:performance': ['warn', { minScore: 0.8 }],
        'categories:accessibility': ['error', { minScore: 0.9 }],
        'categories:best-practices': ['warn', { minScore: 0.85 }],
        'categories:seo': ['warn', { minScore: 0.9 }],
        'categories:pwa': ['warn', { minScore: 0.8 }],
        
        // Core Web Vitals
        'first-contentful-paint': ['warn', { maxNumericValue: 2000 }],
        'largest-contentful-paint': ['warn', { maxNumericValue: 4000 }],
        'cumulative-layout-shift': ['warn', { maxNumericValue: 0.1 }],
        'total-blocking-time': ['warn', { maxNumericValue: 300 }],
        
        // Additional performance metrics
        'speed-index': ['warn', { maxNumericValue: 3000 }],
        'interactive': ['warn', { maxNumericValue: 5000 }],
        
        // PWA specific
        'installable-manifest': 'error',
        'service-worker': 'warn',
        'works-offline': 'warn',
        
        // Security & Best Practices
        'uses-https': 'error',
        'is-on-https': 'error',
        'uses-http2': 'warn',
        'uses-text-compression': 'warn',
        'uses-responsive-images': 'warn',
        'modern-image-formats': 'warn',
        'unused-css-rules': 'warn',
        'unused-javascript': 'warn',
        
        // Accessibility
        'color-contrast': 'error',
        'heading-order': 'warn',
        'html-has-lang': 'error',
        'image-alt': 'error',
        'link-name': 'error',
        
        // SEO
        'document-title': 'error',
        'meta-description': 'error',
        'viewport': 'error',
        'hreflang': 'warn'
      }
    },
    upload: {
      target: 'temporary-public-storage'
    },
    server: {
      port: 9090,
      storage: {
        storageMethod: 'sql',
        sqlDialect: 'sqlite',
        sqlConnectionSsl: false,
        sqlConnectionUrl: 'sqlite:lighthouse-ci.db'
      }
    }
  }
};