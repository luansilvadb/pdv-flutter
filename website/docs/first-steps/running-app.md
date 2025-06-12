---
sidebar_position: 1
---

# 🚀 Executando o Aplicativo

Guia completo para executar o PDV Restaurant pela primeira vez em diferentes plataformas.

## 🎯 Verificação Inicial

Antes de executar o aplicativo, certifique-se de que tudo está configurado corretamente:

```bash
# Verificar configuração do Flutter
flutter doctor

# Verificar dispositivos disponíveis
flutter devices

# Verificar dependências do projeto
flutter pub get
```

## 📱 Executando em Diferentes Plataformas

### 🌐 Web (Recomendado para Desenvolvimento)

A plataforma web é ideal para desenvolvimento rápido e testes:

```bash
# Executar no Chrome
flutter run -d chrome

# Executar com hot reload
flutter run -d chrome --hot

# Executar em modo debug com DevTools
flutter run -d chrome --web-renderer html
```

**Vantagens da Web**:
- ✅ Hot reload mais rápido
- ✅ DevTools integrado
- ✅ Não requer emulador
- ✅ Fácil compartilhamento

### 🖥️ Desktop

#### Windows
```bash
# Executar no Windows
flutter run -d windows

# Build para Windows
flutter build windows
```

#### macOS
```bash
# Executar no macOS
flutter run -d macos

# Build para macOS
flutter build macos
```

#### Linux
```bash
# Executar no Linux
flutter run -d linux

# Build para Linux
flutter build linux
```

### 📱 Mobile

#### Android

1. **Configurar Emulador**:
   ```bash
   # Listar AVDs disponíveis
   flutter emulators
   
   # Iniciar emulador específico
   flutter emulators --launch Pixel_4_API_30
   ```

2. **Executar no Android**:
   ```bash
   # Executar no emulador/dispositivo Android
   flutter run -d android
   
   # Executar em dispositivo específico
   flutter run -d emulator-5554
   ```

#### iOS (apenas macOS)

1. **Configurar Simulador**:
   ```bash
   # Abrir simulador iOS
   open -a Simulator
   
   # Listar simuladores disponíveis
   xcrun simctl list devices
   ```

2. **Executar no iOS**:
   ```bash
   # Executar no simulador iOS
   flutter run -d ios
   
   # Executar em simulador específico
   flutter run -d "iPhone 14 Pro"
   ```

## 🎮 Comandos de Execução Úteis

### Comandos Básicos

```bash
# Executar com hot reload (padrão)
flutter run

# Executar sem hot reload
flutter run --no-hot

# Executar em modo release
flutter run --release

# Executar com verbose logging
flutter run -v
```

### Comandos Avançados

```bash
# Executar com flavor específico
flutter run --flavor development

# Executar com target específico
flutter run --target lib/main_dev.dart

# Executar com porta específica (web)
flutter run -d chrome --web-port 8080

# Executar com host específico (web)
flutter run -d chrome --web-hostname 0.0.0.0
```

## 🔥 Hot Reload e Hot Restart

### Hot Reload (r)
- **Uso**: Pressione `r` no terminal
- **Função**: Recarrega o código sem perder o estado
- **Ideal para**: Mudanças na UI, correções rápidas

### Hot Restart (R)
- **Uso**: Pressione `R` no terminal
- **Função**: Reinicia o app completamente
- **Ideal para**: Mudanças em main(), novos imports

### Outros Comandos Durante Execução

```bash
r    # Hot reload
R    # Hot restart
h    # Lista de comandos disponíveis
d    # Detach (manter app rodando)
c    # Clear screen
q    # Quit
```

## 🎯 Primeira Execução - O que Esperar

### 1. Tela de Carregamento
- Logo do PDV Restaurant
- Indicador de carregamento
- Inicialização dos serviços

### 2. Tela Principal
- **Sidebar**: Navegação principal
- **Header**: Título e controles
- **Conteúdo**: Catálogo de produtos
- **Carrinho**: Painel lateral direito

### 3. Funcionalidades Disponíveis
- ✅ Navegação entre categorias
- ✅ Visualização de produtos
- ✅ Adição ao carrinho
- ✅ Cálculo de totais
- ✅ Tema dark/light

## 🔍 Verificando se Tudo Funciona

### Teste Básico de Funcionalidades

1. **Navegação**:
   - Clique em diferentes categorias na sidebar
   - Verifique se os produtos mudam

2. **Produtos**:
   - Visualize os cards de produtos
   - Verifique imagens e informações

3. **Carrinho**:
   - Adicione produtos ao carrinho
   - Verifique cálculos de subtotal
   - Teste remoção de itens

4. **Interface**:
   - Teste redimensionamento da janela
   - Verifique responsividade
   - Teste tema dark/light (se disponível)

### Logs Importantes

Durante a execução, observe os logs para:

```bash
# Logs normais
I/flutter: App initialized successfully
I/flutter: Products loaded: 24 items
I/flutter: Cart updated: 3 items

# Logs de erro (se houver)
E/flutter: Error loading products
E/flutter: Navigation failed
```

## 🚨 Problemas Comuns e Soluções

### Problema: "No devices found"

**Solução**:
```bash
# Verificar dispositivos
flutter devices

# Para web, verificar se Chrome está instalado
which google-chrome

# Para Android, verificar emulador
flutter emulators
```

### Problema: "Build failed"

**Solução**:
```bash
# Limpar cache
flutter clean

# Reinstalar dependências
flutter pub get

# Tentar novamente
flutter run
```

### Problema: "Hot reload not working"

**Solução**:
```bash
# Usar hot restart
R

# Ou reiniciar completamente
q
flutter run
```

### Problema: "Web renderer issues"

**Solução**:
```bash
# Tentar renderer diferente
flutter run -d chrome --web-renderer canvaskit

# Ou usar HTML renderer
flutter run -d chrome --web-renderer html
```

### Problema: "Port already in use" (Web)

**Solução**:
```bash
# Usar porta diferente
flutter run -d chrome --web-port 8081

# Ou matar processo na porta
lsof -ti:8080 | xargs kill -9
```

## 📊 Performance e Debugging

### Monitorar Performance

```bash
# Executar com performance overlay
flutter run --enable-software-rendering

# Executar com debug info
flutter run --debug

# Executar com profile mode
flutter run --profile
```

### Acessar DevTools

1. **Durante execução**, pressione `w` para abrir DevTools
2. **Ou acesse**: http://localhost:9100
3. **Funcionalidades**:
   - Inspector de widgets
   - Performance profiler
   - Memory usage
   - Network inspector

## ✅ Próximos Passos

Após executar o aplicativo com sucesso:

1. [Entender a Estrutura do Projeto](./understanding-structure)
2. [Uso Básico do Sistema](./basic-usage)
3. [Explorar Funcionalidades](../features)

## 🔗 Links Úteis

- [Flutter Run Command](https://docs.flutter.dev/reference/flutter-cli#flutter-run)
- [Hot Reload](https://docs.flutter.dev/development/tools/hot-reload)
- [DevTools](https://docs.flutter.dev/development/tools/devtools/overview)
- [Debugging Flutter Apps](https://docs.flutter.dev/testing/debugging)