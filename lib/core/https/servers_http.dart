import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'package:path_provider/path_provider.dart';

import '../models/ip_detail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/vpn_config.dart';
import 'http_connection.dart';

class ServersHttp extends HttpConnection {
  /// All servers request api
  ServersHttp(super.context);

  final SupabaseClient client = Supabase.instance.client;

  /// Get all servers from backend
  Future<List<VpnConfig>> allServers() async {
    // ApiResponse<List> resp =
    //     await get<List>("api/iphone/", pure: true, printDebug: true);
    // final Dio dio = Dio();
    // final resp = await dio.get("http://www.vpngate.net/api/iphone/");

    try {
      final response = await client
          .from('server_details')
          .select()
          .order('id', ascending: true);

      // Assuming your data is returned as a List
      // final List<VpnConfig> data = response as List<VpnConfig>;
      // response.map((json) => VpnConfig.fromJson(json)).toList();
      // log('Data fetched: ${jsonEncode(response)}');
      return response.map((json) => VpnConfig.fromJson(json)).toList();
    } catch (error) {
      debugPrint(error.toString());
    }

    // log('---------------------------------------------------');
    // // log(resp.data.toString());
    // final csvString = resp.data.toString().split("#")[1].replaceAll('*', '');
    // List<List<dynamic>> list = const CsvToListConverter().convert(csvString);
    // final header = list[0];
    //
    // // Create a list to hold each row's JSON object
    // List<Map<dynamic, dynamic>> allRows = [];
    //
    // for (int row = 1; row < list.length; ++row) {
    //   final tempJson = {};
    //
    //   // Map header to the respective columns in each row
    //   for (int i = 0; i < header.length; ++i) {
    //     tempJson[header[i]] = list[row][i];
    //   }
    //
    //   // Add the row's JSON object to the list
    //   allRows.add(tempJson);
    //   debugPrint(jsonEncode(tempJson)); // Print each row for verification
    // }
    //
    // // Save all rows at once as a JSON array
    // await saveJsonToFile(allRows);
    // if (resp.success ?? false) {
    //   return resp.data!.map<VpnConfig>((e) => VpnConfig.fromJson(e)).toList();
    // }
    return [];
  }

  /// Get all free servers from backend
  Future<List<VpnConfig>> allFree() async {
    ApiResponse<List> resp = await get<List>("allservers/free");
    if (resp.success ?? false) {
      return resp.data!.map<VpnConfig>((e) => VpnConfig.fromJson(e)).toList();
    }
    return [];
  }

  ///Get all pro servers from backend
  Future<List<VpnConfig>> allPro() async {
    ApiResponse<List> resp = await get<List>("allservers/pro");
    if (resp.success ?? false) {
      return resp.data!.map<VpnConfig>((e) => VpnConfig.fromJson(e)).toList();
    }
    return [];
  }

  ///Randomly get server
  Future<VpnConfig?> random() async {
    ApiResponse<Map<String, dynamic>> resp =
        await get<Map<String, dynamic>>("detail/random");
    if (resp.success ?? false) {
      return VpnConfig.fromJson(resp.data!);
    }
    return null;
  }

  ///Fetch server's detail by slug
  Future<VpnConfig?> serverDetail(String slug) async {
    ApiResponse<Map<String, dynamic>> resp =
        await get<Map<String, dynamic>>("detail/$slug");
    if (resp.success ?? false) {
      return VpnConfig.fromJson(resp.data!);
    }
    return null;
  }

  /// Get IP informations
  Future<IpDetail?> getPublicIP() async {
    var resp = await get("https://myip.wtf/json", pure: true);
    return resp != null ? IpDetail.fromJson(resp) : null;
  }
}

