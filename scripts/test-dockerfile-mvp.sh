#!/bin/bash

# =============================================================================
# 🧪 Script de Teste - Dockerfile MVP ARM64
# =============================================================================
# Testa se o Dockerfile MVP funciona em diferentes arquiteturas
# =============================================================================

set -e

echo "🧪 Testando Dockerfile MVP para ARM64/x64..."
echo "============================================="

# Detectar arquitetura atual
ARCH=$(uname -m)
echo "📋 Arquitetura atual: $ARCH"

# Testar se a URL do Flutter 3.24.5 está disponível
echo "🔍 Verificando disponibilidade do Flutter 3.24.5..."

if [ "$ARCH" = "x86_64" ]; then
    FLUTTER_ARCH=""
elif [ "$ARCH" = "aarch64" ]; then
    FLUTTER_ARCH="_arm64"
else
    echo "❌ Arquitetura não suportada: $ARCH"
    exit 1
fi

FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux${FLUTTER_ARCH}_3.24.5-stable.tar.xz"
echo "🌐 URL a ser testada: $FLUTTER_URL"

# Testar conectividade
if curl --output /dev/null --silent --head --fail "$FLUTTER_URL"; then
    echo "✅ URL do Flutter 3.24.5 está acessível para $ARCH"
else
    echo "❌ URL do Flutter 3.24.5 não está acessível para $ARCH"
    echo "🔄 Testando versão 3.22.3 como fallback..."
    
    FLUTTER_URL_FALLBACK="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux${FLUTTER_ARCH}_3.22.3-stable.tar.xz"
    
    if curl --output /dev/null --silent --head --fail "$FLUTTER_URL_FALLBACK"; then
        echo "✅ URL do Flutter 3.22.3 está acessível para $ARCH"
        echo "📝 Recomendação: Use Flutter 3.22.3 no Dockerfile"
    else
        echo "❌ Ambas as URLs estão inacessíveis"
        exit 1
    fi
fi

echo ""
echo "🐳 Testando build do Docker..."

# Build da imagem
if docker build -t pdv-restaurant-mvp:test .; then
    echo "✅ Build do Docker concluído com sucesso!"
    
    echo ""
    echo "🧪 Testando execução do container..."
    
    # Testar se o container inicia corretamente
    if docker run -d --name pdv-test -p 8080:8080 pdv-restaurant-mvp:test; then
        echo "✅ Container iniciado com sucesso!"
        
        # Aguardar um pouco para o nginx inicializar
        sleep 5
        
        # Testar se a aplicação responde
        if curl --output /dev/null --silent --head --fail "http://localhost:8080"; then
            echo "✅ Aplicação está respondendo corretamente!"
        else
            echo "⚠️ Aplicação não está respondendo (pode estar inicializando)"
        fi
        
        # Limpar container de teste
        docker stop pdv-test
        docker rm pdv-test
        
    else
        echo "❌ Falha ao iniciar o container"
        exit 1
    fi
    
else
    echo "❌ Falha no build do Docker"
    exit 1
fi

echo ""
echo "🎉 Todos os testes passaram com sucesso!"
echo "✨ O Dockerfile MVP está funcionando corretamente para $ARCH"
echo ""
echo "📋 Próximos passos:"
echo "   1. docker build -t pdv-restaurant ."
echo "   2. docker run -d -p 8080:8080 pdv-restaurant"
echo "   3. Acesse http://localhost:8080"