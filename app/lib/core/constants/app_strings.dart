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

  // Onboarding
  static const String onboardingTag = 'fazenda agroflorestal · Rondônia';
  static const String onboardingTitle1 = 'Descubra o cacau de Rondônia';
  static const String onboardingBody1 =
      'Mel de cacau, nibs e muito mais — feitos por produtores e cooperativas '
      'da floresta amazônica.';
  static const String onboardingTitle2 = 'Da floresta ao pote';
  static const String onboardingBody2 =
      'Acompanhe a origem de cada produto: lote, safra e o produtor por trás '
      'de cada colheita.';
  static const String onboardingTitle3 = 'Faça parte do Clube';
  static const String onboardingBody3 =
      'Siga produtores, avalie produtos e acesse histórias e lançamentos '
      'exclusivos da floresta.';
  static const String onboardingStart = 'Começar';
  static const String onboardingHaveAccount = 'Já tenho conta';

  // Auth
  static const String loginTitle = 'Bem-vindo de volta';
  static const String loginSubtitle = 'Entre para acompanhar produtores e o Clube.';
  static const String signupTitle = 'Criar sua conta';
  static const String signupSubtitle =
      'Junte-se ao Clube e acompanhe a floresta de perto.';
  static const String fieldName = 'Nome';
  static const String fieldEmail = 'E-mail';
  static const String fieldPassword = 'Senha';
  static const String fieldNameHint = 'Como podemos te chamar?';
  static const String fieldEmailHint = 'voce@email.com';
  static const String fieldPasswordHint = '••••••••';
  static const String forgotPassword = 'Esqueci a senha';
  static const String forgotPasswordInfo =
      'Recuperação de senha estará disponível em breve.';
  static const String signInAction = 'Entrar';
  static const String signUpAction = 'Criar conta';
  static const String orContinueWith = 'ou continue com';
  static const String continueWithGoogle = 'Google';
  static const String noAccountPrompt = 'Não tem conta?';
  static const String haveAccountPrompt = 'Já tem conta?';
  static const String goToSignUp = 'Criar conta';
  static const String goToSignIn = 'Entrar';

  // Profile
  static const String profileGreeting = 'Olá';
  static const String profileMember = 'Membro do Clube';
  static const String profileFreePlan = 'Plano Gratuito';
  static const String profileSeeClub = 'Conheça o Clube';
  static const String profileFollowing = 'Produtores que sigo';
  static const String profileAppearance = 'Aparência';
  static const String profileDarkMode = 'Tema escuro';
  static const String profileSignOut = 'Sair da conta';
  static const String profileSignOutConfirm = 'Deseja sair da sua conta?';
  static const String cancel = 'Cancelar';
}
