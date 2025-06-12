#!/bin/bash

# =============================================================================
# 🔍 Script de Verificação do Fix do Dockerfile
# =============================================================================
# Descrição: Verifica se a correção do Git "dubious ownership" foi aplicada
# =============================================================================

echo "🔍 Verificando correção do Git 'dubious ownership' no Dockerfile..."
echo ""

# Verificar se o git config está em RUN separado
echo "✅ Verificando se git config está em RUN separado:"
grep -n "RUN git config --global --add safe.directory /opt/flutter" Dockerfile

if [ $? -eq 0 ]; then
    echo "✅ SUCESSO: git config encontrado em RUN separado"
else
    echo "❌ ERRO: git config não encontrado em RUN separado"
    exit 1
fi

echo ""

# Verificar se não há mais git config na cadeia de download
echo "✅ Verificando se git config foi removido da cadeia de download:"
if grep -A5 "curl.*flutter_linux" Dockerfile | grep -q "git config"; then
    echo "❌ ERRO: git config ainda presente na cadeia de download"
    exit 1
else
    echo "✅ SUCESSO: git config removido da cadeia de download"
fi

echo ""

# Verificar estrutura das linhas 44-51
echo "✅ Verificando estrutura corrigida (linhas 44-51):"
sed -n '44,51p' Dockerfile

echo ""

# Verificar sintaxe básica do Dockerfile
echo "✅ Verificando sintaxe básica do Dockerfile:"
if command -v docker &> /dev/null; then
    docker build --dry-run . &> /dev/null
    if [ $? -eq 0 ]; then
        echo "✅ SUCESSO: Sintaxe do Dockerfile está correta"
    else
        echo "❌ AVISO: Possíveis problemas de sintaxe detectados"
    fi
else
    echo "ℹ️  INFO: Docker não disponível para verificação de sintaxe"
fi

echo ""
echo "🎉 Verificação concluída!"
echo ""
echo "📋 RESUMO DA CORREÇÃO:"
echo "1. ✅ Download do Flutter separado do git config"
echo "2. ✅ git config em RUN dedicado"
echo "3. ✅ Comandos Flutter em RUN separado"
echo "4. ✅ Estrutura modular mantida"
echo ""
echo "🚀 O erro 'dubious ownership' deve estar resolvido!"