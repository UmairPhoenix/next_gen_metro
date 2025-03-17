import 'package:next_gen_metro/models/route_history_model.dart';

class UserModel {
  final String userName;
  final String userEmail;
  final String userId;
  final String phoneNumber;
  final List<RouteHistoryModel> routeHistory;
  final double balance;

  UserModel({
    required this.userName,
    required this.userEmail,
    required this.userId,
    required this.phoneNumber,
    this.routeHistory = const [],
    this.balance = 0.0,
  });

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'userEmail': userEmail,
      'userId': userId,
      'phoneNumber': phoneNumber,
      'routeHistory': routeHistory.map((history) => history.toJson()).toList(),
      'balance': balance,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userName: json['userName'] as String,
      userEmail: json['userEmail'] as String,
      userId: json['userId'] as String,
      phoneNumber: json['phoneNumber'] as String,
      routeHistory: (json['routeHistory'] as List? ?? [])
          .map((item) => RouteHistoryModel.fromJson(item))
          .toList(),
      balance: (json['balance'] ?? 0.0) as double,
    );
  }

  get profilePicture => null;
}
