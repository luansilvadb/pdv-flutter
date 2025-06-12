#!/bin/bash

# =============================================================================
# 🧪 Script de Teste - Correção Git Safe Directory
# =============================================================================
# Descrição: Testa se a correção do erro "dubious ownership" foi aplicada
# Autor: PDV Restaurant Team
# =============================================================================

set -e

echo "🧪 Testando correção Git 'dubious ownership'..."
echo "=================================================="

# Verificar se o Docker está disponível
if ! command -v docker &> /dev/null; then
    echo "❌ Docker não encontrado. Instale o Docker primeiro."
    exit 1
fi

echo "📋 Informações do teste:"
echo "- Testando correção do erro Git 'dubious ownership'"
echo "- Verificando se flutter commands executam sem erro"
echo "- Comando a ser testado: git config --global --add safe.directory /opt/flutter"
echo ""

# Construir apenas o stage do Flutter para testar
echo "🔨 Construindo stage Flutter para teste..."
docker build \
    --target flutter-builder \
    --tag pdv-flutter-test:latest \
    --file Dockerfile \
    .

echo ""
echo "✅ Build do stage Flutter concluído!"
echo ""

# Testar se o comando git config foi aplicado
echo "🔍 Verificando configuração Git safe.directory..."
docker run --rm pdv-flutter-test:latest \
    git config --global --get-regexp safe.directory

echo ""

# Testar comandos Flutter básicos
echo "🔧 Testando comandos Flutter..."
docker run --rm pdv-flutter-test:latest \
    sh -c "flutter --version && flutter doctor --version && echo '✅ Flutter commands executaram sem erros!'"

echo ""
echo "🎉 Teste concluído com sucesso!"
echo "✅ A correção do erro Git 'dubious ownership' foi aplicada corretamente"
echo "✅ Comandos Flutter executam sem problemas de permissão"
echo ""
echo "🧹 Para limpar a imagem de teste:"
echo "docker rmi pdv-flutter-test:latest"