import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/widgets/merope_scaffold.dart';
import '../../features/social/ui/nexus_timeline_screen.dart';
import '../../features/video/ui/orbit_screen.dart';
import '../../features/video/ui/cinema_hub_screen.dart';
import '../../features/messages/ui/screens/chat_list_screen.dart';
import '../../features/community/ui/community_screen.dart';
import '../../features/talent/ui/talent_screen.dart';
import '../../features/marketplace/ui/marketplace_screen.dart';
import '../../features/notifications/ui/notifications_screen.dart';
import '../../features/search/ui/search_screen.dart';
import '../../features/social/ui/profile_screen.dart';
import '../../features/vault/ui/vault_screen.dart';
import '../../features/settings/ui/settings_screen.dart';
import '../../features/search/ui/synergy_hub_screen.dart';
import '../../features/social/ui/create_post_overlay.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key, this.initialTab = 0});
  final int initialTab;

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  late int _currentIndex;

  static const List<Widget> _screens = [
    NexusTimelineScreen(),
    OrbitScreen(),
    CinemaHubScreen(),
    ChatListScreen(),
    CommunityScreen(),
    TalentScreen(),
    MarketplaceScreen(),
    NotificationsScreen(),
    SearchScreen(),
    ProfileScreen(userId: 'me'),
    VaultScreen(),
    SettingsScreen(),
    SynergyHubScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  @override
  void didUpdateWidget(covariant DashboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTab != widget.initialTab) {
      _currentIndex = widget.initialTab;
    }
  }

  void _navigateToTab(int index) {
    if (index == _currentIndex) return;
    final uri = Uri(path: '/', queryParameters: {'tab': index.toString()});
    context.go(uri.toString());
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final tokens = themeState.currentTokens;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth <= 900;

        return MeropeScaffold(
          universalRail: isMobile ? null : _buildProfessionalRail(tokens),
          bottomNavigationBar: isMobile ? _buildBottomBar(tokens) : null,
          body: AnimatedSwitcher(
            duration: MeropeTokens.durationNormal,
            child: _screens[_currentIndex < _screens.length ? _currentIndex : 0],
          ),
        );
      },
    );
  }

  Widget _buildBottomBar(MeropeColorTokens tokens) {
    return Container(
      decoration: BoxDecoration(
        color: tokens.surface.withValues(alpha: 0.9),
        border: Border(top: BorderSide(color: tokens.border, width: 0.5)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BottomIcon(icon: Icons.radar, isSelected: _currentIndex == 0, onTap: () => _navigateToTab(0), tokens: tokens),
              _BottomIcon(icon: Icons.wifi_tethering, isSelected: _currentIndex == 3, onTap: () => _navigateToTab(3), tokens: tokens),
              _BottomIcon(icon: Icons.flash_on, isSelected: false, onTap: () => CreatePostOverlay.show(context), tokens: tokens, isSpecial: true),
              _BottomIcon(icon: Icons.search, isSelected: _currentIndex == 8, onTap: () => _navigateToTab(8), tokens: tokens),
              _BottomIcon(icon: Icons.person_outline, isSelected: _currentIndex == 9, onTap: () => _navigateToTab(9), tokens: tokens),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfessionalRail(MeropeColorTokens tokens) {
    return Container(
      width: 72,
      padding: const EdgeInsets.symmetric(vertical: MeropeTokens.space24),
      decoration: BoxDecoration(
        color: tokens.surface.withValues(alpha: 0.8),
        border: Border(right: BorderSide(color: tokens.border.withValues(alpha: 0.5), width: 0.5)),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ColorFilter.mode(tokens.surface.withValues(alpha: 0.1), BlendMode.srcOver),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _RailBrandIcon(tokens: tokens),
                const SizedBox(height: MeropeTokens.space48),
                _RailIcon(
                  icon: Icons.radar,
                  label: 'Feed',
                  isSelected: _currentIndex == 0,
                  onTap: () => _navigateToTab(0),
                  colors: tokens,
                ),
                _RailIcon(
                  icon: Icons.blur_circular,
                  label: 'Clips',
                  isSelected: _currentIndex == 1,
                  onTap: () => _navigateToTab(1),
                  colors: tokens,
                ),
                _RailIcon(
                  icon: Icons.play_circle_outline,
                  label: 'Cinema',
                  isSelected: _currentIndex == 2,
                  onTap: () => _navigateToTab(2),
                  colors: tokens,
                ),
                _RailIcon(
                  icon: Icons.wifi_tethering,
                  label: 'Messages',
                  isSelected: _currentIndex == 3,
                  onTap: () => _navigateToTab(3),
                  colors: tokens,
                ),
                _RailIcon(
                  icon: Icons.hub,
                  label: 'Communities',
                  isSelected: _currentIndex == 4,
                  onTap: () => _navigateToTab(4),
                  colors: tokens,
                ),
                _RailIcon(
                  icon: Icons.bolt,
                  label: 'Talent',
                  isSelected: _currentIndex == 5,
                  onTap: () => _navigateToTab(5),
                  colors: tokens,
                ),
                _RailIcon(
                  icon: Icons.shopping_bag_outlined,
                  label: 'Market',
                  isSelected: _currentIndex == 6,
                  onTap: () => _navigateToTab(6),
                  colors: tokens,
                ),
                _RailIcon(
                  icon: Icons.notifications_none,
                  label: 'Alerts',
                  isSelected: _currentIndex == 7,
                  onTap: () => _navigateToTab(7),
                  colors: tokens,
                ),
                _RailIcon(
                  icon: Icons.search,
                  label: 'Explore',
                  isSelected: _currentIndex == 8,
                  onTap: () => _navigateToTab(8),
                  colors: tokens,
                ),
                _RailIcon(
                  icon: Icons.person_outline,
                  label: 'Profile',
                  isSelected: _currentIndex == 9,
                  onTap: () => _navigateToTab(9),
                  colors: tokens,
                ),
                const SizedBox(height: 24),
                _RailIcon(
                  icon: Icons.lock_outline,
                  label: 'Security',
                  isSelected: _currentIndex == 10,
                  onTap: () => _navigateToTab(10),
                  colors: tokens,
                ),
                _RailIcon(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  isSelected: _currentIndex == 11,
                  onTap: () => _navigateToTab(11),
                  colors: tokens,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RailBrandIcon extends StatelessWidget {
  const _RailBrandIcon({required this.tokens});
  final MeropeColorTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [tokens.primary, tokens.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(MeropeTokens.radiusMd),
      ),
      child: const Icon(Icons.flash_on, color: Colors.white, size: 24),
    );
  }
}

class _RailIcon extends StatelessWidget {
  const _RailIcon({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.colors,
  });
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final MeropeColorTokens colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? colors.primary : colors.textSecondary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? colors.primary : colors.textSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomIcon extends StatelessWidget {
  const _BottomIcon({
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.tokens,
    this.isSpecial = false,
  });
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final MeropeColorTokens tokens;
  final bool isSpecial;

  @override
  Widget build(BuildContext context) {
    if (isSpecial) {
      return InkWell(
        onTap: onTap,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [tokens.primary, tokens.secondary]),
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: tokens.primary.withValues(alpha: 0.4), blurRadius: 12)],
          ),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? tokens.primary : tokens.textSecondary,
            size: 24,
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 4,
              height: 4,
              decoration: BoxDecoration(color: tokens.primary, shape: BoxShape.circle),
            ),
        ],
      ),
    );
  }
}
