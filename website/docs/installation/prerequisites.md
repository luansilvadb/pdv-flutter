---
sidebar_position: 1
---

# 📋 Pré-requisitos

Antes de começar com o PDV Restaurant, certifique-se de que seu ambiente de desenvolvimento atende aos requisitos mínimos.

## 🖥️ Requisitos do Sistema

### Hardware Mínimo
- **RAM**: 4GB (recomendado: 8GB ou mais)
- **Armazenamento**: 2GB de espaço livre
- **Processador**: Intel i3 ou AMD equivalente (recomendado: i5 ou superior)

### Sistemas Operacionais Suportados
- **Windows**: 10 ou superior (64-bit)
- **macOS**: 10.14 (Mojave) ou superior
- **Linux**: Ubuntu 18.04 LTS ou superior, outras distribuições compatíveis

## 🛠️ Ferramentas Necessárias

### Flutter SDK
- **Versão**: 3.7.2 ou superior
- **Canal**: Stable (recomendado)

```bash
# Verificar versão do Flutter
flutter --version

# Verificar configuração do ambiente
flutter doctor
```

### Dart SDK
- **Versão**: 3.0 ou superior
- Incluído automaticamente com o Flutter SDK

### Git
- **Versão**: 2.20 ou superior
- Necessário para clonar o repositório

```bash
# Verificar versão do Git
git --version
```

## 🔧 IDEs Recomendadas

### Visual Studio Code
- **Extensões obrigatórias**:
  - Flutter
  - Dart
  - GitLens (recomendado)
  - Bracket Pair Colorizer (recomendado)

### Android Studio
- **Plugins obrigatórios**:
  - Flutter plugin
  - Dart plugin

### IntelliJ IDEA
- **Plugins obrigatórios**:
  - Flutter plugin
  - Dart plugin

## 📱 Configuração para Desenvolvimento Mobile

### Android
- **Android Studio**: 4.1 ou superior
- **Android SDK**: API level 21 (Android 5.0) ou superior
- **Java**: JDK 8 ou superior

```bash
# Verificar configuração Android
flutter doctor --android-licenses
```

### iOS (apenas macOS)
- **Xcode**: 12.0 ou superior
- **iOS Simulator**: iOS 11.0 ou superior
- **CocoaPods**: Instalado via Homebrew

```bash
# Instalar CocoaPods
sudo gem install cocoapods
```

## 🌐 Configuração para Web

### Navegadores Suportados
- **Chrome**: 84 ou superior (recomendado para desenvolvimento)
- **Firefox**: 72 ou superior
- **Safari**: 13 ou superior
- **Edge**: 84 ou superior

```bash
# Habilitar suporte web no Flutter
flutter config --enable-web
```

## 🖥️ Configuração para Desktop

### Windows
- **Visual Studio**: 2019 ou superior (Build Tools)
- **Windows SDK**: 10.0.17763.0 ou superior

### macOS
- **Xcode**: 12.0 ou superior
- **Command Line Tools**: Instalados

### Linux
- **Dependências**:
  ```bash
  sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev
  ```

```bash
# Habilitar suporte desktop
flutter config --enable-windows-desktop
flutter config --enable-macos-desktop
flutter config --enable-linux-desktop
```

## ✅ Verificação Final

Execute o comando abaixo para verificar se tudo está configurado corretamente:

```bash
flutter doctor -v
```

### Saída Esperada
```
[✓] Flutter (Channel stable, 3.7.2, on macOS 13.0 22A380)
[✓] Android toolchain - develop for Android devices
[✓] Xcode - develop for iOS and macOS
[✓] Chrome - develop for the web
[✓] Android Studio (version 2022.1)
[✓] VS Code (version 1.74.0)
[✓] Connected device (4 available)
[✓] HTTP Host Availability
```

## 🚨 Problemas Comuns

### Flutter Doctor Issues

**Problema**: Android licenses not accepted
```bash
# Solução
flutter doctor --android-licenses
```

**Problema**: Xcode not found (macOS)
```bash
# Solução
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

**Problema**: Chrome not found
```bash
# Solução - definir variável de ambiente
export CHROME_EXECUTABLE=/path/to/chrome
```

## 📚 Próximos Passos

Após verificar todos os pré-requisitos:

1. [Configurar Flutter SDK](./flutter-setup)
2. [Configurar o Projeto](./project-setup)
3. [Solução de Problemas](./troubleshooting)

## 🔗 Links Úteis

- [Documentação Oficial do Flutter](https://docs.flutter.dev/get-started/install)
- [Flutter System Requirements](https://docs.flutter.dev/get-started/install#system-requirements)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)