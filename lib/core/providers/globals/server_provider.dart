import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../https/servers_http.dart';
import '../../models/vpn_config.dart';

/// Provider class for managing the server list
class ServerProvider extends ChangeNotifier {
  List<VpnConfig> _servers = [];
  List<VpnConfig> _filteredServers = [];
  bool _isLoading = true;
  String _searchQuery = '';

  List<VpnConfig> get servers => _servers;

  List<VpnConfig> get filteredServers => _filteredServers;

  bool get isLoading => _isLoading;

  String get searchQuery => _searchQuery;

  ServerProvider(BuildContext context) {
    _loadServers(context);
  }

  /// Load servers from cache or API
  Future<void> _loadServers(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString("server_cache");

    if (cachedData != null) {
      try {
        _servers = (jsonDecode(cachedData) as List)
            .map((e) => VpnConfig.fromJson(e))
            .toList();
        _filteredServers = _servers;
      } catch (e) {
        debugPrint('Error decoding cached servers: $e');
      }
    } else {
      await fetchServers(context);
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Fetch servers from API and update cache
  Future<void> fetchServers(BuildContext context) async {
    try {
      List<VpnConfig> fetchedServers = await ServersHttp(context).allServers();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("server_cache",
          jsonEncode(fetchedServers.map((e) => e.toJson()).toList()));

      _servers = fetchedServers;
      _filteredServers = fetchedServers;
    } catch (e) {
      debugPrint('Error fetching servers: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  /// Update search query and filter servers
  void updateSearchQuery(String query) {
    _searchQuery = query;
    _filteredServers = _servers
        .where((server) =>
            server.country!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }
}
