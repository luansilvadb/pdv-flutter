---
sidebar_position: 2
---

# 🚀 Configuração do Flutter

Guia completo para instalar e configurar o Flutter SDK em seu sistema.

## 📥 Download do Flutter

### 1. Baixar o Flutter SDK

Acesse o site oficial e baixe a versão mais recente:
- **Site oficial**: [flutter.dev](https://flutter.dev/docs/get-started/install)

### 2. Escolher a Versão Correta

| Sistema | Arquivo | Tamanho |
|---------|---------|---------|
| Windows | `flutter_windows_3.7.2-stable.zip` | ~1.2GB |
| macOS | `flutter_macos_3.7.2-stable.zip` | ~1.1GB |
| Linux | `flutter_linux_3.7.2-stable.tar.xz` | ~900MB |

## 🔧 Instalação por Sistema Operacional

### Windows

1. **Extrair o arquivo**:
   ```bash
   # Extrair para C:\src\flutter
   # Evite pastas com espaços ou caracteres especiais
   ```

2. **Adicionar ao PATH**:
   ```bash
   # Adicionar ao PATH do sistema:
   C:\src\flutter\bin
   ```

3. **Verificar instalação**:
   ```bash
   flutter --version
   flutter doctor
   ```

### macOS

1. **Extrair o arquivo**:
   ```bash
   cd ~/development
   unzip ~/Downloads/flutter_macos_3.7.2-stable.zip
   ```

2. **Adicionar ao PATH**:
   ```bash
   # Adicionar ao ~/.zshrc ou ~/.bash_profile
   export PATH="$PATH:`pwd`/flutter/bin"
   
   # Recarregar o shell
   source ~/.zshrc
   ```

3. **Verificar instalação**:
   ```bash
   flutter --version
   flutter doctor
   ```

### Linux

1. **Extrair o arquivo**:
   ```bash
   cd ~/development
   tar xf ~/Downloads/flutter_linux_3.7.2-stable.tar.xz
   ```

2. **Adicionar ao PATH**:
   ```bash
   # Adicionar ao ~/.bashrc
   export PATH="$PATH:$HOME/development/flutter/bin"
   
   # Recarregar o shell
   source ~/.bashrc
   ```

3. **Verificar instalação**:
   ```bash
   flutter --version
   flutter doctor
   ```

## ⚙️ Configuração Inicial

### 1. Executar Flutter Doctor

```bash
flutter doctor
```

Este comando verifica seu ambiente e mostra um relatório do status da instalação.

### 2. Aceitar Licenças Android

```bash
flutter doctor --android-licenses
```

### 3. Configurar Canais do Flutter

```bash
# Verificar canal atual
flutter channel

# Mudar para canal stable (recomendado)
flutter channel stable
flutter upgrade
```

## 🎯 Configurações Específicas

### Habilitar Plataformas

```bash
# Web
flutter config --enable-web

# Desktop Windows
flutter config --enable-windows-desktop

# Desktop macOS
flutter config --enable-macos-desktop

# Desktop Linux
flutter config --enable-linux-desktop
```

### Configurar Editor Padrão

```bash
# Visual Studio Code
flutter config --editor vscode

# Android Studio
flutter config --editor android-studio
```

## 🔍 Verificação da Instalação

### Comando de Diagnóstico Completo

```bash
flutter doctor -v
```

### Saída Esperada (Exemplo)

```
[✓] Flutter (Channel stable, 3.7.2, on macOS 13.0 22A380 darwin-x64)
    • Flutter version 3.7.2 on channel stable
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision 7e9793dee1 (2 weeks ago), 2023-02-01 09:07:31 -0800
    • Engine revision 1837b5be5f
    • Dart version 2.19.2
    • DevTools version 2.20.1

[✓] Android toolchain - develop for Android devices (Android SDK version 33.0.0)
    • Android SDK at /Users/user/Library/Android/sdk
    • Platform android-33, build-tools 33.0.0
    • Java binary at: /Applications/Android Studio.app/Contents/jre/Contents/Home/bin/java
    • Java version OpenJDK Runtime Environment (build 11.0.15+0-b2043.56-8887301)
    • All Android licenses accepted.

[✓] Xcode - develop for iOS and macOS (Xcode 14.2)
    • Xcode at /Applications/Xcode.app/Contents/Developer
    • Build 14C18
    • CocoaPods version 1.11.3

[✓] Chrome - develop for the web
    • Chrome at /Applications/Google Chrome.app/Contents/MacOS/Google Chrome

[✓] Android Studio (version 2022.1)
    • Android Studio at /Applications/Android Studio.app
    • Flutter plugin can be installed from:
      🔨 https://plugins.jetbrains.com/plugin/9212-flutter
    • Dart plugin can be installed from:
      🔨 https://plugins.jetbrains.com/plugin/6351-dart
    • Java version OpenJDK Runtime Environment (build 11.0.15+0-b2043.56-8887301)

[✓] VS Code (version 1.74.0)
    • VS Code at /Applications/Visual Studio Code.app/Contents
    • Flutter extension version 3.56.0

[✓] Connected device (4 available)
    • macOS (desktop) • macos  • darwin-x64     • macOS 13.0 22A380 darwin-x64
    • Chrome (web)    • chrome • web-javascript • Google Chrome 109.0.5414.119
    • iPhone 14 Pro Max (mobile) • 12345678-1234567890ABCDEF • ios • com.apple.CoreSimulator.SimRuntime.iOS-16-2 (simulator)
    • Android SDK built for x86 (mobile) • emulator-5554 • android-x86 • Android 11 (API 30) (emulator)

[✓] HTTP Host Availability
    • All required HTTP hosts are available

• No issues found!
```

## 🛠️ Configurações Avançadas

### Configurar Proxy (se necessário)

```bash
# Configurar proxy HTTP
flutter config --proxy-host proxy.company.com
flutter config --proxy-port 8080

# Configurar proxy HTTPS
flutter config --https-proxy-host proxy.company.com
flutter config --https-proxy-port 8080
```

### Configurar Mirror (China)

```bash
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
```

### Configurações de Performance

```bash
# Habilitar compilação incremental
flutter config --enable-incremental-compiler

# Configurar cache
flutter config --clear-ios-signing-cert
```

## 🚨 Solução de Problemas Comuns

### Problema: Command not found

**Causa**: Flutter não está no PATH
**Solução**:
```bash
# Verificar PATH
echo $PATH

# Adicionar Flutter ao PATH permanentemente
export PATH="$PATH:/path/to/flutter/bin"
```

### Problema: Android licenses not accepted

**Solução**:
```bash
flutter doctor --android-licenses
# Aceitar todas as licenças digitando 'y'
```

### Problema: Xcode command line tools not found

**Solução**:
```bash
sudo xcode-select --install
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

### Problema: CocoaPods not installed

**Solução**:
```bash
# macOS
sudo gem install cocoapods
pod setup
```

## ✅ Próximos Passos

Após configurar o Flutter com sucesso:

1. [Configurar o Projeto PDV](./project-setup)
2. [Executar o Primeiro App](../first-steps/running-app)
3. [Entender a Estrutura](../first-steps/understanding-structure)

## 🔗 Links Úteis

- [Flutter Installation Guide](https://docs.flutter.dev/get-started/install)
- [Flutter Doctor](https://docs.flutter.dev/get-started/install#run-flutter-doctor)
- [Flutter Channels](https://github.com/flutter/flutter/wiki/Flutter-build-release-channels)
- [Flutter Config](https://docs.flutter.dev/development/tools/flutter-config)