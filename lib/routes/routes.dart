/// Centralized route definitions for the application.
///
/// This class provides constants for all route paths and names used throughout
/// the app, ensuring type safety and preventing typos.
class AppRoutes {
  AppRoutes._(); // Private constructor to prevent instantiation

  // Route paths
  static const String splash = '/splash';
  static const String auth = '/auth';
  static const String verify = '/verify';
  static const String home = '/home';
  static const String qr = 'qr';

  // Full paths for nested routes
  static const String homeQr = '$home/$qr';

  // Route names (used with GoRouter's named navigation)
  static const String splashName = 'splash';
  static const String authName = 'auth';
  static const String verifyName = 'verify';
  static const String homeName = 'home';
  static const String qrName = 'qr';
}
