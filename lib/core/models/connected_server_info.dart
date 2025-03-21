import 'dart:convert';

class ConnectedServerInfo {
  final int? id;
  final String? url;
  final String? country;
  final String? area;

  ConnectedServerInfo({
    required this.id,
    required this.url,
    required this.country,
    required this.area,
  });

  // Convert a ServerInfo object to a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'country': country,
      'area': area,
    };
  }

  // Convert a Map to a ServerInfo object.
  factory ConnectedServerInfo.fromMap(Map<String, dynamic> map) {
    return ConnectedServerInfo(
      id: map['id'] ?? '',
      url: map['url'] ?? '',
      country: map['country'] ?? '',
      area: map['area'] ?? '',
    );
  }

  // Convert to JSON string.
  String toJson() => json.encode(toMap());

  // Create from JSON string.
  factory ConnectedServerInfo.fromJson(String source) =>
      ConnectedServerInfo.fromMap(json.decode(source));
}
