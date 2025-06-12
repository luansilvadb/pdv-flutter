# =============================================================================
# 🐳 PDV Restaurant - Dockerfile MVP Simplificado
# =============================================================================
# Solução para problema ARM64 - Flutter 3.24.5 com suporte multi-arquitetura
# =============================================================================

# -----------------------------------------------------------------------------
# 🏗️ STAGE 1: Flutter Build Environment
# -----------------------------------------------------------------------------
FROM debian:bookworm-slim AS flutter-builder

# Versão do Flutter com suporte ARM64 confirmado
ENV FLUTTER_VERSION=3.24.5
ENV FLUTTER_HOME=/opt/flutter
ENV PATH="$FLUTTER_HOME/bin:$PATH"

# Instalar dependências básicas
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    unzip \
    xz-utils \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Download do Flutter com detecção automática de arquitetura
RUN ARCH=$(uname -m) && \
    echo "Arquitetura detectada: $ARCH" && \
    if [ "$ARCH" = "x86_64" ]; then \
        FLUTTER_ARCH=""; \
    elif [ "$ARCH" = "aarch64" ]; then \
        FLUTTER_ARCH="_arm64"; \
    else \
        echo "Arquitetura não suportada: $ARCH" && exit 1; \
    fi && \
    FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux${FLUTTER_ARCH}_${FLUTTER_VERSION}-stable.tar.xz" && \
    echo "Baixando Flutter de: $FLUTTER_URL" && \
    curl -fsSL "$FLUTTER_URL" | tar -xJ -C /opt/

# Configurar Flutter
RUN git config --global --add safe.directory /opt/flutter && \
    flutter config --no-analytics && \
    flutter config --enable-web && \
    flutter precache --web

# Configurar diretório de trabalho
WORKDIR /app

# Copiar pubspec.yaml primeiro (para cache do Docker)
COPY pubspec.yaml ./

# Instalar dependências
RUN flutter pub get

# Copiar código fonte
COPY . .

# Build da aplicação Flutter Web
RUN flutter build web \
    --release \
    --web-renderer=canvaskit \
    && echo "Build concluído com sucesso!"

# -----------------------------------------------------------------------------
# 🌐 STAGE 2: Nginx Production Server
# -----------------------------------------------------------------------------
FROM nginx:1.25-alpine AS production

# Copiar configuração do Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Copiar build do Flutter
COPY --from=flutter-builder /app/build/web /usr/share/nginx/html

# Health check básico
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/ || exit 1

# Expor porta
EXPOSE 8080

# Comando padrão
CMD ["nginx", "-g", "daemon off;"]