import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../network/network_info.dart';
import '../storage/local_storage.dart';

// Products feature imports
import '../../features/products/data/datasources/product_local_datasource.dart';
import '../../features/products/data/datasources/product_local_datasource_impl.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/products/domain/usecases/get_all_products.dart';
import '../../features/products/domain/usecases/get_products_by_category.dart';

// Cart feature imports
import '../../features/cart/data/datasources/cart_local_datasource.dart';
import '../../features/cart/data/datasources/cart_local_datasource_impl.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';
import '../../features/cart/domain/usecases/add_to_cart.dart';
import '../../features/cart/domain/usecases/remove_from_cart.dart';
import '../../features/cart/domain/usecases/update_cart_item_quantity.dart';
import '../../features/cart/domain/usecases/get_cart.dart';
import '../../features/cart/domain/usecases/clear_cart.dart';

/// Service Locator global
final sl = GetIt.instance;

/// Inicializa todas as dependências do sistema
Future<void> initializeDependencies() async {
  // Inicializa Hive para storage local
  await Hive.initFlutter();

  // Core dependencies
  await _initCore();

  // External dependencies
  await _initExternal();

  // Features dependencies
  await _initFeatures();
}

/// Inicializa dependências core
Future<void> _initCore() async {
  // Logger
  sl.registerLazySingleton<Logger>(
    () => Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
    ),
  );

  // Local Storage
  sl.registerLazySingleton<LocalStorage>(() => HiveLocalStorage());

  // Inicializar storage
  await sl<LocalStorage>().init();

  // Network Info
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity: sl()),
  );
}

/// Inicializa dependências externas
Future<void> _initExternal() async {
  // Connectivity
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
}

/// Inicializa dependências das features
Future<void> _initFeatures() async {
  await _initProductsFeature();
  await _initCartFeature();
}

/// Inicializa dependências do módulo Products
Future<void> _initProductsFeature() async {
  // Data sources
  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(),
  );

  // Repositories
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(localDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton<GetAllProducts>(() => GetAllProducts(sl()));

  sl.registerLazySingleton<GetProductsByCategory>(
    () => GetProductsByCategory(sl()),
  );
}

/// Inicializa dependências do módulo Cart
Future<void> _initCartFeature() async {
  // Data sources
  sl.registerLazySingleton<CartLocalDataSource>(
    () => CartLocalDataSourceImpl(localStorage: sl(), logger: sl()),
  );

  // Repositories
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(
      localDataSource: sl(),
      productRepository: sl(),
      logger: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton<AddToCart>(() => AddToCart(sl()));

  sl.registerLazySingleton<RemoveFromCart>(() => RemoveFromCart(sl()));

  sl.registerLazySingleton<UpdateCartItemQuantity>(
    () => UpdateCartItemQuantity(sl()),
  );

  sl.registerLazySingleton<GetCart>(() => GetCart(sl()));

  sl.registerLazySingleton<ClearCart>(() => ClearCart(sl()));
}

/// Limpa todas as dependências (usado para testes)
Future<void> resetDependencies() async {
  // Dispose storage se necessário
  if (sl.isRegistered<LocalStorage>()) {
    final storage = sl<LocalStorage>();
    if (storage is HiveLocalStorage) {
      await storage.dispose();
    }
  }

  await sl.reset();
}
