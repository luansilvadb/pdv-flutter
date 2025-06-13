# Website

This website is built using [Docusaurus](https://docusaurus.io/), a modern static website generator.

## Installation

```bash
npm install
```

## Local Development

```bash
npm start
```

This command starts a local development server and opens up a browser window. Most changes are reflected live without having to restart the server.

## Build

```bash
npm run build
```

This command generates static content into the `build` directory and can be served using any static contents hosting service.

## Deployment

The deployment is automated via GitHub Actions. When changes are pushed to the `main` branch in the `website/` directory, the documentation is automatically built and deployed to GitHub Pages.

Manual deployment (if needed):

```bash
npm run deploy
```

This command builds the website and pushes to the `gh-pages` branch.
