import 'package:go_router/go_router.dart';
import '../../features/auth/ui/onboarding_screen.dart';
import '../../features/auth/ui/personal_auth_screen.dart';
import '../../features/auth/ui/corporate_auth_screen.dart';
import '../../features/auth/ui/login_screen.dart';
import '../../features/auth/ui/register_screen.dart';
import '../../features/auth/ui/mfa_screen.dart';
import '../../features/settings/ui/verification_screen.dart';
import '../../features/settings/ui/edit_profile_screen.dart';
import '../../features/marketplace/ui/order_confirmation_screen.dart';
import '../../features/video/ui/screens/call_screen.dart';
import '../../features/video/ui/screens/multi_stream_screen.dart';
import '../../features/wallet/ui/screens/escrow_details_screen.dart';
import '../../features/developer/ui/bot_dashboard_screen.dart';
import '../../features/growth/ui/analytics_dashboard.dart';
import '../../features/social/ui/shared_memory_screen.dart';
import '../../features/social/ui/post_detail_screen.dart';
import '../../features/stories/ui/screens/stories_screen.dart';
import '../../features/community/ui/community_screen.dart';
import '../../features/social/ui/profile_screen.dart';
import '../../features/developer/ui/enterprise_dashboard_screen.dart';
import 'dashboard_shell.dart';

final List<GoRoute> appRoutes = [
  GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen()),
  GoRoute(
      path: '/auth/personal',
      builder: (context, state) => const PersonalAuthScreen()),
  GoRoute(
      path: '/auth/corporate',
      builder: (context, state) => const CorporateAuthScreen()),
  GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
  GoRoute(
      path: '/register', builder: (context, state) => const RegisterScreen()),
  GoRoute(path: '/mfa-setup', builder: (context, state) => const MFAScreen()),
  GoRoute(
      path: '/settings/verification',
      builder: (context, state) => const VerificationScreen()),
  GoRoute(
      path: '/settings/edit-profile',
      builder: (context, state) => const EditProfileScreen()),
  GoRoute(
    path: '/order-confirmation/:id',
    builder: (context, state) =>
        OrderConfirmationScreen(productId: state.pathParameters['id']!),
  ),
  GoRoute(
    path: '/call/:userId/:userName',
    builder: (context, state) => CallScreen(
      remoteUserId: state.pathParameters['userId']!,
      remoteUserName: state.pathParameters['userName']!,
    ),
  ),
  GoRoute(
    path: '/escrow/:id',
    builder: (context, state) =>
        EscrowDetailsScreen(escrowId: state.pathParameters['id']!),
  ),
  GoRoute(
    path: '/multi-stream/:id',
    builder: (context, state) =>
        MultiStreamScreen(roomId: state.pathParameters['id']!),
  ),
  GoRoute(
    path: '/developer',
    builder: (context, state) =>
        const BotDashboardScreen(appId: 'merope-prime-internal'),
  ),
  GoRoute(
    path: '/enterprise-dashboard',
    builder: (context, state) =>
        const EnterpriseDashboardScreen(appId: 'merope-prime-internal'),
  ),
  GoRoute(
      path: '/analytics',
      builder: (context, state) => const AnalyticsDashboard()),
  GoRoute(
    path: '/memory/:id',
    builder: (context, state) =>
        SharedMemoryScreen(memoryId: state.pathParameters['id']!),
  ),
  GoRoute(
    path: '/community/:id',
    builder: (context, state) =>
        CommunityDetailScreen(communityId: state.pathParameters['id']!),
  ),
  GoRoute(
    path: '/collective/:id',
    builder: (context, state) =>
        CollectiveDetailScreen(collectiveId: state.pathParameters['id']!),
  ),
  GoRoute(
    path: '/profile/:id',
    builder: (context, state) =>
        ProfileScreen(userId: state.pathParameters['id']!),
  ),
  GoRoute(
    path: '/post/:id',
    builder: (context, state) =>
        PostDetailScreen(postId: state.pathParameters['id']!),
  ),
  GoRoute(
    path: '/story/:userId',
    builder: (context, state) =>
        StoriesScreen(userId: state.pathParameters['userId']!),
  ),
  GoRoute(
    path: '/',
    builder: (context, state) {
      final initialTab =
          int.tryParse(state.uri.queryParameters['tab'] ?? '0') ?? 0;
      return DashboardScreen(initialTab: initialTab);
    },
  ),
];
