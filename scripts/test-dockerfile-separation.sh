#!/bin/bash
# =============================================================================
# 🧪 Script de Teste - Separação de Comandos RUN nos Dockerfiles
# =============================================================================
# Descrição: Verifica se os comandos RUN estão separados corretamente
# Autor: PDV Restaurant Team
# =============================================================================

set -e

echo "🧪 Testando separação de comandos RUN nos Dockerfiles..."
echo "=================================================="

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Função para verificar separação de comandos
check_dockerfile_separation() {
    local dockerfile=$1
    local name=$2
    
    echo -e "\n📋 Verificando ${name}..."
    
    if [ ! -f "$dockerfile" ]; then
        echo -e "${RED}❌ Arquivo $dockerfile não encontrado${NC}"
        return 1
    fi
    
    # Verificar se há comandos RUN separados para Flutter
    download_run=$(grep -n "curl.*flutter_linux.*tar -xJ" "$dockerfile" | wc -l)
    git_safe_run=$(grep -n "git config.*safe.directory" "$dockerfile" | wc -l)
    flutter_config_run=$(grep -n "flutter config.*analytics" "$dockerfile" | wc -l)
    
    echo "   📥 Download Flutter: $download_run comando(s) RUN"
    echo "   🔒 Git safe directory: $git_safe_run comando(s) RUN"
    echo "   ⚙️  Config Flutter: $flutter_config_run comando(s) RUN"
    
    # Verificar se não há comando monolítico
    monolithic=$(grep -A 10 "curl.*flutter_linux" "$dockerfile" | grep -c "flutter config.*analytics" || true)
    
    if [ "$download_run" -eq 1 ] && [ "$git_safe_run" -eq 1 ] && [ "$flutter_config_run" -eq 1 ] && [ "$monolithic" -eq 0 ]; then
        echo -e "   ${GREEN}✅ Comandos RUN separados corretamente${NC}"
        return 0
    else
        echo -e "   ${RED}❌ Comandos RUN não estão separados corretamente${NC}"
        if [ "$monolithic" -gt 0 ]; then
            echo -e "   ${YELLOW}⚠️  Detectado comando monolítico${NC}"
        fi
        return 1
    fi
}

# Verificar ambos os Dockerfiles
success=true

check_dockerfile_separation "Dockerfile" "Dockerfile Principal" || success=false
check_dockerfile_separation "Dockerfile.dev" "Dockerfile de Desenvolvimento" || success=false

echo -e "\n=================================================="
if [ "$success" = true ]; then
    echo -e "${GREEN}🎉 Todos os Dockerfiles estão corretos!${NC}"
    echo -e "${GREEN}✅ Comandos RUN separados adequadamente${NC}"
    echo -e "${GREEN}✅ Git safe directory configurado${NC}"
    echo -e "${GREEN}✅ Configuração Flutter isolada${NC}"
else
    echo -e "${RED}❌ Alguns Dockerfiles precisam de correção${NC}"
    exit 1
fi

echo -e "\n🚀 Próximos passos:"
echo "   1. Testar build: docker build -t pdv-test ."
echo "   2. Testar dev: docker build -f Dockerfile.dev -t pdv-dev ."
echo "   3. Executar testes de integração"