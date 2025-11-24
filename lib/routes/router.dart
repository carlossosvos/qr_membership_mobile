import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_membership_poc/features/auth/screens/auth_screen.dart';
import 'package:qr_membership_poc/features/auth/screens/email_verification_screen.dart';
import 'package:qr_membership_poc/features/checkin/screens/home_screen.dart';
import '../features/auth/cubit/auth_cubit.dart';
import '../features/auth/cubit/auth_state.dart';
import 'routes.dart';
// TODO: Import these when screens are created
// import '../features/auth/screens/auth_screen.dart';
// import '../features/auth/screens/email_verification_screen.dart';
// import '../features/checkin/screens/home_screen.dart';
// import '../features/checkin/screens/qr_display_screen.dart';

class AppRouter {
  static GoRouter? _router;

  static GoRouter router(AuthCubit authCubit) {
    _router ??= GoRouter(
      initialLocation: AppRoutes.splash,
      redirect: (context, state) {
        final authState = authCubit.state;
        final isGoingToAuth = state.matchedLocation.startsWith(AppRoutes.auth);
        final isGoingToVerification = state.matchedLocation.startsWith(
          AppRoutes.verify,
        );
        final isGoingToSplash = state.matchedLocation == AppRoutes.splash;

        // Handle different auth states
        if (authState is AuthInitial) {
          return isGoingToSplash ? null : AppRoutes.splash;
        }

        if (authState is AuthUnauthenticated) {
          return isGoingToAuth ? null : AppRoutes.auth;
        }

        if (authState is AuthEmailNotVerified) {
          return isGoingToVerification ? null : AppRoutes.verify;
        }

        if (authState is AuthAuthenticated) {
          if (isGoingToAuth || isGoingToVerification || isGoingToSplash) {
            return AppRoutes.home;
          }
          return null; // Allow navigation to authenticated routes
        }

        if (authState is AuthLoading) {
          return isGoingToSplash ? null : AppRoutes.splash;
        }

        return null;
      },
      refreshListenable: GoRouterRefreshStream(authCubit.stream),
      routes: [
        // Splash/Loading Route
        GoRoute(
          path: AppRoutes.splash,
          name: AppRoutes.splashName,
          builder: (context, state) => const SplashScreen(),
        ),

        // Auth Routes
        GoRoute(
          path: AppRoutes.auth,
          name: AppRoutes.authName,
          builder: (context, state) => const AuthScreen(),
        ),

        // Email Verification Route
        GoRoute(
          path: AppRoutes.verify,
          name: AppRoutes.verifyName,
          builder: (context, state) => const EmailVerificationScreen(),
        ),

        // Protected Routes
        GoRoute(
          path: AppRoutes.home,
          name: AppRoutes.homeName,
          builder: (context, state) => const HomeScreen(),
          routes: [
            GoRoute(
              path: AppRoutes.qr,
              name: AppRoutes.qrName,
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
