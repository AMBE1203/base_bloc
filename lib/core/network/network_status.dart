import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkStatus {
  Future<bool> get isConnected;
}

class NetworkStatusImpl implements NetworkStatus {
  Connectivity connectivity;
  bool _isConnectToNetwork = true;
  NetworkStatusImpl(this.connectivity) {
    connectivity.onConnectivityChanged.listen((event) {
      _isConnectToNetwork = (event != ConnectivityResult.none);
    });
  }

  @override
  Future<bool> get isConnected async {
    return _isConnectToNetwork;
  }
}
