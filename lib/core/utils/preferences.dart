import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/connected_server_info.dart';
import '../models/vpn_config.dart';

class Preferences {
  final SharedPreferences shared;

  Preferences(this.shared);

  set token(String? value) => shared.setString("token", value!);

  String? get token => shared.getString("token");

  static Future<Preferences> instance() =>
      SharedPreferences.getInstance().then((value) => Preferences(value));

  void saveServers({required List<VpnConfig> value}) {
    final jsonString = jsonEncode(value.map((e) => e.toJson()).toList());
    debugPrint('Saving server list: $jsonString'); // Debugging
    shared.setString("server_cache", jsonString);
  }

  // for the selected server
  void saveSelectedServers(VpnConfig? value) {
    if (value != null) {
      final jsonString = jsonEncode(value.toJson());
      shared.setString("selected_server_cache", jsonString);
      debugPrint('Saved data: $jsonString');
    } else {
      debugPrint('Null value on saving the saved connected server');
    }
  }

  VpnConfig? loadSavedServers() {
    var data = shared.getString("selected_server_cache");
    debugPrint('Loaded data from preferences: $data');
    if (data != null) {
      return VpnConfig.fromJson(jsonDecode(data) as Map<String, dynamic>);
    }
    debugPrint('No data found, returning null');
    return null;
  }

  removeSavedServer() {
    shared.remove('selected_server_cache');
    return;
  }

  /// new method
  Future<void> saveConnectedServerInfo(
      ConnectedServerInfo connectedServerInfo) async {
    deleteConnectedServerInfo();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('server_info', connectedServerInfo.toJson());
  }

  Future<ConnectedServerInfo?> getConnectedServerInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('server_info');

    if (jsonString != null) {
      return ConnectedServerInfo.fromJson(jsonString);
    }
    return null;
  }

  Future<void> deleteConnectedServerInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(
        'server_info'); // Removes the stored data for the key 'server_info'
  }

  /// new Method
  // for the selected server
  void setServer(VpnConfig? value) {
    if (value == null) {
      shared.remove("server");
      return;
    }
    shared.setString("server", jsonEncode(value.toJson()));
  }

  VpnConfig? getServer() {
    final server = shared.getString("server");
    if (server != null) {
      return VpnConfig.fromJson(jsonDecode(server));
    }
    return null;
  }

  List<VpnConfig> loadServers() {
    var data = shared.getString("server_cache");
    if (data != null) {
      return (jsonDecode(data) as List)
          .map((e) => VpnConfig.fromJson(e))
          .toList();
    }
    return [];
  }

  // Methods for Terms and condition
  Future<void> setTermsAccepted(bool accepted) async {
    await shared.setBool("terms_accepted", accepted);
  }

  bool isTermsAccepted() {
    return shared.getBool("terms_accepted") ?? false;
  }

  Future<void> removeTermsAccepted() async {
    await shared.remove("terms_accepted");
  }
}
