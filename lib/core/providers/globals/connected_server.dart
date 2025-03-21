import 'dart:developer';
import 'package:flutter/foundation.dart';

import '../../models/connected_server_info.dart';
import '../../utils/preferences.dart';

class ConnectedServerProvider extends ChangeNotifier {
  ConnectedServerInfo? _connectedServerInfo;
  int? connectedServerId;

  // Public getter to access the connected server info
  ConnectedServerInfo? get connectedServerInfo => _connectedServerInfo;

  ConnectedServerProvider() {
    _initialize();
  }

  // Initialize method to load data when the provider is created
  Future<void> _initialize() async {
    await _loadConnectedServerInfo();
  }

  // Load connected server info from SharedPreferences
  Future<void> _loadConnectedServerInfo() async {
    try {
      Preferences.instance().then((value) async {
        _connectedServerInfo = await value.getConnectedServerInfo();
        connectedServerId = _connectedServerInfo?.id;
        notifyListeners();
      });
    } catch (e, stackTrace) {
      log("Error loading connected server info: $e", stackTrace: stackTrace);
    }
    notifyListeners();
  }

  // Save connected server info to SharedPreferences
  Future<void> saveConnectedServerInfo(ConnectedServerInfo newInfo) async {
    try {
      Preferences.instance().then((value) async {
        await value.saveConnectedServerInfo(newInfo);
        notifyListeners();
      });
      _connectedServerInfo = newInfo;
      connectedServerId = _connectedServerInfo?.id;
      notifyListeners();
    } catch (e, stackTrace) {
      log("Error saving connected server info: $e", stackTrace: stackTrace);
    }
  }

  // Refresh the connected server info by reloading it from SharedPreferences
  Future<void> refreshConnectedServerInfo() async {
    await _loadConnectedServerInfo();
  }

  // Delete connected server info from SharedPreferences
  Future<void> deleteConnectedServerInfo() async {
    try {
      Preferences.instance().then((value) async {
        await value.deleteConnectedServerInfo();
      });
      _connectedServerInfo = null;

      notifyListeners();
    } catch (e, stackTrace) {
      log("Error deleting connected server info: $e", stackTrace: stackTrace);
    }
  }

  invalidConnectedId() {
    connectedServerId = null;
    notifyListeners();
  }
}
