import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:openvpn_flutter/openvpn_flutter.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/connected_server_info.dart';
import '../../models/vpn_config.dart';
import '../../resources/environment.dart';
import '../../utils/preferences.dart';

class VpnProvider extends ChangeNotifier {
  VPNStage? vpnStage;
  VpnStatus? vpnStatus;
  VpnConfig? _vpnConfig;

  VpnConfig? get vpnConfig => _vpnConfig;
  final SupabaseClient client = Supabase.instance.client;

  set vpnConfig(VpnConfig? value) {
    _vpnConfig = value;
    Preferences.instance().then((prefs) {
      prefs.setServer(value);
    });
    notifyListeners();
  }

  ///VPN engine
  late OpenVPN engine;

  ///Check if VPN is connected
  bool get isConnected => vpnStage == VPNStage.connected;

  ///Initialize VPN engine and load last server
  void initialize(BuildContext context) {
    engine = OpenVPN(
        onVpnStageChanged: onVpnStageChanged,
        onVpnStatusChanged: onVpnStatusChanged)
      ..initialize(
        lastStatus: onVpnStatusChanged,
        lastStage: (stage) => onVpnStageChanged(stage, stage.name),
        groupIdentifier: groupIdentifier,
        localizedDescription: localizationDescription,
        providerBundleIdentifier: providerBundleIdentifier,
      );
  }

  /// VPN status changed
  void onVpnStatusChanged(VpnStatus? status) {
    vpnStatus = status;

    notifyListeners();
  }

  ///VPN stage changed
  void onVpnStageChanged(VPNStage stage, String rawStage) {
    vpnStage = stage;
    if (stage == VPNStage.error) {
      Future.delayed(const Duration(seconds: 3)).then((value) {
        vpnStage = VPNStage.disconnected;
      });
    }

    notifyListeners();
  }

  ///Connect to VPN server
  void connect() async {
    // log("${vpnConfig?.config}");
    String? config;
    // try {
    //   // config = await OpenVPN.filteredConfig(vpnConfig?.config);
    // } catch (e) {
    //   config = vpnConfig?.config;
    // }
    // if (config == null) return;
    final response = await client.from('server_auth').select();

    config = '''
    ${vpnConfig?.config ?? ''}
     ''';

    log('Data fetched: $response');
    // log('VPN Config: ${vpnConfig!.config}');
    log(config);

    engine.connect(
      config,
      vpnConfig!.country ?? '',
      certIsRequired: false,
      username: response[0]['username'],
      password: response[0]['password'],
    );

    // saving the saved server to shared preference
    Preferences.instance().then((value) async {
      // value.removeSavedServer();
      value.saveSelectedServers(_vpnConfig);
      // debugPrint(value.loadSavedServers()!.country.toString());

      notifyListeners();
    });
  }

  ///Select server from list
  Future<VpnConfig?> selectServer(
      BuildContext context, VpnConfig config) async {
    // return ServersHttp(context)
    //     .serverDetail(config.area ?? '')
    //     .showCustomProgressDialog(context)
    //     .then((value) {
    //   if (value != null) {
    //     vpnConfig = value;
    //     notifyListeners();
    //     return value;
    //   }
    //   return null;
    vpnConfig = config;
    Preferences.instance().then((value) async {});
    notifyListeners();
    return vpnConfig;
  }

  ///Disconnect from VPN server if connected
  void disconnect() {
    engine.disconnect();
  }

  static VpnProvider watch(BuildContext context) => context.watch();

  static VpnProvider read(BuildContext context) => context.read();
}
