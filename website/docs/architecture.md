---
sidebar_position: 3
---

# Arquitetura

Entenda a estrutura e padrões arquiteturais do PDV Restaurant

## 🏗️ Visão Geral

O PDV Restaurant foi construído seguindo os princípios da **Clean Architecture**, garantindo separação de responsabilidades, testabilidade e facilidade de manutenção. A arquitetura é modular e escalável, permitindo fácil adição de novas funcionalidades.

## 📁 Estrutura de Pastas

```
lib/
├── 📁 core/                    # Configurações centrais
│   ├── 📁 constants/          # Constantes da aplicação
│   ├── 📁 services/           # Serviços compartilhados
│   ├── 📁 storage/            # Gerenciamento de dados
│   └── 📁 network/            # Configurações de rede
├── 📁 features/               # Módulos de funcionalidades
│   ├── 📁 products/           # Gestão de produtos
│   │   ├── 📁 domain/         # Entidades e casos de uso
│   │   ├── 📁 data/           # Repositórios e fontes de dados
│   │   └── 📁 presentation/   # UI e gerenciamento de estado
│   ├── 📁 cart/               # Carrinho de compras
│   └── 📁 navigation/         # Sistema de navegação
├── 📁 shared/                 # Código compartilhado
└── 📁 widgets/                # Componentes reutilizáveis
```

## 🎯 Princípios da Clean Architecture

### 1. Separação de Responsabilidades

Cada camada tem uma responsabilidade específica:

- **Domain**: Regras de negócio e entidades
- **Data**: Acesso a dados e implementação de repositórios
- **Presentation**: Interface do usuário e gerenciamento de estado

### 2. Inversão de Dependências

As camadas internas não dependem das externas:

```dart
// Domain Layer - Define contratos
abstract class ProductRepository {
  Future<List<Product>> getProducts();
}

// Data Layer - Implementa contratos
class ProductRepositoryImpl implements ProductRepository {
  @override
  Future<List<Product>> getProducts() {
    // Implementação específica
  }
}
```

### 3. Testabilidade

Cada camada pode ser testada independentemente:

```dart
// Teste unitário do caso de uso
test('should return products when repository succeeds', () async {
  // Arrange
  when(mockRepository.getProducts())
      .thenAnswer((_) async => [testProduct]);
  
  // Act
  final result = await useCase();
  
  // Assert
  expect(result, equals([testProduct]));
});
```

## 🏛️ Camadas da Arquitetura

### Domain Layer (Domínio)

A camada mais interna, contém:

#### Entities (Entidades)
```dart
class Product {
  final String id;
  final String name;
  final double price;
  final String category;
  final String imageUrl;
  
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.imageUrl,
  });
}
```

#### Use Cases (Casos de Uso)
```dart
class GetProductsUseCase {
  final ProductRepository repository;
  
  GetProductsUseCase(this.repository);
  
  Future<Either<Failure, List<Product>>> call() async {
    return await repository.getProducts();
  }
}
```

#### Repositories (Contratos)
```dart
abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, Product>> getProductById(String id);
}
```

### Data Layer (Dados)

Implementa os contratos do domínio:

#### Models (Modelos)
```dart
class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.name,
    required super.price,
    required super.category,
    required super.imageUrl,
  });
  
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      category: json['category'],
      imageUrl: json['imageUrl'],
    );
  }
}
```

#### Data Sources (Fontes de Dados)
```dart
abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getProducts();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final Box<ProductModel> box;
  
  @override
  Future<List<ProductModel>> getProducts() async {
    return box.values.toList();
  }
}
```

#### Repository Implementation
```dart
class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource localDataSource;
  
  ProductRepositoryImpl(this.localDataSource);
  
  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final products = await localDataSource.getProducts();
      return Right(products);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
```

### Presentation Layer (Apresentação)

Gerencia UI e estado:

#### Providers (Riverpod)
```dart
final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>(
  (ref) => ProductsNotifier(ref.read(getProductsUseCaseProvider)),
);

class ProductsNotifier extends StateNotifier<ProductsState> {
  final GetProductsUseCase getProductsUseCase;
  
  ProductsNotifier(this.getProductsUseCase) : super(ProductsInitial());
  
  Future<void> loadProducts() async {
    state = ProductsLoading();
    
    final result = await getProductsUseCase();
    
    result.fold(
      (failure) => state = ProductsError(failure.message),
      (products) => state = ProductsLoaded(products),
    );
  }
}
```

#### Widgets
```dart
class ProductsView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productsProvider);
    
    return state.when(
      initial: () => const SizedBox(),
      loading: () => const CircularProgressIndicator(),
      loaded: (products) => ProductGrid(products: products),
      error: (message) => ErrorWidget(message: message),
    );
  }
}
```

## 🔧 Stack Tecnológico

### Framework e Linguagem
| Tecnologia | Versão | Propósito |
|-----------|--------|-----------|
| **Flutter** | 3.7.2+ | Framework multiplataforma |
| **Dart** | 3.0+ | Linguagem de programação |

### UI e Design
| Tecnologia | Versão | Propósito |
|-----------|--------|-----------|
| **Fluent UI** | 4.8.6 | Design system moderno |
| **Custom Widgets** | - | Componentes personalizados |

### Gerenciamento de Estado
| Tecnologia | Versão | Propósito |
|-----------|--------|-----------|
| **Riverpod** | 2.4.9 | State management reativo |
| **StateNotifier** | - | Gerenciamento de estado |

### Injeção de Dependências
| Tecnologia | Versão | Propósito |
|-----------|--------|-----------|
| **GetIt** | 7.6.4 | Service locator |
| **Injectable** | - | Geração de código DI |

### Persistência de Dados
| Tecnologia | Versão | Propósito |
|-----------|--------|-----------|
| **Hive** | 2.2.3 | Banco de dados local |
| **Hive Generator** | - | Geração de adapters |

### Programação Funcional
| Tecnologia | Versão | Propósito |
|-----------|--------|-----------|
| **Dartz** | 0.10.1 | Either, Option, etc. |
| **Functional Programming** | - | Tratamento de erros |

### Testes
| Tecnologia | Versão | Propósito |
|-----------|--------|-----------|
| **Flutter Test** | - | Testes de widgets |
| **Mockito** | 5.4.4 | Mocking para testes |
| **Bloc Test** | - | Testes de estado |

## 🔄 Fluxo de Dados

### 1. Fluxo de Leitura
```
UI Widget → Provider → Use Case → Repository → Data Source → Storage
```

### 2. Fluxo de Escrita
```
UI Action → Provider → Use Case → Repository → Data Source → Storage
```

### 3. Exemplo Prático

```dart
// 1. Widget solicita dados
Consumer(
  builder: (context, ref, child) {
    final state = ref.watch(productsProvider);
    // ...
  },
)

// 2. Provider executa use case
class ProductsNotifier extends StateNotifier<ProductsState> {
  Future<void> loadProducts() async {
    final result = await getProductsUseCase();
    // ...
  }
}

// 3. Use case chama repository
class GetProductsUseCase {
  Future<Either<Failure, List<Product>>> call() async {
    return await repository.getProducts();
  }
}

// 4. Repository acessa data source
class ProductRepositoryImpl implements ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts() async {
    final products = await localDataSource.getProducts();
    return Right(products);
  }
}
```

## 🧪 Estratégia de Testes

### Testes Unitários
- **Domain Layer**: 90%+ cobertura
- **Use Cases**: Todos os cenários
- **Entities**: Validações e comportamentos

### Testes de Integração
- **Repository**: Integração com data sources
- **Data Sources**: Persistência e recuperação

### Testes de Widget
- **Presentation Layer**: 80%+ cobertura
- **UI Components**: Renderização e interações
- **State Management**: Mudanças de estado

## 📈 Benefícios da Arquitetura

### 1. Manutenibilidade
- Código organizado e bem estruturado
- Fácil localização de bugs
- Mudanças isoladas por camada

### 2. Testabilidade
- Cada camada testável independentemente
- Mocking facilitado pela inversão de dependências
- Cobertura de testes alta

### 3. Escalabilidade
- Fácil adição de novas features
- Reutilização de código
- Padrões consistentes

### 4. Flexibilidade
- Troca de implementações sem afetar outras camadas
- Suporte a múltiplas fontes de dados
- Adaptação a novos requisitos

## 🔮 Evolução Futura

### Próximas Melhorias
- **API Integration**: Camada de network
- **Offline-First**: Sincronização de dados
- **Microservices**: Arquitetura distribuída
- **Event Sourcing**: Histórico de eventos

### Padrões Adicionais
- **CQRS**: Separação de comandos e queries
- **Repository Pattern**: Já implementado
- **Observer Pattern**: Notificações reativas
- **Factory Pattern**: Criação de objetos