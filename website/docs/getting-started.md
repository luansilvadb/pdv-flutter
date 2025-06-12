---
sidebar_position: 2
---

# Começando

Guia completo para instalar e configurar o PDV Restaurant

## 📋 Pré-requisitos

Antes de começar, certifique-se de ter os seguintes requisitos instalados:

### Sistema Operacional
- **Windows** 10 ou superior (recomendado)
- **macOS** 10.14 ou superior
- **Linux** (Ubuntu 18.04+ ou equivalente)

### Ferramentas Necessárias

#### Flutter SDK
- **Versão mínima**: 3.7.2
- **Versão recomendada**: 3.19.0 ou superior

```bash
# Verificar versão do Flutter
flutter --version
```

#### Dart SDK
- **Versão mínima**: 3.0.0
- Incluído automaticamente com o Flutter

#### IDE (Escolha uma)
- **VS Code** (recomendado) com extensões Flutter/Dart
- **Android Studio** com plugins Flutter/Dart
- **IntelliJ IDEA** com plugins Flutter/Dart

### Para Desenvolvimento Mobile

- **Android Studio** para desenvolvimento Android
- **Xcode** para desenvolvimento iOS (apenas macOS)

## Verificação do Ambiente

Antes de prosseguir, verifique se seu ambiente está configurado corretamente:

```bash
# Verificar instalação do Flutter
flutter doctor

# Verificar versão do Flutter
flutter --version

# Listar dispositivos disponíveis
flutter devices
```

O comando `flutter doctor` deve mostrar todos os componentes como ✅ (ou pelo menos sem ❌ críticos).

## Instalação

### 1. Clone o Repositório

```bash
git clone https://github.com/luansilvadb/pdv-flutter.git
cd pdv-flutter
```

### 2. Instale as Dependências

```bash
# Instalar dependências do projeto
flutter pub get

# Gerar arquivos necessários (Hive, etc.)
flutter packages pub run build_runner build
```

### 3. Configuração Inicial

#### Configurar Hive (Storage Local)

O projeto usa Hive para persistência local. A inicialização é automática, mas você pode verificar:

```dart
// Já configurado em lib/core/services/dependency_injection.dart
await Hive.initFlutter();
```

#### Verificar Assets

Certifique-se de que os assets estão disponíveis:

```bash
# Verificar se as imagens estão no local correto
ls assets/images/burgers/
```

## Executando o Projeto

### Modo Debug

```bash
# Executar em modo debug (padrão)
flutter run

# Executar com hot reload ativo
flutter run --hot
```

### Modo Release

```bash
# Executar em modo release (otimizado)
flutter run --release
```

### Plataformas Específicas

```bash
# Desktop (Windows/macOS/Linux)
flutter run -d windows
flutter run -d macos
flutter run -d linux

# Web
flutter run -d chrome

# Mobile
flutter run -d android
flutter run -d ios
```

## Estrutura do Projeto

Entenda a organização do código:

```
lib/
├── 🎯 core/                 # Configurações centrais
│   ├── constants/          # Constantes da aplicação
│   ├── services/           # Serviços compartilhados
│   ├── storage/            # Configuração de storage
│   └── utils/              # Utilitários gerais
├── 🎪 features/            # Funcionalidades por domínio
│   ├── cart/              # 🛒 Carrinho de compras
│   ├── navigation/        # 🧭 Sistema de navegação
│   └── products/          # 📦 Catálogo de produtos
├── 🔗 shared/             # Código compartilhado
├── 🧩 widgets/            # Componentes reutilizáveis
└── 📱 screens/            # Telas principais
```

## Configuração de Desenvolvimento

### VS Code

Crie `.vscode/settings.json`:

```json
{
  "dart.flutterSdkPath": "/path/to/flutter",
  "dart.lineLength": 80,
  "editor.rulers": [80],
  "editor.formatOnSave": true,
  "dart.previewFlutterUiGuides": true,
  "dart.previewFlutterUiGuidesCustomTracking": true
}
```

### Launch Configuration

Crie `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "PDV Restaurant (Debug)",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "args": ["--flavor", "development"]
    },
    {
      "name": "PDV Restaurant (Release)",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "flutterMode": "release"
    }
  ]
}
```

## Comandos Úteis

### Desenvolvimento

```bash
# Limpar build cache
flutter clean

# Reinstalar dependências
flutter pub get

# Analisar código
flutter analyze

# Formatar código
dart format .

# Executar testes
flutter test

# Gerar coverage
flutter test --coverage
```

### Build

```bash
# Build para Android
flutter build apk
flutter build appbundle

# Build para iOS
flutter build ios

# Build para Web
flutter build web

# Build para Desktop
flutter build windows
flutter build macos
flutter build linux
```

## Solução de Problemas

### Problemas Comuns

#### 1. Erro de Dependências

```bash
# Limpar e reinstalar
flutter clean
flutter pub get
```

#### 2. Problemas com Hive

```bash
# Regenerar arquivos Hive
flutter packages pub run build_runner clean
flutter packages pub run build_runner build
```

#### 3. Problemas de Assets

Verifique se o `pubspec.yaml` está correto:

```yaml
flutter:
  assets:
    - assets/images/
    - assets/images/burgers/
```

#### 4. Problemas de Performance

```bash
# Executar em modo profile para debug de performance
flutter run --profile
```

### Logs e Debug

```bash
# Logs detalhados
flutter run --verbose

# Logs do dispositivo
flutter logs

# Inspector de widgets
flutter inspector
```

## Próximos Passos

Agora que você tem o projeto rodando:

1. 📖 Explore a [Arquitetura](./architecture) do projeto
2. 🎨 Conheça as [Funcionalidades](./features) disponíveis
3. 🔧 Consulte a [API Reference](./api-reference) para desenvolvimento
4. 📋 Veja o [Changelog](./changelog) para atualizações

## Suporte

Se você encontrar problemas:

- 🐛 [Reportar Bug](https://github.com/luansilvadb/pdv-flutter/issues)
- 💬 [Discussões](https://github.com/luansilvadb/pdv-flutter/discussions)
- 📧 [Contato Direto](mailto:contato@example.com)

## Contribuindo

Interessado em contribuir? Veja nosso [Guia de Contribuição](https://github.com/luansilvadb/pdv-flutter/blob/main/CONTRIBUTING.md)!