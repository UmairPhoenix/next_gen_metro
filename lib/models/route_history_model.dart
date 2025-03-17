class RouteHistoryModel {
  final String routeId;
  final DateTime timestamp;
  final double fare;

  RouteHistoryModel({
    required this.routeId,
    required this.timestamp,
    required this.fare,
  });

  Map<String, dynamic> toJson() {
    return {
      'routeId': routeId,
      'timestamp': timestamp.toIso8601String(),
      'fare': fare,
    };
  }

  factory RouteHistoryModel.fromJson(Map<String, dynamic> json) {
    return RouteHistoryModel(
      routeId: json['routeId'] as String,
      timestamp: DateTime.parse(json['timestamp']),
      fare: (json['fare'] ?? 0.0) as double,
    );
  }
}
