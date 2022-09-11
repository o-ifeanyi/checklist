import 'dart:async';

import 'package:checklist_app/interface/checklist_repository.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionService {
  final Connectivity connectivity;
  final ChecklistRepository checklistRepository;

  ConnectionService({
    required this.connectivity,
    required this.checklistRepository,
  }) {
    connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _connectivityStreamController.add(result);
      switch (result) {
        case ConnectivityResult.mobile:
        case ConnectivityResult.wifi:
          // sync data
          break;
        default:
      }
    });
  }

  final StreamController<ConnectivityResult> _connectivityStreamController =
      StreamController<ConnectivityResult>();

  Stream<ConnectivityResult> get stream => _connectivityStreamController.stream;

  void dispose() => _connectivityStreamController.close();
}
