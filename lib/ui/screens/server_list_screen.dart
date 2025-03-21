import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../core/https/servers_http.dart';
import '../../core/models/vpn_config.dart';
import '../../core/resources/colors.dart';
import '../../core/resources/environment.dart';
import '../../core/utils/preferences.dart';
import '../components/server_item.dart';

/// Server list screen
class ServerListScreen extends StatefulWidget {
  const ServerListScreen({super.key});

  @override
  State<ServerListScreen> createState() => _ServerListScreenState();
}

class _ServerListScreenState extends State<ServerListScreen> {
  final List<RefreshController> _refreshControllers = List.generate(
      2, (index) => RefreshController(initialRefresh: !cacheServerList));
  List<VpnConfig> _servers = [];
  List<VpnConfig> _filteredServers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (cacheServerList) {
        Preferences.instance().then((value) {
          if (value.loadServers().isNotEmpty && mounted) {
            setState(() {
              loadData();
              _servers = value.loadServers();
              _filteredServers = _servers;
            });
          } else {
            loadData();
          }
        });
      } else {
        loadData();
      }
    });
  }

  @override
  void dispose() {
    for (var element in _refreshControllers) {
      element.dispose();
    }
    _searchController.dispose();
    super.dispose();
  }

  /// Update search query and filter servers by both city and country
  void _updateSearchQuery(String query) {
    setState(() {
      _filteredServers = _servers.where((server) {
        final areaMatch =
        (server.area ?? '').toLowerCase().contains(query.toLowerCase());
        final countryMatch =
        (server.country ?? '').toLowerCase().contains(query.toLowerCase());
        return areaMatch || countryMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final FocusNode focus = FocusNode();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        focus.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: Text('server_list'.tr())),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                decoration: BoxDecoration(
                    color: isDarkMode ? backgroundDark : Colors.white,
                    borderRadius: BorderRadius.circular(16)),
                child: TextField(
                  focusNode: focus,
                  controller: _searchController,
                  onChanged: _updateSearchQuery,
                  decoration: InputDecoration(
                    hintText: 'search_server'.tr(),
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SmartRefresher(
                onRefresh: loadData,
                controller: _refreshControllers[0],
                child: SingleChildScrollView(  // Ensure the content is scrollable
                  child: Column(
                    children: [
                      // List of servers with filtering applied
                      _filteredServers.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                        shrinkWrap: true, // Makes ListView scrollable within the parent Column
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _filteredServers.length,
                        itemBuilder: (context, index) {
                          return ServerItem(_filteredServers[index]);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void loadData() async {
    List<VpnConfig> resp =
    await ServersHttp(context).allServers().then((value) {
      for (var element in _refreshControllers) {
        element.refreshCompleted();
        element.loadComplete();
      }
      if (cacheServerList) {
        Preferences.instance().then((pref) {
          pref.saveServers(value: value);
        });
      }
      return value;
    }).catchError((e) {
      for (var element in _refreshControllers) {
        element.refreshFailed();
      }
      return <VpnConfig>[];  // Return an empty list on error
    });

    if (mounted) {
      setState(() {
        _servers = resp;
        _filteredServers = _servers;  // Initially show all servers
      });
    }
  }
}
