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
      // only act on new data if it's different from previous data
      if (result != _connectivityResult) {
        _connectivityStreamController.add(result);
      }
      switch (result) {
        case ConnectivityResult.mobile:
        case ConnectivityResult.wifi:
          if (result != _connectivityResult) {
            sl<ChecklistProvider>().sync();
          }
          break;
        default:
      }
      // set previous data to new data
      _connectivityResult = result;
    });
  }

  final StreamController<ConnectivityResult> _connectivityStreamController =
      StreamController<ConnectivityResult>();

  Stream<ConnectivityResult> get stream => _connectivityStreamController.stream;

  void dispose() => _connectivityStreamController.close();
}
