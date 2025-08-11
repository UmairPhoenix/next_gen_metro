import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with SingleTickerProviderStateMixin {
  // Mock data
  final List<Map<String, dynamic>> _allTrips = const [
    {
      'service': 'Metro',
      'entry': 'Gajju Mata',
      'exit': 'Kalma Chowk',
      'fare': 30,
      'date': 'May 25, 2025',
      'time': '8:15 AM',
      'id': 'T-0001',
    },
    {
      'service': 'Orange',
      'entry': 'Ali Town',
      'exit': 'Dera Gujran',
      'fare': 40,
      'date': 'May 24, 2025',
      'time': '5:45 PM',
      'id': 'T-0002',
    },
    {
      'service': 'Speedo',
      'entry': 'Railway Station',
      'exit': 'Samanabad Mor',
      'fare': 25,
      'date': 'May 23, 2025',
      'time': '3:30 PM',
      'id': 'T-0003',
    },
    {
      'service': 'Metro',
      'entry': 'Model Town',
      'exit': 'Lakshmi',
      'fare': 28,
      'date': 'May 22, 2025',
      'time': '9:10 AM',
      'id': 'T-0004',
    },
    {
      'service': 'Orange',
      'entry': 'Shahnoor',
      'exit': 'Salahuddin',
      'fare': 38,
      'date': 'May 21, 2025',
      'time': '7:55 PM',
      'id': 'T-0005',
    },
  ];

  String _selectedService = 'All';
  bool _sortDescending = true;

  late final AnimationController _controller;
  late final CurvedAnimation _listCurve;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _listCurve = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    // Kick off initial list animation slightly delayed for niceness
    Timer(const Duration(milliseconds: 80), () => _controller.forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredTrips {
    final base = _selectedService == 'All'
        ? List<Map<String, dynamic>>.from(_allTrips)
        : _allTrips.where((t) => t['service'] == _selectedService).toList();
    base.sort((a, b) =>
        (_sortDescending ? -1 : 1) *
        a['date'].toString().compareTo(b['date'].toString()));
    return base;
  }

  int get _totalSpent =>
      _filteredTrips.fold<int>(0, (s, t) => s + (t['fare'] as int));

  Color _serviceColor(String s) {
    switch (s) {
      case 'Metro':
        return const Color(0xFF8B5E3C); // warm brown
      case 'Orange':
        return const Color(0xFFFF8C3B); // orange
      case 'Speedo':
        return const Color(0xFF2CA4A4); // teal
      default:
        return Colors.blueGrey;
    }
  }

  IconData _serviceIcon(String s) {
    switch (s) {
      case 'Metro':
        return Icons.directions_subway_filled;
      case 'Orange':
        return Icons.directions_railway_filled;
      case 'Speedo':
        return Icons.directions_bus_filled_rounded;
      default:
        return Icons.directions_transit_filled;
    }
  }

  Future<void> _onRefresh() async {
    // Simulate a small refresh latency
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    // Re-animate list on refresh
    _controller
      ..reset()
      ..forward();
    setState(() {});
  }
  Widget _kv(String key, String value, {bool bold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            key,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.black54,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _openTripDetails(Map<String, dynamic> trip) {
    final color = _serviceColor(trip['service']);
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h + MediaQuery.of(ctx).padding.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: color.withOpacity(0.15)),
                ),
                padding: EdgeInsets.all(12.w),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: color.withOpacity(0.15),
                      child: Icon(_serviceIcon(trip['service']), color: color),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${trip['service']} Trip',
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: color)),
                          SizedBox(height: 4.h),
                          Text('${trip['date']} • ${trip['time']}',
                              style: TextStyle(fontSize: 12.sp, color: Colors.black54)),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text('Rs. ${trip['fare']}',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.sp)),
                    )
                  ],
                ),
              ),
              SizedBox(height: 14.h),
              Row(
                children: [
                  _dot(color),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text('Entry: ${trip['entry']}',
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  _dot(Colors.grey),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text('Exit: ${trip['exit']}',
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.black12.withOpacity(0.06)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Receipt',
                        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700)),
                    SizedBox(height: 8.h),
                    _kv('Transaction ID', trip['id']),
                    _kv('Base Fare', 'Rs. ${trip['fare']}'),
                    _kv('Taxes', 'Rs. 0'),
                    const Divider(height: 16),
                    _kv('Total', 'Rs. ${trip['fare']}', bold: true),
                  ],
                ),
              ),
              SizedBox(height: 14.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _showStubDialog(
                          title: 'Download receipt',
                          message:
                              'PDF export can be wired to your backend. For now this is a placeholder.',
                        );
                      },
                      icon: const Icon(Icons.download_rounded),
                      label: const Text('Download'),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _showDisputeDialog(trip);
                      },
                      icon: const Icon(Icons.report_rounded),
                      label: const Text('Dispute fare'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
            ],
          ),
        );
      },
    );
  }

  void _showStubDialog({required String title, required String message}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showDisputeDialog(Map<String, dynamic> trip) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Dispute fare'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Trip ${trip['id']} • ${trip['service']} • ${trip['date']} at ${trip['time']}',
              style: const TextStyle(color: Colors.black54),
            ),
            SizedBox(height: 10.h),
            TextField(
              controller: controller,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Describe the issue (charged incorrectly, station mismatch, etc.)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _showStubDialog(
                title: 'Submitted',
                message: 'Your dispute has been submitted. We’ll notify you of updates.',
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  Widget _dot(Color c) => Container(
        width: 10.w,
        height: 10.w,
        decoration: BoxDecoration(color: c, shape: BoxShape.circle),
      );

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredTrips;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip History'),
        actions: [
          IconButton(
            tooltip: _sortDescending ? 'Newest first' : 'Oldest first',
            onPressed: () => setState(() => _sortDescending = !_sortDescending),
            icon: Icon(_sortDescending ? Icons.sort_rounded : Icons.swap_vert_rounded),
          ),
          PopupMenuButton<String>(
            onSelected: (v) => setState(() => _selectedService = v),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'All', child: Text('All services')),
              PopupMenuItem(value: 'Metro', child: Text('Metro only')),
              PopupMenuItem(value: 'Orange', child: Text('Orange only')),
              PopupMenuItem(value: 'Speedo', child: Text('Speedo only')),
            ],
            icon: const Icon(Icons.filter_list_rounded),
          ),
          SizedBox(width: 6.w),
        ],
      ),
      body: Column(
        children: [
          // Top summary + chips
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 6.h),
            child: Row(
              children: [
                Expanded(
                  child: _SummaryTile(
                    title: 'Total Spent',
                    value: 'Rs. $_totalSpent',
                    icon: Icons.account_balance_wallet_rounded,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _SummaryTile(
                    title: 'Trips',
                    value: '${filtered.length}',
                    icon: Icons.local_activity_rounded,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 46.h,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(width: 4.w),
                _ServiceChip(
                  label: 'All',
                  selected: _selectedService == 'All',
                  color: Colors.blueGrey,
                  onTap: () => setState(() => _selectedService = 'All'),
                ),
                _ServiceChip(
                  label: 'Metro',
                  selected: _selectedService == 'Metro',
                  color: _serviceColor('Metro'),
                  onTap: () => setState(() => _selectedService = 'Metro'),
                ),
                _ServiceChip(
                  label: 'Orange',
                  selected: _selectedService == 'Orange',
                  color: _serviceColor('Orange'),
                  onTap: () => setState(() => _selectedService = 'Orange'),
                ),
                _ServiceChip(
                  label: 'Speedo',
                  selected: _selectedService == 'Speedo',
                  color: _serviceColor('Speedo'),
                  onTap: () => setState(() => _selectedService = 'Speedo'),
                ),
                SizedBox(width: 4.w),
              ],
            ),
          ),
          SizedBox(height: 6.h),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: filtered.isEmpty
                  ? ListView(
                      children: [
                        SizedBox(height: 60.h),
                        Icon(Icons.history_rounded, size: 64.sp, color: Colors.black26),
                        SizedBox(height: 12.h),
                        Center(
                          child: Text(
                            'No trips found',
                            style: TextStyle(fontSize: 15.sp, color: Colors.black54),
                          ),
                        ),
                      ],
                    )
                  : ListView.separated(
                      padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 20.h),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final trip = filtered[index];
                        final color = _serviceColor(trip['service']);

                        // Staggered entrance animation per item
                        final animation = Tween<double>(begin: 40, end: 0).animate(
                          CurvedAnimation(
                            parent: _listCurve,
                            curve: Interval(
                              (index / filtered.length) * 0.8,
                              1.0,
                              curve: Curves.easeOut,
                            ),
                          ),
                        );
                        final fade = Tween<double>(begin: 0, end: 1).animate(
                          CurvedAnimation(
                            parent: _listCurve,
                            curve: Interval(
                              (index / filtered.length) * 0.8,
                              1.0,
                              curve: Curves.easeOut,
                            ),
                          ),
                        );

                        return AnimatedBuilder(
                          animation: _controller,
                          builder: (_, child) => Opacity(
                            opacity: fade.value,
                            child: Transform.translate(
                              offset: Offset(0, animation.value),
                              child: child,
                            ),
                          ),
                          child: InkWell(
                            onTap: () => _openTripDetails(trip),
                            borderRadius: BorderRadius.circular(14.r),
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14.r),
                                  border: Border.all(
                                    color: color.withOpacity(0.15),
                                  ),
                                ),
                                padding: EdgeInsets.all(12.w),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 44.w,
                                      height: 44.w,
                                      decoration: BoxDecoration(
                                        color: color.withOpacity(0.12),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(_serviceIcon(trip['service']), color: color),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  '${trip['service']} Trip',
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.w, vertical: 6.h),
                                                decoration: BoxDecoration(
                                                  color: Colors.black.withOpacity(0.05),
                                                  borderRadius: BorderRadius.circular(999),
                                                ),
                                                child: Text(
                                                  'Rs. ${trip['fare']}',
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontWeight: FontWeight.w700),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 6.h),
                                          Row(
                                            children: [
                                              Icon(Icons.login_rounded,
                                                  size: 16.sp, color: color),
                                              SizedBox(width: 6.w),
                                              Expanded(
                                                child: Text(
                                                  '${trip['entry']}',
                                                  style: TextStyle(
                                                      fontSize: 13.sp,
                                                      fontWeight: FontWeight.w600),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(width: 10.w),
                                              Icon(Icons.logout_rounded,
                                                  size: 16.sp, color: Colors.grey),
                                              SizedBox(width: 6.w),
                                              Expanded(
                                                child: Text(
                                                  '${trip['exit']}',
                                                  style: TextStyle(
                                                      fontSize: 13.sp,
                                                      fontWeight: FontWeight.w600),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 6.h),
                                          Row(
                                            children: [
                                              Icon(Icons.calendar_today_rounded,
                                                  size: 14.sp, color: Colors.black45),
                                              SizedBox(width: 6.w),
                                              Text(
                                                '${trip['date']} • ${trip['time']}',
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Colors.black54),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  const _SummaryTile({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.black12.withOpacity(0.06)),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundColor: Colors.black.withOpacity(0.06),
            child: Icon(icon, color: Colors.black87),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(fontSize: 12.sp, color: Colors.black54, height: 1.1)),
                SizedBox(height: 2.h),
                Text(value, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;
  const _ServiceChip({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? color.withOpacity(0.15) : Colors.black.withOpacity(0.05);
    final fg = selected ? color : Colors.black87;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: fg.withOpacity(0.18)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.directions_transit_rounded, size: 16.sp, color: fg),
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyle(
                  color: fg,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
