import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_membership_poc/features/auth/screens/auth_screen.dart';
import 'package:qr_membership_poc/features/auth/screens/email_verification_screen.dart';
import 'package:qr_membership_poc/features/checkin/screens/home_screen.dart';
import '../features/auth/cubit/auth_cubit.dart';
import '../features/auth/cubit/auth_state.dart';
// TODO: Import these when screens are created
// import '../features/auth/screens/auth_screen.dart';
// import '../features/auth/screens/email_verification_screen.dart';
// import '../features/checkin/screens/home_screen.dart';
// import '../features/checkin/screens/qr_display_screen.dart';

class AppRouter {
  static GoRouter? _router;

  static GoRouter router(AuthCubit authCubit) {
    _router ??= GoRouter(
      initialLocation: '/splash',
      redirect: (context, state) {
        final authState = authCubit.state;
        final isGoingToAuth = state.matchedLocation.startsWith('/auth');
        final isGoingToVerification = state.matchedLocation.startsWith(
          '/verify',
        );
        final isGoingToSplash = state.matchedLocation == '/splash';

        // Handle different auth states
        if (authState is AuthInitial) {
          return isGoingToSplash ? null : '/splash';
        }

        if (authState is AuthUnauthenticated) {
          return isGoingToAuth ? null : '/auth';
        }

        if (authState is AuthEmailNotVerified) {
          return isGoingToVerification ? null : '/verify';
        }

        if (authState is AuthAuthenticated) {
          if (isGoingToAuth || isGoingToVerification || isGoingToSplash) {
            return '/home';
          }
          return null; // Allow navigation to authenticated routes
        }

        if (authState is AuthLoading) {
          return isGoingToSplash ? null : '/splash';
        }

        return null;
      },
      refreshListenable: GoRouterRefreshStream(authCubit.stream),
      routes: [
        // Splash/Loading Route
        GoRoute(
          path: '/splash',
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
        ),

        // Auth Routes
        GoRoute(
          path: '/auth',
          name: 'auth',
          builder: (context, state) => const AuthScreen(),
        ),

        // Email Verification Route
        GoRoute(
          path: '/verify',
          name: 'verify',
          builder: (context, state) => const EmailVerificationScreen(),
        ),

        // Protected Routes
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
          routes: [
            GoRoute(
              path: 'qr',
              name: 'qr',
              builder: (context, state) => const QRDisplayScreen(),
            ),
          ],
        ),
      ],
    );

    return _router!;
  }
}

// Helper class to convert stream to listenable
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription _subscription;

  GoRouterRefreshStream(Stream stream) {
    _subscription = stream.listen((_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

// Splash Screen Widget
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class QRDisplayScreen extends StatelessWidget {
  const QRDisplayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('QR Display Screen - TODO: Implement')),
    );
  }
}
