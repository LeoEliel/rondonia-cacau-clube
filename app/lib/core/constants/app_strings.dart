/// Centralized pt-BR UI strings (i18n-ready single source of truth).
///
/// Keeping copy in one place makes it trivial to swap to a real localization
/// solution later, and keeps Dart identifiers in English while the UI stays
/// in Portuguese.
abstract final class AppStrings {
  AppStrings._();

  // App
  static const String appName = 'Rondônia Cacau Clube';
  static const String appShortName = 'Cacau Clube';

  // Bottom navigation
  static const String navHome = 'Início';
  static const String navSearch = 'Buscar';
  static const String navClub = 'Clube';
  static const String navProfile = 'Perfil';

  // Shell / placeholders
  static const String comingSoon = 'Em breve';
  static const String comingSoonBody =
      'Esta seção será construída nas próximas etapas do protótipo.';

  // Section titles
  static const String home = 'Início';
  static const String search = 'Buscar';
  static const String club = 'Clube do Cacau';
  static const String profile = 'Perfil';
}
