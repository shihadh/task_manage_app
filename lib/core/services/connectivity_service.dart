import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionStatusController =
      StreamController<bool>.broadcast();

  Stream<bool> get connectionStatus => _connectionStatusController.stream;

  ConnectivityService() {
    _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      _connectionStatusController.add(
        !results.contains(ConnectivityResult.none),
      );
    });
    checkConnection();
  }

  Future<bool> checkConnection() async {
    final results = await _connectivity.checkConnectivity();
    final isConnected = !results.contains(ConnectivityResult.none);
    _connectionStatusController.add(isConnected);
    return isConnected;
  }
}
