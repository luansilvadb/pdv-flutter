import 'package:connectivity_plus/connectivity_plus.dart';

/// Interface para verificar conectividade de rede
abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get connectivityStream;
}

/// Implementação do NetworkInfo usando connectivity_plus
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl({Connectivity? connectivity})
    : connectivity = connectivity ?? Connectivity();

  @override
  Future<bool> get isConnected async {
    final connectivityResult = await connectivity.checkConnectivity();
    return _isConnectedSingle(connectivityResult);
  }

  @override
  Stream<bool> get connectivityStream {
    return connectivity.onConnectivityChanged.map(_isConnectedSingle);
  }

  bool _isConnectedSingle(ConnectivityResult connectivityResult) {
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.ethernet ||
        connectivityResult == ConnectivityResult.vpn;
  }
}
