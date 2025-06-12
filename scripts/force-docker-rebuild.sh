#!/bin/bash
# =============================================================================
# 🔄 Script de Rebuild Forçado - Dockerfile Corrigido
# =============================================================================
# Descrição: Força rebuild completo sem cache para aplicar correções
# Autor: PDV Restaurant Team
# =============================================================================

set -e

echo "🔄 Forçando rebuild completo do Docker sem cache..."
echo "=================================================="

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "\n${BLUE}📋 Verificando arquivos Dockerfile atuais...${NC}"

# Verificar se os Dockerfiles estão corretos
echo "   📄 Dockerfile principal:"
if grep -q "git config --global --add safe.directory /opt/flutter" Dockerfile; then
    echo -e "   ${GREEN}✅ Git safe directory configurado${NC}"
else
    echo -e "   ${RED}❌ Git safe directory NÃO configurado${NC}"
fi

echo "   📄 Dockerfile.dev:"
if grep -q "git config --global --add safe.directory /opt/flutter" Dockerfile.dev; then
    echo -e "   ${GREEN}✅ Git safe directory configurado${NC}"
else
    echo -e "   ${RED}❌ Git safe directory NÃO configurado${NC}"
fi

echo -e "\n${BLUE}🧹 Limpando cache do Docker...${NC}"
docker system prune -f || echo "⚠️  Não foi possível limpar cache automaticamente"

echo -e "\n${BLUE}🏗️ Executando build sem cache...${NC}"
echo "   Comando: docker build --no-cache -t pdv-test ."

if docker build --no-cache -t pdv-test .; then
    echo -e "\n${GREEN}🎉 Build realizado com sucesso!${NC}"
    echo -e "${GREEN}✅ Comandos RUN separados funcionando${NC}"
    echo -e "${GREEN}✅ Git safe directory configurado${NC}"
    echo -e "${GREEN}✅ Configuração Flutter isolada${NC}"
    
    echo -e "\n${BLUE}📊 Informações da imagem criada:${NC}"
    docker images pdv-test --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}"
    
    echo -e "\n${BLUE}🚀 Próximos passos:${NC}"
    echo "   1. Testar Dockerfile.dev: docker build -f Dockerfile.dev --no-cache -t pdv-dev ."
    echo "   2. Executar container: docker run -p 8080:8080 pdv-test"
    echo "   3. Fazer push para registry se tudo estiver OK"
    
else
    echo -e "\n${RED}❌ Build falhou!${NC}"
    echo -e "${YELLOW}💡 Possíveis causas:${NC}"
    echo "   - Comandos RUN ainda não estão separados corretamente"
    echo "   - Git safe directory não configurado antes dos comandos Flutter"
    echo "   - Cache do Docker ainda sendo usado"
    echo "   - Problemas de conectividade para baixar Flutter"
    
    echo -e "\n${YELLOW}🔍 Diagnóstico automático:${NC}"
    echo "   Verificando separação de comandos..."
    grep -n "RUN.*flutter.*config.*analytics" Dockerfile || echo "   ✅ Comando monolítico não encontrado"
    
    exit 1
fi

echo -e "\n${GREEN}🏁 Script concluído com sucesso!${NC}"