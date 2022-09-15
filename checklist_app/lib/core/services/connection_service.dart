import 'dart:async';

import 'package:checklist_app/injection_container.dart';
import 'package:checklist_app/interface/checklist_repository.dart';
import 'package:checklist_app/provider/checklist_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionService {
  final Connectivity connectivity;
  final ChecklistRepository checklistRepository;
  ConnectivityResult _connectivityResult = ConnectivityResult.none;

  ConnectionService({
    required this.connectivity,
    required this.checklistRepository,
  }) {
    connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != _connectivityResult) {
        _connectivityStreamController.add(result);
        _connectivityResult = result;
      }
      switch (result) {
        case ConnectivityResult.mobile:
        case ConnectivityResult.wifi:
          sl<ChecklistProvider>().sync();
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
