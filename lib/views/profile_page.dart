import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // <-- Clipboard
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_gen_metro/utils/app_theme_data.dart';
import 'package:next_gen_metro/utils/data/current_user_data.dart';
import 'package:next_gen_metro/models/user_model.dart';
import 'package:next_gen_metro/services/api_service.dart';
import 'package:next_gen_metro/utils/app_routes.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _profile;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load(); // fire-and-forget
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final user = CurrentUserData.currentUser;
      if (user == null) {
        throw Exception('Not authenticated');
      }

      final me = await ApiService.getMe();
      _profile = me;
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _signOut() async {
    CurrentUserData.currentUser = null;
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, Routes.loginPage, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final fallback = CurrentUserData.currentUser ??
        UserModel(
          id: 'mock123',
          name: 'Mock User',
          email: 'mockuser@example.com',
          phone: '03001234567',
          balance: 500.0,
          nfcUid: null,
          isAdmin: false,
        );

    final name = (_profile?['name'] ?? fallback.name).toString();
    final email = (_profile?['email'] ?? fallback.email).toString();
    final phone = (_profile?['phone'] ?? fallback.phone).toString();
    final role = ((_profile?['role'] ?? (fallback.isAdmin ? 'admin' : 'user')) as String).toLowerCase();
    final nfcUid = (_profile?['nfcUid'] ?? fallback.nfcUid)?.toString();
    final balance = double.tryParse((_profile?['balance'] ?? fallback.balance).toString()) ?? 0.0;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _load,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 28.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(name: name, email: email),
              SizedBox(height: 16.h),
              _BalanceCard(amount: balance),
              SizedBox(height: 16.h),

              _InfoTile(label: "Phone Number", value: phone, icon: Icons.phone_rounded),
              _InfoTile(label: "Role", value: role == 'admin' ? 'Admin' : 'User', icon: Icons.verified_user),
              _InfoTile(label: "NFC UID", value: nfcUid ?? 'Not linked', icon: Icons.nfc, copyable: nfcUid != null),

              if (_error != null) ...[
                SizedBox(height: 14.h),
                _InlineError(message: _error!, onRetry: _load),
              ],

              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _load,
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: const Text("Refresh", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkBrown,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _signOut,
                  icon: const Icon(Icons.logout),
                  label: const Text("Sign Out"),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String name;
  final String email;
  const _Header({required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 34.r,
          backgroundColor: darkBrown.withOpacity(0.12),
          backgroundImage: const NetworkImage(
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTajhS11aUm5pvBqz6IwpVHtnv5uUL9EGUuFw&usqp=CAU',
          ),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: darkBrown),
              ),
              Text(email, style: TextStyle(fontSize: 13.sp, color: Colors.black54)),
            ],
          ),
        ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final double amount;
  const _BalanceCard({required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [darkBrown, darkBrown.withOpacity(0.85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 6))],
      ),
      child: Row(
        children: [
          const Icon(Icons.account_balance_wallet_rounded, color: Colors.white),
          SizedBox(width: 10.w),
          const Text("Balance", style: TextStyle(color: Colors.white70)),
          const Spacer(),
          Text(
            "Rs. ${amount.toStringAsFixed(0)}",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18.sp),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool copyable;
  const _InfoTile({required this.label, required this.value, required this.icon, this.copyable = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 10.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: darkBrown.withOpacity(0.1),
          child: Icon(icon, color: Colors.black87),
        ),
        title: Text(label, style: const TextStyle(color: Colors.black54)),
        subtitle: Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: copyable
            ? IconButton(
                tooltip: "Copy",
                icon: const Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: value));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied')));
                },
              )
            : null,
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _InlineError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          SizedBox(width: 8.w),
          Expanded(child: Text(message, maxLines: 3, overflow: TextOverflow.ellipsis)),
          TextButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh), label: const Text('Retry')),
        ],
      ),
    );
  }
}
