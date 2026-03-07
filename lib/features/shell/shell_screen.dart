import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/tokens.dart';

/// Breakpoint above which we use side-rail layout instead of bottom bar
const _kWideBreak = 720.0;
/// Maximum content width (centered on large screens)
const _kMaxContent = 600.0;

class ShellScreen extends ConsumerWidget {
  final Widget child;
  const ShellScreen({super.key, required this.child});

  static int _indexFor(String location) {
    if (location.startsWith('/settings')) return 2;
    if (location.startsWith('/conversation')) return 1;
    return 0; // /home
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
      case 1:
        // Go to first contact's conversation as placeholder, or just home
        context.go('/home');
      case 2:
        context.go('/settings');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.path;
    final selectedIndex = _indexFor(location);
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= _kWideBreak;
    final c = context.hue;

    final items = <_NavItem>[
      _NavItem(icon: Icons.people_outline, activeIcon: Icons.people, label: 'Kişiler'),
      _NavItem(icon: Icons.chat_bubble_outline, activeIcon: Icons.chat_bubble, label: 'Sohbet'),
      _NavItem(icon: Icons.settings_outlined, activeIcon: Icons.settings, label: 'Ayarlar'),
    ];

    if (isWide) {
      // ── WIDE: rail on the left ───────────────────────────────────────
      return Scaffold(
        backgroundColor: c.bgPrimary,
        body: Row(
          children: [
            NavigationRail(
              backgroundColor: c.bgSecondary,
              selectedIndex: selectedIndex,
              onDestinationSelected: (i) => _onTap(context, i),
              labelType: NavigationRailLabelType.all,
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: _HueLogo(),
              ),
              selectedIconTheme: const IconThemeData(color: Color(0xFFFF8C42)),
              selectedLabelTextStyle: const TextStyle(
                color: Color(0xFFFF8C42),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              unselectedIconTheme: IconThemeData(color: c.textSecondary),
              unselectedLabelTextStyle: TextStyle(
                color: c.textSecondary,
                fontSize: 11,
              ),
              destinations: items
                  .map((i) => NavigationRailDestination(
                        icon: Icon(i.icon),
                        selectedIcon: Icon(i.activeIcon),
                        label: Text(i.label),
                      ))
                  .toList(),
            ),
            VerticalDivider(color: c.borderSubtle, width: 1),
            // Content centered with max width
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _kMaxContent),
                  child: child,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // ── NARROW: bottom nav bar ───────────────────────────────────────
    return Scaffold(
      backgroundColor: c.bgPrimary,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _kMaxContent),
          child: child,
        ),
      ),
      bottomNavigationBar: _HueBottomNav(
        selectedIndex: selectedIndex,
        items: items,
        onTap: (i) => _onTap(context, i),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// HUE LOGO
// ──────────────────────────────────────────────────────────────

class _HueLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Color(0xFFFF8C42), Color(0xFF6C3483)],
      ).createShader(bounds),
      child: const Text(
        'hue',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          color: Colors.white,
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// BOTTOM NAV BAR
// ──────────────────────────────────────────────────────────────

class _HueBottomNav extends StatelessWidget {
  final int selectedIndex;
  final List<_NavItem> items;
  final ValueChanged<int> onTap;

  const _HueBottomNav({
    required this.selectedIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.hue;
    return Container(
      decoration: BoxDecoration(
        color: c.bgSecondary,
        border: Border(top: BorderSide(color: c.borderSubtle, width: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            children: List.generate(items.length, (i) {
              final item = items[i];
              final isSelected = i == selectedIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            isSelected ? item.activeIcon : item.icon,
                            key: ValueKey(isSelected),
                            color: isSelected
                                ? const Color(0xFFFF8C42)
                                : c.textSecondary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(height: 3),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: isSelected
                                ? const Color(0xFFFF8C42)
                                : c.textSecondary,
                          ),
                          child: Text(item.label),
                        ),
                        // Active indicator
                        const SizedBox(height: 2),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: isSelected ? 18 : 0,
                          height: 2,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF8C42),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem(
      {required this.icon, required this.activeIcon, required this.label});
}
