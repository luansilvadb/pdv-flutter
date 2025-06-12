# =============================================================================
# 🐳 PDV Restaurant - Dockerfile Multi-stage Profissional
# =============================================================================
# Autor: PDV Restaurant Team
# Descrição: Build otimizado para Flutter Web com Nginx
# Arquitetura: Multi-stage para produção (~20MB final)
# =============================================================================

# -----------------------------------------------------------------------------
# 🏗️ STAGE 1: Flutter Build Environment
# -----------------------------------------------------------------------------
FROM debian:bookworm-slim AS flutter-builder

# Metadados da imagem
LABEL maintainer="PDV Restaurant Team"
LABEL description="Flutter Web build environment"
LABEL version="2.0.0"

# Definir variáveis de ambiente para Flutter
ENV FLUTTER_VERSION=3.32.3
ENV FLUTTER_HOME=/opt/flutter
ENV PATH="$FLUTTER_HOME/bin:$PATH"
ENV PUB_CACHE=/opt/flutter/.pub-cache
ENV FLUTTER_ROOT=$FLUTTER_HOME

# Argumentos de build configuráveis
ARG FLUTTER_WEB_RENDERER=canvaskit
ARG BUILD_MODE=release
ARG BASE_HREF=/

# Instalar dependências do sistema (cache-friendly layer)
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    unzip \
    ca-certificates \
    fonts-liberation \
    libglu1-mesa \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Download e instalação do Flutter (versão específica)
RUN curl -fsSL https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz \
    | tar -xJ -C /opt/ \
    && flutter config --no-analytics \
    && flutter config --enable-web \
    && flutter precache --web \
    && flutter doctor -v

# Configurar diretório de trabalho
WORKDIR /app

# Copiar arquivos de configuração primeiro (para cache do Docker)
COPY pubspec.yaml pubspec.lock ./

# Instalar dependências Flutter (layer cached)
RUN flutter pub get

# Copiar código fonte
COPY . .

# Verificar estrutura do projeto
RUN ls -la && \
    echo "Flutter doctor:" && flutter doctor && \
    echo "Flutter devices:" && flutter devices

# Build otimizado para produção
RUN flutter build web \
    --release \
    --web-renderer=$FLUTTER_WEB_RENDERER \
    --base-href=$BASE_HREF \
    --dart-define=FLUTTER_WEB_USE_SKIA=true \
    --dart-define=FLUTTER_WEB_AUTO_DETECT=true \
    --no-tree-shake-icons \
    --source-maps \
    && echo "Build completed successfully!" \
    && ls -la build/web/

# -----------------------------------------------------------------------------
# 🌐 STAGE 2: Nginx Production Server
# -----------------------------------------------------------------------------
FROM nginx:1.25-alpine AS production

# Metadados da imagem final
LABEL maintainer="PDV Restaurant Team"
LABEL description="PDV Restaurant - Flutter Web Application"
LABEL version="2.0.0"
LABEL app.name="pdv-restaurant"
LABEL app.version="2.0.0"
LABEL app.component="frontend"

# Instalar dependências extras (security & performance)
RUN apk add --no-cache \
    ca-certificates \
    tzdata \
    tini \
    && rm -rf /var/cache/apk/*

# Configurar timezone
ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Criar usuário não-root para segurança
RUN addgroup -g 1001 -S appgroup && \
    adduser -S -D -H -u 1001 -h /var/cache/nginx -s /sbin/nologin -G appgroup -g appgroup appuser

# Copiar configuração customizada do Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Copiar build do Flutter do stage anterior
COPY --from=flutter-builder /app/build/web /usr/share/nginx/html

# Definir permissões corretas
RUN chown -R appuser:appgroup /usr/share/nginx/html \
    && chown -R appuser:appgroup /var/cache/nginx \
    && chown -R appuser:appgroup /var/log/nginx \
    && chown -R appuser:appgroup /etc/nginx/conf.d \
    && touch /var/run/nginx.pid \
    && chown -R appuser:appgroup /var/run/nginx.pid

# Criar diretórios necessários para nginx não-root
RUN mkdir -p /var/cache/nginx/client_temp \
    /var/cache/nginx/proxy_temp \
    /var/cache/nginx/fastcgi_temp \
    /var/cache/nginx/uwsgi_temp \
    /var/cache/nginx/scgi_temp \
    && chown -R appuser:appgroup /var/cache/nginx

# Variáveis de ambiente para runtime
ENV NGINX_WORKER_PROCESSES=auto
ENV NGINX_WORKER_CONNECTIONS=1024
ENV NGINX_KEEPALIVE_TIMEOUT=65
ENV NGINX_CLIENT_MAX_BODY_SIZE=10m

# Health check configurado
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1

# Expor porta não-privilegiada
EXPOSE 8080

# Mudar para usuário não-root
USER appuser

# Usar tini como init system para melhor signal handling
ENTRYPOINT ["/sbin/tini", "--"]

# Comando padrão
CMD ["nginx", "-g", "daemon off;"]

# -----------------------------------------------------------------------------
# 🏷️ Build Info & Security Labels
# -----------------------------------------------------------------------------
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.opencontainers.image.created=$BUILD_DATE
LABEL org.opencontainers.image.version=$VERSION
LABEL org.opencontainers.image.revision=$VCS_REF
LABEL org.opencontainers.image.title="PDV Restaurant"
LABEL org.opencontainers.image.description="Sistema PDV moderno para restaurantes"
LABEL org.opencontainers.image.vendor="PDV Restaurant Team"
LABEL org.opencontainers.image.source="https://github.com/username/pdv-restaurant"
LABEL org.opencontainers.image.documentation="https://github.com/username/pdv-restaurant/blob/main/DOCKER_README.md"
LABEL org.opencontainers.image.licenses="MIT"