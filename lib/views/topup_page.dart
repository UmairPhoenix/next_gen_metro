import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_gen_metro/utils/app_theme_data.dart';
import 'package:next_gen_metro/utils/data/current_user_data.dart';

import 'package:next_gen_metro/services/api_service.dart';

class TopupPage extends StatefulWidget {
  const TopupPage({super.key});

  @override
  State<TopupPage> createState() => _TopupPageState();
}

class _TopupPageState extends State<TopupPage> with SingleTickerProviderStateMixin {
  final TextEditingController _amountController = TextEditingController();
  String _selectedMethod = 'JazzCash'; // Only supported for now
  bool _isSubmitting = false;

  // Cute header pulse
  late final AnimationController _pulseCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
  )..repeat(reverse: true);

  late final Animation<double> _pulse =
      Tween<double>(begin: 0.98, end: 1.04).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _amountController.dispose();
    super.dispose();
  }

  double get _currentBalance =>
      (CurrentUserData.currentUser?.balance ?? 0).toDouble();

  Future<void> _submit() async {
    if (_isSubmitting) return;

    // Validate
    final raw = _amountController.text.trim();
    if (raw.isEmpty) {
      _snack('Please enter an amount.');
      return;
    }
    final amount = int.tryParse(raw);
    if (amount == null || amount <= 0) {
      _snack('Enter a valid amount greater than 0.');
      return;
    }
    if (_selectedMethod != 'JazzCash') {
      _snack('Only JazzCash is supported right now.');
      return;
    }

    // Confirm UI
    final ok = await _confirmSheet(amount);
    if (ok != true) return;

    setState(() => _isSubmitting = true);
    try {
      final uid = int.tryParse(CurrentUserData.currentUser?.id ?? '') ?? -1;
      if (uid <= 0) {
        throw Exception('Your account ID is invalid. Please re-login.');
      }

      // Call backend
      await ApiService.topupJazzcash(uid: uid, amount: amount);

      // (Optional) Optimistic local balance update
      final u = CurrentUserData.currentUser;
      if (u != null) {
        final newBal = (u.balance + amount).toDouble();
        CurrentUserData.currentUser =
            u.copyWith(balance: newBal); // make sure your model has copyWith; if not, skip
      }

      await _resultDialog(
        success: true,
        title: 'Top-up Successful',
        message: 'Rs. $amount has been added via JazzCash.',
      );
      _amountController.clear();
      setState(() {}); // refresh balance display
    } catch (e) {
      await _resultDialog(
        success: false,
        title: 'Top-up Failed',
        message: e.toString(),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<bool?> _confirmSheet(int amount) {
    return showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.payments_rounded, size: 44, color: darkBrown),
              SizedBox(height: 6.h),
              Text('Confirm Top-up', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800)),
              SizedBox(height: 6.h),
              Text(
                'You’re about to add Rs. $amount via JazzCash.',
                style: const TextStyle(color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(backgroundColor: darkBrown),
                      onPressed: () => Navigator.pop(context, true),
                      icon: const Icon(Icons.check),
                      label: const Text('Confirm', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _resultDialog({
    required bool success,
    required String title,
    required String message,
  }) async {
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(success ? Icons.check_circle : Icons.error, color: success ? Colors.green : Colors.red),
            const SizedBox(width: 8),
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800))),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _quickAmount(int v) {
    _amountController.text = v.toString();
    HapticFeedback.selectionClick();
    setState(() {}); // for button highlight
  }

  @override
  Widget build(BuildContext context) {
    final amountText = _amountController.text.trim();
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            ScaleTransition(
              scale: _pulse,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [darkBrown, darkBrown.withOpacity(0.9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 6)),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.account_balance_wallet_rounded, color: Colors.white),
                    SizedBox(width: 10.w),
                    const Text('Current Balance', style: TextStyle(color: Colors.white70)),
                    const Spacer(),
                    Text(
                      'Rs. ${_currentBalance.toStringAsFixed(0)}',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18.sp),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),

            Text('Amount', style: TextStyle(fontSize: 14.sp, color: Colors.black54)),
            SizedBox(height: 6.h),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: "e.g. 500",
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                  child: Text(
                    "PKR",
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
                  ),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (_) => setState(() {}),
            ),
            SizedBox(height: 10.h),

            // Quick amounts
            Wrap(
              spacing: 10.w,
              children: [200, 500, 1000, 2000].map((v) {
                final selected = amountText == v.toString();
                return ChoiceChip(
                  label: Text('Rs. $v'),
                  selected: selected,
                  onSelected: (_) => _quickAmount(v),
                  selectedColor: darkBrown.withOpacity(0.12),
                  side: BorderSide(color: selected ? darkBrown : Colors.black12),
                  labelStyle: TextStyle(
                    color: selected ? darkBrown : Colors.black87,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 18.h),
            Text('Select Payment Method', style: TextStyle(fontSize: 14.sp, color: Colors.black54)),
            SizedBox(height: 8.h),

            _MethodTile(
              title: 'JazzCash',
              subtitle: 'Pay instantly with JazzCash',
              icon: Icons.account_balance_rounded,
              selected: _selectedMethod == 'JazzCash',
              onTap: () => setState(() => _selectedMethod = 'JazzCash'),
            ),
            SizedBox(height: 8.h),
            _MethodTile(
              title: 'EasyPaisa',
              subtitle: 'Coming soon',
              icon: Icons.account_balance_wallet_outlined,
              selected: _selectedMethod == 'EasyPaisa',
              onTap: null, // disabled
              disabled: true,
            ),

            SizedBox(height: 26.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _submit,
                icon: _isSubmitting
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.flash_on, color: Colors.white),
                label: Text(
                  _isSubmitting ? 'Processing…' : 'Top Up Now',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkBrown,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MethodTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final bool disabled;
  final VoidCallback? onTap;

  const _MethodTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    this.disabled = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Card(
      elevation: selected ? 3 : 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: disabled ? null : onTap,
        leading: CircleAvatar(
          backgroundColor: Colors.black.withOpacity(0.06),
          child: Icon(icon, color: Colors.black87),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w700, color: disabled ? Colors.black45 : null)),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: disabled ? Colors.black38 : Colors.black54),
        ),
        trailing: selected
            ? const Icon(Icons.check_circle, color: Colors.green)
            : disabled
                ? const Icon(Icons.lock, color: Colors.black26)
                : const Icon(Icons.radio_button_unchecked, color: Colors.black26),
      ),
    );

    return Opacity(opacity: disabled ? 0.8 : 1, child: card);
  }
}
