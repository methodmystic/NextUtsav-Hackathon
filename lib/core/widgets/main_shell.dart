import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../router/app_router.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith(AppRoutes.home)) return 0;
    if (location.startsWith(AppRoutes.clubs)) return 1;
    if (location.startsWith(AppRoutes.hackathons)) return 2;
    if (location.startsWith(AppRoutes.rankings)) return 3;
    if (location.startsWith(AppRoutes.profile)) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
      case 1:
        context.go(AppRoutes.clubs);
      case 2:
        context.go(AppRoutes.hackathons);
      case 3:
        context.go(AppRoutes.rankings);
      case 4:
        context.go(AppRoutes.profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? Colors.white10 : Colors.grey.shade200,
              width: 0.5,
            ),
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavButton(
                icon: Icons.home_outlined,
                activeIcon: Icons.home_filled,
                isActive: selectedIndex == 0,
                onTap: () => _onItemTapped(0, context),
              ),
              _NavButton(
                icon: Icons.search_rounded,
                activeIcon: Icons.search_rounded,
                isActive: selectedIndex == 1,
                onTap: () => _onItemTapped(1, context),
              ),
              _NavButton(
                icon: Icons.rocket_launch_outlined,
                activeIcon: Icons.rocket_launch_rounded,
                isActive: selectedIndex == 2,
                onTap: () => _onItemTapped(2, context),
              ),
              _NavButton(
                icon: Icons.emoji_events_outlined,
                activeIcon: Icons.emoji_events_rounded,
                isActive: selectedIndex == 3,
                onTap: () => _onItemTapped(3, context),
              ),
              _ProfileNavButton(
                isActive: selectedIndex == 4,
                onTap: () => _onItemTapped(4, context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.activeIcon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? Colors.white : Colors.black;
    final inactiveColor = isDark ? Colors.white54 : Colors.grey.shade400;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? activeIcon : icon,
            size: 28,
            color: isActive ? activeColor : inactiveColor,
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 4,
            width: isActive ? 4 : 0,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileNavButton extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;

  const _ProfileNavButton({
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isActive 
                    ? (isDark ? Colors.white : Colors.black) 
                    : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: const CircleAvatar(
              radius: 13,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=antigravity'),
            ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 4,
            width: isActive ? 4 : 0,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

