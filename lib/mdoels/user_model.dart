class UserModel {
  final String userName;
  final String userEmail;
  final String userId;
  UserModel({
    required this.userName,
    required this.userEmail,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'userEmail': userEmail,
      'userId': userId,
    };
  }

  UserModel.fromJson(Map<String, dynamic> json)
      : this(
          userName: json['userName'] as String,
          userEmail: json['userEmail'] as String,
          userId: json['userId'] as String,
        );
}
