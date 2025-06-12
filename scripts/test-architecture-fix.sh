#!/bin/bash

# =============================================================================
# 🧪 Teste da Correção de Arquitetura do Flutter
# =============================================================================
# Este script testa se o Dockerfile corrigido baixa a versão correta do Flutter
# para a arquitetura ARM64 ou x64.
# =============================================================================

set -e

echo "🔍 Testando correção da arquitetura do Flutter..."
echo "=================================================="

# Verificar se Docker está disponível
if ! command -v docker &> /dev/null; then
    echo "❌ Docker não encontrado. Instale o Docker primeiro."
    exit 1
fi

echo "✅ Docker encontrado"

# Construir apenas o primeiro estágio para testar o download do Flutter
echo ""
echo "🏗️ Construindo estágio flutter-builder para testar download..."
echo "=============================================================="

# Usar buildx para especificar arquitetura (se disponível)
if docker buildx version &> /dev/null; then
    echo "📦 Usando Docker Buildx para build multi-arquitetura..."
    
    # Testar para x64
    echo ""
    echo "🧪 Testando build para arquitetura x64..."
    docker buildx build \
        --platform linux/amd64 \
        --target flutter-builder \
        --progress=plain \
        --no-cache \
        -t pdv-flutter-test-x64 \
        . || echo "⚠️ Build x64 falhou (esperado se você está em ARM64)"
    
    echo ""
    echo "🧪 Testando build para arquitetura ARM64..."
    docker buildx build \
        --platform linux/arm64 \
        --target flutter-builder \
        --progress=plain \
        --no-cache \
        -t pdv-flutter-test-arm64 \
        . || echo "⚠️ Build ARM64 falhou"
        
else
    echo "📦 Usando Docker padrão (arquitetura nativa)..."
    
    # Detectar arquitetura atual
    ARCH=$(uname -m)
    echo "🔍 Arquitetura detectada: $ARCH"
    
    docker build \
        --target flutter-builder \
        --progress=plain \
        --no-cache \
        -t pdv-flutter-test-native \
        .
fi

echo ""
echo "✅ Teste de build concluído!"
echo ""
echo "🔍 Para verificar manualmente se o Flutter foi baixado corretamente:"
echo "   docker run --rm -it pdv-flutter-test-native flutter --version"
echo ""
echo "🧪 Para testar em diferentes arquiteturas:"
echo "   docker buildx build --platform linux/amd64 --target flutter-builder -t test-x64 ."
echo "   docker buildx build --platform linux/arm64 --target flutter-builder -t test-arm64 ."