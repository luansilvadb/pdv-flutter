---
sidebar_position: 3
---

# 🏗️ Configuração do Projeto

Guia passo a passo para configurar o projeto PDV Restaurant em seu ambiente de desenvolvimento.

## 📥 Clonando o Repositório

### 1. Clone o Projeto

```bash
# Via HTTPS
git clone https://github.com/luansilvadb/pdv-flutter.git

# Via SSH (recomendado se você tem chave SSH configurada)
git clone git@github.com:luansilvadb/pdv-flutter.git

# Entrar no diretório
cd pdv-flutter
```

### 2. Verificar Branch

```bash
# Verificar branch atual
git branch

# Mudar para branch principal (se necessário)
git checkout main

# Verificar status
git status
```

## 📦 Instalação de Dependências

### 1. Instalar Dependências Flutter

```bash
# Instalar todas as dependências
flutter pub get

# Verificar dependências
flutter pub deps
```

### 2. Dependências Principais

O projeto utiliza as seguintes dependências principais:

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # UI Framework
  fluent_ui: ^4.8.6
  
  # State Management
  flutter_riverpod: ^2.4.9
  
  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # Dependency Injection
  get_it: ^7.6.4
  
  # Navigation
  go_router: ^13.2.0
  
  # Utilities
  equatable: ^2.0.5
  dartz: ^0.10.1
```

### 3. Dependências de Desenvolvimento

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # Code Generation
  build_runner: ^2.4.7
  hive_generator: ^2.0.1
  
  # Linting
  flutter_lints: ^3.0.1
  
  # Testing
  mockito: ^5.4.4
  bloc_test: ^9.1.5
```

## ⚙️ Configuração do Ambiente

### 1. Configurar Hive (Local Storage)

```bash
# Gerar arquivos do Hive
flutter packages pub run build_runner build
```

### 2. Configurar Assets

Verificar se os assets estão configurados no `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/images/
    - assets/icons/
    - assets/data/
```

### 3. Configurar Fontes (se aplicável)

```yaml
flutter:
  fonts:
    - family: Segoe UI
      fonts:
        - asset: assets/fonts/SegoeUI-Regular.ttf
        - asset: assets/fonts/SegoeUI-Bold.ttf
          weight: 700
```

## 🔧 Configuração por Plataforma

### Android

1. **Configurar `android/app/build.gradle`**:
   ```gradle
   android {
       compileSdkVersion 34
       
       defaultConfig {
           minSdkVersion 21
           targetSdkVersion 34
       }
   }
   ```

2. **Configurar permissões** em `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <uses-permission android:name="android.permission.INTERNET" />
   <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
   ```

### iOS

1. **Configurar `ios/Runner/Info.plist`**:
   ```xml
   <key>CFBundleDisplayName</key>
   <string>PDV Restaurant</string>
   
   <key>NSAppTransportSecurity</key>
   <dict>
       <key>NSAllowsArbitraryLoads</key>
       <true/>
   </dict>
   ```

2. **Configurar versão mínima** em `ios/Podfile`:
   ```ruby
   platform :ios, '11.0'
   ```

### Web

1. **Configurar `web/index.html`**:
   ```html
   <title>PDV Restaurant</title>
   <meta name="description" content="Sistema de PDV moderno para restaurantes">
   ```

2. **Configurar PWA** (opcional):
   ```html
   <link rel="manifest" href="manifest.json">
   <meta name="theme-color" content="#FF8A65">
   ```

### Desktop

1. **Windows**: Verificar `windows/runner/main.cpp`
2. **macOS**: Configurar `macos/Runner/Info.plist`
3. **Linux**: Verificar `linux/my_application.cc`

## 🏃‍♂️ Primeira Execução

### 1. Verificar Dispositivos Disponíveis

```bash
flutter devices
```

### 2. Executar o Projeto

```bash
# Executar em modo debug
flutter run

# Executar em dispositivo específico
flutter run -d chrome
flutter run -d windows
flutter run -d macos

# Executar com hot reload habilitado
flutter run --hot
```

### 3. Executar Testes

```bash
# Executar todos os testes
flutter test

# Executar testes com coverage
flutter test --coverage

# Executar testes específicos
flutter test test/unit/
flutter test test/widget/
```

## 🔍 Verificação da Configuração

### 1. Verificar Estrutura do Projeto

```
pdv-flutter/
├── 📁 lib/
│   ├── 📁 core/
│   ├── 📁 features/
│   ├── 📁 shared/
│   └── main.dart
├── 📁 test/
├── 📁 assets/
├── 📁 android/
├── 📁 ios/
├── 📁 web/
├── 📁 windows/
├── 📁 macos/
├── 📁 linux/
└── pubspec.yaml
```

### 2. Verificar Dependências

```bash
# Verificar dependências desatualizadas
flutter pub outdated

# Atualizar dependências
flutter pub upgrade

# Verificar conflitos
flutter pub deps
```

### 3. Verificar Build

```bash
# Build para Android
flutter build apk --debug

# Build para Web
flutter build web

# Build para Desktop
flutter build windows
flutter build macos
flutter build linux
```

## 🛠️ Configurações de Desenvolvimento

### 1. Configurar IDE

#### Visual Studio Code

Criar `.vscode/settings.json`:
```json
{
  "dart.flutterSdkPath": "/path/to/flutter",
  "dart.lineLength": 80,
  "editor.rulers": [80],
  "editor.formatOnSave": true,
  "dart.openDevTools": "flutter"
}
```

Criar `.vscode/launch.json`:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "PDV Restaurant",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "args": ["--flavor", "development"]
    }
  ]
}
```

#### Android Studio

1. Instalar plugins Flutter e Dart
2. Configurar SDK paths
3. Configurar code style

### 2. Configurar Git Hooks (opcional)

Criar `.git/hooks/pre-commit`:
```bash
#!/bin/sh
flutter analyze
flutter test
```

### 3. Configurar CI/CD (opcional)

Verificar `.github/workflows/` para configurações de CI/CD.

## 🚨 Problemas Comuns

### Problema: Pub get failed

**Solução**:
```bash
flutter clean
flutter pub get
```

### Problema: Build runner failed

**Solução**:
```bash
flutter packages pub run build_runner clean
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Problema: iOS build failed

**Solução**:
```bash
cd ios
pod install
cd ..
flutter clean
flutter run
```

### Problema: Android build failed

**Solução**:
```bash
flutter clean
cd android
./gradlew clean
cd ..
flutter run
```

## ✅ Próximos Passos

Após configurar o projeto com sucesso:

1. [Executar o Aplicativo](../first-steps/running-app)
2. [Entender a Estrutura](../first-steps/understanding-structure)
3. [Uso Básico](../first-steps/basic-usage)

## 🔗 Links Úteis

- [Flutter Project Structure](https://docs.flutter.dev/development/tools/flutter-create)
- [Managing Dependencies](https://docs.flutter.dev/development/packages-and-plugins/using-packages)
- [Build and Release](https://docs.flutter.dev/deployment)
- [Testing Flutter Apps](https://docs.flutter.dev/testing)