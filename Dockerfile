# ===================================================================
# Dockerfile MVP Ultra-Simplificado - Flutter Web Estático
# ===================================================================
# 
# ✅ SOLUÇÃO ARM64: Usa apenas nginx:alpine (suporte nativo ARM64)
# ✅ SEM Flutter SDK: Elimina problema de compatibilidade binária
# ✅ ARQUIVOS ESTÁTICOS: Serve build/web pré-compilado
# ✅ COMPATÍVEL: EasyPanel, Docker ARM64/x64, todos os hosts
#
# 📋 PRÉ-REQUISITOS:
# - Build Flutter deve ser feito LOCALMENTE: flutter build web
# - Pasta build/web deve existir no projeto
#
# 🚀 USO:
# docker build -t pdv-restaurant .
# docker run -p 80:80 pdv-restaurant
#
# ===================================================================

FROM nginx:alpine

# Metadados da imagem
LABEL maintainer="PDV Restaurant Team"
LABEL version="1.0.0-mvp"
LABEL description="Flutter Web estático via nginx:alpine - ARM64 compatível"

# Remove configuração padrão do nginx
RUN rm /etc/nginx/conf.d/default.conf

# Copia configuração otimizada para Flutter Web
COPY nginx-flutter.conf /etc/nginx/conf.d/

# Copia arquivos estáticos do build Flutter Web
COPY build/web/ /usr/share/nginx/html/

# Define permissões corretas
RUN chown -R nginx:nginx /usr/share/nginx/html/ && \
    chmod -R 755 /usr/share/nginx/html/

# Expõe porta 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost/health || exit 1

# Comando de inicialização
CMD ["nginx", "-g", "daemon off;"]

# ===================================================================
# 📊 INFORMAÇÕES DO BUILD:
# - Imagem base: nginx:alpine (~5MB)
# - Suporte ARM64: ✅ Nativo
# - Suporte x64: ✅ Nativo  
# - Build time: ~30 segundos
# - Runtime: <50MB total
# ===================================================================