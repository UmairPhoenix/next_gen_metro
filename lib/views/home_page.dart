import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:next_gen_metro/utils/app_theme_data.dart';
import 'package:next_gen_metro/views/history_page.dart';
import 'package:next_gen_metro/views/nfc_scan_page.dart';
import 'package:next_gen_metro/views/profile_page.dart';
import 'package:next_gen_metro/views/route_info_page.dart';
import 'package:next_gen_metro/views/topup_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selected = 0;

  final _pages = const [
    TopupPage(),
    RouteInfoPage(),
    NfcScanPage(), // center NFC
    HistoryPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No app bar – each page can own its header
      extendBody: true, // lets the nav bar float with soft shadow
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 240),
        transitionBuilder: (child, anim) {
          final slide = Tween<Offset>(begin: const Offset(0.04, 0), end: Offset.zero)
              .animate(CurvedAnimation(parent: anim, curve: Curves.easeOut));
          final fade = CurvedAnimation(parent: anim, curve: Curves.easeOut);
          return SlideTransition(position: slide, child: FadeTransition(opacity: fade, child: child));
        },
        child: _pages[_selected],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 12.h),
        child: _FancyBottomBar(
          index: _selected,
          onChanged: (i) {
            if (i == _selected) return;
            HapticFeedback.selectionClick();
            setState(() => _selected = i);
          },
          items: const [
            _BarItem(icon: Icons.credit_card_rounded, label: 'Top-up'),
            _BarItem(icon: Icons.map_rounded, label: 'Routes'),
            _BarItem(icon: Icons.nfc_rounded, label: 'NFC', accent: true),
            _BarItem(icon: Icons.history_rounded, label: 'History'),
            _BarItem(icon: Icons.person_rounded, label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

/// Model for one nav item
class _BarItem {
  final IconData icon;
  final String label;
  final bool accent; // special styling for center NFC
  const _BarItem({required this.icon, required this.label, this.accent = false});
}

/// Beautiful, animated bottom bar
class _FancyBottomBar extends StatefulWidget {
  final int index;
  final ValueChanged<int> onChanged;
  final List<_BarItem> items;

  const _FancyBottomBar({
    required this.index,
    required this.onChanged,
    required this.items,
  });

  @override
  State<_FancyBottomBar> createState() => _FancyBottomBarState();
}

class _FancyBottomBarState extends State<_FancyBottomBar> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );

  @override
  void didUpdateWidget(covariant _FancyBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      _ctrl
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items;
    final count = items.length;
    final selected = widget.index;
    final totalWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 14, offset: Offset(0, 6)),
        ],
        border: Border.all(color: Colors.black12.withOpacity(0.06)),
      ),
      child: SizedBox(
        height: 72.h,
        child: Stack(
          children: [
            // Sliding pill indicator behind the active item
            AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              alignment: _alignmentForIndex(selected, count),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Container(
                  // inside padding & borders; clamp to avoid negative in ultra-small widths
                  width: ((totalWidth - 28.w) / count - 6.w).clamp(40.0, 160.0),
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: darkBrown.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: darkBrown.withOpacity(0.12)),
                  ),
                ),
              ),
            ),

            // Row of items
            Row(
              children: List.generate(count, (i) {
                final item = items[i];
                final isSelected = selected == i;
                final isAccent = item.accent;

                return Expanded(
                  child: _NavButton(
                    icon: item.icon,
                    label: item.label,
                    selected: isSelected,
                    accent: isAccent,
                    onTap: () => widget.onChanged(i),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Alignment _alignmentForIndex(int i, int total) {
    // Evenly split [-1, 1] into slots for the indicator
    final step = 2.0 / (total - 1);
    return Alignment(-1.0 + step * i, 0.0);
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final bool accent;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? darkBrown : Colors.black54;
    final accentColor = selected ? Colors.white : darkBrown;
    final accentBg = selected ? darkBrown : darkBrown.withOpacity(0.10);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // If the slot is narrow, fall back to icon-only to avoid overflow.
            final isNarrow = constraints.maxWidth < 72.w;

            if (accent) {
              // Center pill (NFC)
              if (isNarrow) {
                return Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: accentBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: accentColor),
                );
              }
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: accentBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                // FittedBox prevents tiny overflows at extreme sizes
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, color: accentColor),
                      SizedBox(width: 6.w),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          color: accentColor,
                          fontWeight: FontWeight.w800,
                          fontSize: selected ? 12.sp : 11.sp,
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            // leave room for icon and padding
                            maxWidth: constraints.maxWidth - 36.w,
                          ),
                          child: const Text(
                            'NFC',
                            softWrap: false,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Regular items
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color),
                SizedBox(height: 4.h),
                if (!isNarrow)
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      color: color,
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                      fontSize: 11.sp,
                    ),
                    child: Text(
                      label,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Safe image loader to avoid crashes on bad URLs (404, etc.)
class SafeNetworkImage extends StatelessWidget {
  final String url;
  final double? width, height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const SafeNetworkImage(
    this.url, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final img = Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => Container(
        width: width,
        height: height,
        color: Colors.black12,
        alignment: Alignment.center,
        child: const Icon(Icons.image_not_supported_rounded),
      ),
    );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: img);
    }
    return img;
  }
}
