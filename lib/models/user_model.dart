class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final double balance;
  final String? nfcUid;
  final bool isAdmin;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.balance,
    this.nfcUid,
    this.isAdmin = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'balance': balance,
      'nfcUid': nfcUid,
      'isAdmin': isAdmin,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
      nfcUid: json['nfc_uid']?.toString(),
      isAdmin: (json['role'] ?? '') == 'admin',
    );
  }
}
