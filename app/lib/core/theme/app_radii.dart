import 'package:flutter/widgets.dart';

/// Corner-radius scale from the design tokens.
abstract final class AppRadii {
  AppRadii._();

  static const double sm = 12;
  static const double md = 18;
  static const double lg = 26;
  static const double xl = 32;
  static const double pill = 999;

  static const BorderRadius brSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius brMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius brLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius brXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius brPill = BorderRadius.all(Radius.circular(pill));
}
