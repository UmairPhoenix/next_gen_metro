import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_gen_metro/services/api_service.dart';
import 'package:next_gen_metro/utils/app_theme_data.dart';

class RouteInfoPage extends StatefulWidget {
  const RouteInfoPage({super.key});

  @override
  State<RouteInfoPage> createState() => _RouteInfoPageState();
}

class _RouteInfoPageState extends State<RouteInfoPage> with SingleTickerProviderStateMixin {
  final TextEditingController _search = TextEditingController();
  String _service = 'All';
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _routes = [];

  late final AnimationController _pulseCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
  )..repeat(reverse: true);
  late final Animation<double> _pulse =
      Tween<double>(begin: 0.98, end: 1.04).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _search.dispose();
    super.dispose();
  }

  Future<void> _fetch() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final list = await ApiService.fetchRoutes(); // expects [{id?, name, category, start, end}, ...]
      // Normalize to Map<String,dynamic>
      _routes = list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // UI helpers
  Color _catColor(String cat) {
    switch (cat.toLowerCase()) {
      case 'metro':
        return Colors.indigo;
      case 'speedo':
        return Colors.teal;
      case 'orange':
        return Colors.deepOrange;
      default:
        return darkBrown;
    }
  }

  IconData _catIcon(String cat) {
    switch (cat.toLowerCase()) {
      case 'metro':
        return Icons.directions_subway_filled_rounded;
      case 'speedo':
        return Icons.directions_bus_filled_rounded;
      case 'orange':
        return Icons.tram_rounded;
      default:
        return Icons.alt_route_rounded;
    }
  }

  List<Map<String, dynamic>> get _filtered {
    final q = _search.text.trim().toLowerCase();
    final s = _service.toLowerCase();
    final list = _routes;
    return list.where((r) {
      final cat = (r['category'] ?? '').toString();
      final name = (r['name'] ?? '').toString();
      final start = (r['start'] ?? '').toString();
      final end = (r['end'] ?? '').toString();

      final servicePass = (s == 'all') || cat.toLowerCase() == s;
      final searchPass = q.isEmpty ||
          name.toLowerCase().contains(q) ||
          start.toLowerCase().contains(q) ||
          end.toLowerCase().contains(q);

      return servicePass && searchPass;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _FancyAppBar(),
      body: RefreshIndicator(
        onRefresh: _fetch,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header summary
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
                    boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 6))],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.map_rounded, color: Colors.white),
                      SizedBox(width: 10.w),
                      const Text('Available Routes', style: TextStyle(color: Colors.white70)),
                      const Spacer(),
                      Text(
                        _routes.length.toString(),
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18.sp),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 14.h),

              // Service filter chips
              _ServiceChips(
                value: _service,
                onChanged: (v) => setState(() => _service = v),
              ),
              SizedBox(height: 10.h),

              // Search
              TextField(
                controller: _search,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search by name, start, or end…',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                ),
              ),
              SizedBox(height: 14.h),

              if (_loading)
                _SkeletonRoutes()
              else if (_error != null)
                _InlineError(message: _error!, onRetry: _fetch)
              else
                _RoutesList(
                  routes: _filtered,
                  catColor: _catColor,
                  catIcon: _catIcon,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------- AppBar --------------------
class _FancyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(64.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 64.h,
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: false,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [darkBrown, darkBrown.withOpacity(0.92)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(22),
            bottomRight: Radius.circular(22),
          ),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
        ),
      ),
      title: Row(
        children: [
          const Icon(Icons.route, color: Colors.white),
          SizedBox(width: 8.w),
          Text(
            'Route Information',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18.sp),
          ),
        ],
      ),
    );
  }
}

// -------------------- Service Chips --------------------
class _ServiceChips extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  const _ServiceChips({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final items = const ['All', 'Metro', 'Speedo', 'Orange'];
    return Wrap(
      spacing: 8.w,
      children: items.map((s) {
        final selected = value == s;
        return ChoiceChip(
          label: Text(s),
          selected: selected,
          onSelected: (_) => onChanged(s),
          selectedColor: Colors.black.withOpacity(0.06),
          side: BorderSide(color: selected ? darkBrown : Colors.black12),
          labelStyle: TextStyle(
            color: selected ? darkBrown : Colors.black87,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        );
      }).toList(),
    );
  }
}

// -------------------- Routes List --------------------
class _RoutesList extends StatelessWidget {
  final List<Map<String, dynamic>> routes;
  final Color Function(String) catColor;
  final IconData Function(String) catIcon;
  const _RoutesList({
    required this.routes,
    required this.catColor,
    required this.catIcon,
  });

  @override
  Widget build(BuildContext context) {
    if (routes.isEmpty) {
      return _EmptyState(
        icon: Icons.info_outline,
        title: "No routes found",
        subtitle: "Try changing the service filter or clearing the search.",
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: routes.length,
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemBuilder: (context, index) {
        final r = routes[index];
        final name = (r['name'] ?? '').toString();
        final category = (r['category'] ?? '').toString();
        final start = (r['start'] ?? '').toString();
        final end = (r['end'] ?? '').toString();

        final color = catColor(category);
        final icon = catIcon(category);

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              // Future: push to route detail page if you add stops/timings
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Selected: $name')),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: color.withOpacity(0.12),
                        child: Icon(icon, color: color),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          name.isEmpty ? 'Unnamed Route' : name,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                      _CategoryChip(label: category.isEmpty ? 'Unknown' : category, color: color),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.circle, size: 10, color: color),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          start.isEmpty ? 'Unknown start' : start,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black45),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            end.isEmpty ? 'Unknown end' : end,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  // Small hint
                  Text(
                    "Tap for more",
                    style: TextStyle(fontSize: 12.sp, color: Colors.black45),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final Color color;
  const _CategoryChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

// -------------------- States --------------------
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

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _EmptyState({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Column(
        children: [
          Icon(icon, size: 44, color: Colors.black26),
          SizedBox(height: 8.h),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          SizedBox(height: 4.h),
          Text(subtitle, style: const TextStyle(color: Colors.black54), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _SkeletonRoutes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        4,
        (i) => Container(
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.035),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(40))),
                  SizedBox(width: 10.w),
                  Expanded(child: Container(height: 14, color: Colors.black12)),
                  SizedBox(width: 10.w),
                  Container(width: 70, height: 20, color: Colors.black12),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(child: Container(height: 12, color: Colors.black12)),
                  SizedBox(width: 10.w),
                  Expanded(child: Container(height: 12, color: Colors.black12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
