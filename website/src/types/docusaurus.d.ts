declare module '@docusaurus/Link' {
  import {ComponentType} from 'react';
  const Link: ComponentType<any>;
  export default Link;
}

declare module '@docusaurus/useDocusaurusContext' {
  const useDocusaurusContext: () => any;
  export default useDocusaurusContext;
}

declare module '@theme/Layout' {
  import {ComponentType} from 'react';
  const Layout: ComponentType<any>;
  export default Layout;
}

declare module '@theme/Heading' {
  import {ComponentType} from 'react';
  const Heading: ComponentType<any>;
  export default Heading;
}

declare module '@site/src/components/*' {
  import {ComponentType} from 'react';
  const Component: ComponentType<any>;
  export default Component;
}