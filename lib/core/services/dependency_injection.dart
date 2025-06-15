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
import '../../features/products/domain/use_cases/get_available_products.dart';
import '../../features/products/domain/use_cases/filter_products_by_category.dart';
import '../../features/products/domain/use_cases/search_products.dart';

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

// Orders feature imports
import '../../features/orders/data/datasources/order_local_data_source.dart';
import '../../features/orders/data/repositories/order_repository_impl.dart';
import '../../features/orders/domain/repositories/order_repository.dart';
import '../../features/orders/domain/usecases/create_order.dart';
import '../../features/orders/domain/usecases/get_all_orders.dart';
import '../../features/orders/domain/usecases/get_orders_by_date_range.dart';

// Printing feature imports
import '../../features/printing/data/datasources/pdf_generator.dart';
import '../../features/printing/data/datasources/printing_service.dart';
import '../../features/printing/data/repositories/printing_repository_impl.dart';
import '../../features/printing/domain/repositories/printing_repository.dart';
import '../../features/printing/domain/usecases/generate_receipt_pdf.dart';
import '../../features/printing/domain/usecases/generate_pdf_bytes.dart';
import '../../features/printing/domain/usecases/print_receipt.dart';
import '../../features/printing/domain/usecases/save_receipt_pdf.dart';

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
  await _initOrdersFeature();
  await _initPrintingFeature();
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
  sl.registerLazySingleton<GetAvailableProducts>(
    () => GetAvailableProducts(sl()),
  );

  sl.registerLazySingleton<FilterProductsByCategory>(
    () => FilterProductsByCategory(sl()),
  );
  sl.registerLazySingleton<SearchProducts>(() => SearchProducts(sl()));
}

/// Inicializa dependências do módulo Cart
Future<void> _initCartFeature() async {
  // Data sources
  sl.registerLazySingleton<CartLocalDataSource>(
    () => CartLocalDataSourceImpl(localStorage: sl(), logger: sl()),
  );

  // Repositories
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(localDataSource: sl(), logger: sl()),
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

/// Inicializa dependências do módulo Orders
Future<void> _initOrdersFeature() async {
  // Data sources
  sl.registerLazySingleton<OrderLocalDataSource>(
    () => OrderLocalDataSourceImpl(localStorage: sl()),
  );

  // Repositories
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(localDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton<CreateOrder>(() => CreateOrder(sl()));
  
  sl.registerLazySingleton<GetAllOrders>(() => GetAllOrders(sl()));
    sl.registerLazySingleton<GetOrdersByDateRange>(() => GetOrdersByDateRange(sl()));
}

/// Inicializa dependências do módulo Printing
Future<void> _initPrintingFeature() async {
  // Data sources
  sl.registerLazySingleton<PdfGenerator>(
    () => PdfGeneratorImpl(),
  );
  
  sl.registerLazySingleton<PrintingService>(
    () => PrintingServiceImpl(pdfGenerator: sl()),
  );

  // Repositories
  sl.registerLazySingleton<PrintingRepository>(
    () => PrintingRepositoryImpl(
      pdfGenerator: sl(),
      printingService: sl(),
      logger: sl(),
    ),
  );
  // Use cases
  sl.registerLazySingleton<GenerateReceiptPdf>(() => GenerateReceiptPdf(sl()));
  
  sl.registerLazySingleton<GeneratePdfBytes>(() => GeneratePdfBytes(sl()));
  
  sl.registerLazySingleton<PrintReceipt>(() => PrintReceipt(sl()));
  
  sl.registerLazySingleton<SaveReceiptPdf>(() => SaveReceiptPdf(sl()));
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
