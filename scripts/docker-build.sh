#!/bin/bash

# =============================================================================
# 🐳 PDV Restaurant - Docker Build Script
# =============================================================================
# Autor: PDV Restaurant Team
# Descrição: Script automatizado para build e deploy Docker
# Uso: ./scripts/docker-build.sh [COMMAND] [OPTIONS]
# =============================================================================

set -euo pipefail

# =============================================================================
# 🎨 Configurações e Cores
# =============================================================================
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
readonly BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
readonly GIT_COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
readonly GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")

# Cores para output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly WHITE='\033[1;37m'
readonly NC='\033[0m' # No Color

# =============================================================================
# 📋 Configurações Padrão
# =============================================================================
IMAGE_NAME="${IMAGE_NAME:-pdv-restaurant}"
IMAGE_TAG="${IMAGE_TAG:-latest}"
REGISTRY="${REGISTRY:-docker.io}"
FLUTTER_VERSION="${FLUTTER_VERSION:-3.24.5}"
FLUTTER_RENDERER="${FLUTTER_RENDERER:-canvaskit}"
BUILD_MODE="${BUILD_MODE:-release}"
BASE_HREF="${BASE_HREF:-/}"
PLATFORMS="${PLATFORMS:-linux/amd64,linux/arm64}"

# =============================================================================
# 🛠️ Funções Utilitárias
# =============================================================================
log() {
    echo -e "${WHITE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $*"
}

log_info() {
    echo -e "${BLUE}ℹ️  INFO:${NC} $*"
}

log_success() {
    echo -e "${GREEN}✅ SUCCESS:${NC} $*"
}

log_warning() {
    echo -e "${YELLOW}⚠️  WARNING:${NC} $*"
}

log_error() {
    echo -e "${RED}❌ ERROR:${NC} $*" >&2
}

log_debug() {
    if [[ "${DEBUG:-false}" == "true" ]]; then
        echo -e "${PURPLE}🐛 DEBUG:${NC} $*"
    fi
}

spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

check_dependencies() {
    log_info "Verificando dependências..."
    
    local deps=("docker" "git")
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            log_error "Dependência não encontrada: $dep"
            exit 1
        fi
    done
    
    # Verificar se Docker está rodando
    if ! docker info &> /dev/null; then
        log_error "Docker não está rodando ou não está acessível"
        exit 1
    fi
    
    log_success "Todas as dependências estão OK"
}

show_help() {
    cat << EOF
${WHITE}🐳 PDV Restaurant - Docker Build Script${NC}

${CYAN}USAGE:${NC}
    $0 [COMMAND] [OPTIONS]

${CYAN}COMMANDS:${NC}
    build           Build da imagem Docker
    push            Push da imagem para registry
    run             Executa container localmente
    test            Executa testes no container
    clean           Remove imagens e containers antigos
    deploy          Deploy completo (build + push + run)
    dev             Inicia ambiente de desenvolvimento
    prod            Inicia ambiente de produção
    logs            Mostra logs dos containers
    health          Verifica saúde dos containers
    help            Mostra esta ajuda

${CYAN}OPTIONS:${NC}
    -t, --tag TAG           Tag da imagem (default: latest)
    -r, --registry REG      Registry para push (default: docker.io)
    -p, --platforms PLAT    Plataformas para build (default: linux/amd64,linux/arm64)
    -m, --mode MODE         Modo de build (debug|release) (default: release)
    --renderer RENDERER     Flutter web renderer (default: canvaskit)
    --base-href HREF        Base href para build (default: /)
    --no-cache             Build sem cache
    --push                 Push automático após build
    --verbose              Output verboso
    --dry-run              Simula comandos sem executar

${CYAN}EXAMPLES:${NC}
    $0 build                               # Build básico
    $0 build -t v2.0.0 --push            # Build com tag e push
    $0 deploy -t latest                   # Deploy completo
    $0 run -t v2.0.0                     # Executa versão específica
    $0 dev                               # Ambiente de desenvolvimento
    $0 clean                             # Limpeza de recursos

${CYAN}ENVIRONMENT VARIABLES:${NC}
    IMAGE_NAME              Nome da imagem (default: pdv-restaurant)
    REGISTRY                Registry para push (default: docker.io)
    DOCKER_USERNAME         Username para login no registry
    DOCKER_PASSWORD         Password para login no registry
    DEBUG                   Enable debug mode (true|false)

EOF
}

# =============================================================================
# 🏗️ Funções de Build
# =============================================================================
docker_build() {
    local tag="$1"
    local push_flag="$2"
    local cache_flag="$3"
    
    log_info "Iniciando build da imagem Docker..."
    log_info "Tag: ${CYAN}${tag}${NC}"
    log_info "Platforms: ${CYAN}${PLATFORMS}${NC}"
    log_info "Flutter Renderer: ${CYAN}${FLUTTER_RENDERER}${NC}"
    log_info "Build Mode: ${CYAN}${BUILD_MODE}${NC}"
    
    local build_args=(
        "--build-arg" "FLUTTER_WEB_RENDERER=${FLUTTER_RENDERER}"
        "--build-arg" "BUILD_MODE=${BUILD_MODE}"
        "--build-arg" "BASE_HREF=${BASE_HREF}"
        "--build-arg" "BUILD_DATE=${BUILD_DATE}"
        "--build-arg" "VCS_REF=${GIT_COMMIT}"
        "--build-arg" "VERSION=${tag}"
    )
    
    local docker_cmd=(
        "docker" "buildx" "build"
        "--platform" "${PLATFORMS}"
        "--tag" "${REGISTRY}/${IMAGE_NAME}:${tag}"
        "--file" "Dockerfile"
    )
    
    # Adicionar argumentos de build
    docker_cmd+=("${build_args[@]}")
    
    # Cache
    if [[ "$cache_flag" != "--no-cache" ]]; then
        docker_cmd+=("--cache-from" "type=local,src=/tmp/.buildx-cache")
        docker_cmd+=("--cache-to" "type=local,dest=/tmp/.buildx-cache-new,mode=max")
    else
        docker_cmd+=("--no-cache")
    fi
    
    # Push
    if [[ "$push_flag" == "--push" ]]; then
        docker_cmd+=("--push")
    else
        docker_cmd+=("--load")
    fi
    
    docker_cmd+=(".")
    
    log_debug "Docker command: ${docker_cmd[*]}"
    
    if [[ "${DRY_RUN:-false}" == "true" ]]; then
        log_warning "DRY RUN - Comando que seria executado:"
        echo "${docker_cmd[*]}"
        return 0
    fi
    
    cd "$PROJECT_ROOT"
    
    if [[ "${VERBOSE:-false}" == "true" ]]; then
        "${docker_cmd[@]}"
    else
        "${docker_cmd[@]}" &
        spinner $!
        wait $!
    fi
    
    # Mover cache
    if [[ "$cache_flag" != "--no-cache" ]] && [[ -d "/tmp/.buildx-cache-new" ]]; then
        rm -rf /tmp/.buildx-cache
        mv /tmp/.buildx-cache-new /tmp/.buildx-cache
    fi
    
    log_success "Build concluído com sucesso!"
}

docker_push() {
    local tag="$1"
    
    log_info "Fazendo push da imagem para ${REGISTRY}..."
    
    if [[ -n "${DOCKER_USERNAME:-}" ]] && [[ -n "${DOCKER_PASSWORD:-}" ]]; then
        log_info "Fazendo login no registry..."
        echo "$DOCKER_PASSWORD" | docker login "$REGISTRY" -u "$DOCKER_USERNAME" --password-stdin
    fi
    
    docker push "${REGISTRY}/${IMAGE_NAME}:${tag}"
    
    log_success "Push concluído com sucesso!"
}

docker_run() {
    local tag="$1"
    local port="${PORT:-8080}"
    
    log_info "Executando container..."
    
    # Parar container existente se houver
    docker stop "${IMAGE_NAME}-container" 2>/dev/null || true
    docker rm "${IMAGE_NAME}-container" 2>/dev/null || true
    
    docker run -d \
        --name "${IMAGE_NAME}-container" \
        --restart unless-stopped \
        -p "${port}:8080" \
        -e TZ=America/Sao_Paulo \
        "${REGISTRY}/${IMAGE_NAME}:${tag}"
    
    log_success "Container iniciado na porta ${port}"
    log_info "Acesse: ${CYAN}http://localhost:${port}${NC}"
    
    # Health check
    sleep 10
    if curl -f "http://localhost:${port}/health" &>/dev/null; then
        log_success "Health check passou!"
    else
        log_warning "Health check falhou - container pode ainda estar inicializando"
    fi
}

docker_test() {
    local tag="$1"
    
    log_info "Executando testes no container..."
    
    # Executar container para teste
    local test_container="${IMAGE_NAME}-test"
    docker run -d --name "$test_container" -p 8081:8080 "${REGISTRY}/${IMAGE_NAME}:${tag}"
    
    sleep 15
    
    # Testes básicos
    local tests_passed=0
    local total_tests=3
    
    # Teste 1: Health check
    if curl -f http://localhost:8081/health &>/dev/null; then
        log_success "✅ Health check test passed"
        ((tests_passed++))
    else
        log_error "❌ Health check test failed"
    fi
    
    # Teste 2: App loading
    if curl -f http://localhost:8081/ &>/dev/null; then
        log_success "✅ App loading test passed"
        ((tests_passed++))
    else
        log_error "❌ App loading test failed"
    fi
    
    # Teste 3: Manifest
    if curl -f http://localhost:8081/manifest.json &>/dev/null; then
        log_success "✅ Manifest test passed"
        ((tests_passed++))
    else
        log_error "❌ Manifest test failed"
    fi
    
    # Cleanup
    docker stop "$test_container" &>/dev/null || true
    docker rm "$test_container" &>/dev/null || true
    
    if [[ $tests_passed -eq $total_tests ]]; then
        log_success "Todos os testes passaram! ($tests_passed/$total_tests)"
        return 0
    else
        log_error "Alguns testes falharam! ($tests_passed/$total_tests)"
        return 1
    fi
}

docker_clean() {
    log_info "Limpando recursos Docker..."
    
    # Parar containers relacionados
    docker ps -q --filter="ancestor=${REGISTRY}/${IMAGE_NAME}" | xargs -r docker stop
    docker ps -aq --filter="ancestor=${REGISTRY}/${IMAGE_NAME}" | xargs -r docker rm
    
    # Remover imagens antigas (manter últimas 3)
    docker images "${REGISTRY}/${IMAGE_NAME}" --format "table {{.Tag}}\t{{.ID}}" | \
        tail -n +4 | awk '{print $2}' | xargs -r docker rmi -f
    
    # Limpeza geral
    docker builder prune -f
    docker system prune -f
    
    log_success "Limpeza concluída!"
}

start_dev_environment() {
    log_info "Iniciando ambiente de desenvolvimento..."
    
    cd "$PROJECT_ROOT"
    
    if [[ ! -f "docker-compose.yml" ]]; then
        log_error "docker-compose.yml não encontrado!"
        exit 1
    fi
    
    docker-compose up -d
    
    log_success "Ambiente de desenvolvimento iniciado!"
    log_info "Acesse: ${CYAN}http://localhost:3000${NC}"
}

start_prod_environment() {
    log_info "Iniciando ambiente de produção..."
    
    cd "$PROJECT_ROOT"
    
    if [[ ! -f "docker-compose.prod.yml" ]]; then
        log_error "docker-compose.prod.yml não encontrado!"
        exit 1
    fi
    
    docker-compose -f docker-compose.prod.yml up -d
    
    log_success "Ambiente de produção iniciado!"
    log_info "Acesse: ${CYAN}http://localhost:8080${NC}"
}

show_logs() {
    local service="${1:-}"
    
    cd "$PROJECT_ROOT"
    
    if [[ -n "$service" ]]; then
        docker-compose logs -f "$service"
    else
        docker-compose logs -f
    fi
}

health_check() {
    log_info "Verificando saúde dos containers..."
    
    local containers
    containers=$(docker ps --filter="ancestor=${REGISTRY}/${IMAGE_NAME}" --format "{{.Names}}")
    
    if [[ -z "$containers" ]]; then
        log_warning "Nenhum container em execução"
        return 1
    fi
    
    local healthy=0
    local total=0
    
    while IFS= read -r container; do
        ((total++))
        local health
        health=$(docker inspect --format='{{.State.Health.Status}}' "$container" 2>/dev/null || echo "unknown")
        
        case "$health" in
            "healthy")
                log_success "✅ $container: healthy"
                ((healthy++))
                ;;
            "unhealthy")
                log_error "❌ $container: unhealthy"
                ;;
            "starting")
                log_warning "⏳ $container: starting"
                ;;
            *)
                log_info "ℹ️  $container: $health"
                ;;
        esac
    done <<< "$containers"
    
    if [[ $healthy -eq $total ]]; then
        log_success "Todos os containers estão saudáveis! ($healthy/$total)"
        return 0
    else
        log_warning "Nem todos os containers estão saudáveis ($healthy/$total)"
        return 1
    fi
}

# =============================================================================
# 🚀 Função Principal
# =============================================================================
main() {
    local command="${1:-help}"
    shift || true
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -t|--tag)
                IMAGE_TAG="$2"
                shift 2
                ;;
            -r|--registry)
                REGISTRY="$2"
                shift 2
                ;;
            -p|--platforms)
                PLATFORMS="$2"
                shift 2
                ;;
            -m|--mode)
                BUILD_MODE="$2"
                shift 2
                ;;
            --renderer)
                FLUTTER_RENDERER="$2"
                shift 2
                ;;
            --base-href)
                BASE_HREF="$2"
                shift 2
                ;;
            --no-cache)
                CACHE_FLAG="--no-cache"
                shift
                ;;
            --push)
                PUSH_FLAG="--push"
                shift
                ;;
            --verbose)
                VERBOSE="true"
                shift
                ;;
            --dry-run)
                DRY_RUN="true"
                shift
                ;;
            *)
                log_error "Opção desconhecida: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Configurações padrão
    CACHE_FLAG="${CACHE_FLAG:-}"
    PUSH_FLAG="${PUSH_FLAG:-}"
    
    # Header
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════════════════════════════════════════════╗"
    echo "║                    🐳 PDV Restaurant - Docker Build Script                    ║"
    echo "╚════════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    case "$command" in
        "build")
            check_dependencies
            docker_build "$IMAGE_TAG" "$PUSH_FLAG" "$CACHE_FLAG"
            ;;
        "push")
            check_dependencies
            docker_push "$IMAGE_TAG"
            ;;
        "run")
            check_dependencies
            docker_run "$IMAGE_TAG"
            ;;
        "test")
            check_dependencies
            docker_test "$IMAGE_TAG"
            ;;
        "clean")
            check_dependencies
            docker_clean
            ;;
        "deploy")
            check_dependencies
            docker_build "$IMAGE_TAG" "--push" "$CACHE_FLAG"
            docker_test "$IMAGE_TAG"
            docker_run "$IMAGE_TAG"
            ;;
        "dev")
            check_dependencies
            start_dev_environment
            ;;
        "prod")
            check_dependencies
            start_prod_environment
            ;;
        "logs")
            show_logs "$1"
            ;;
        "health")
            health_check
            ;;
        "help"|"--help"|"-h")
            show_help
            ;;
        *)
            log_error "Comando desconhecido: $command"
            show_help
            exit 1
            ;;
    esac
}

# Execução do script
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi