/// Named-route constants for the whole app.
///
/// Declared up front (even for screens not yet built) so navigation calls and
/// the [AppPages] table reference a single source of truth. Feature screens are
/// wired into [AppPages] as the corresponding milestones land.
abstract final class AppRoutes {
  AppRoutes._();

  // Implemented in Milestone 1
  static const String shell = '/';

  // Auth flow (Milestone 5)
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';

  // Planned (later milestones)
  static const String home = '/home';
  static const String search = '/search';
  static const String productDetail = '/product';
  static const String producer = '/producer';
  static const String club = '/club';
  static const String reviews = '/reviews';
  static const String profile = '/profile';
}
