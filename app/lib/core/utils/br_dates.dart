/// Tiny pt-BR date formatting helpers.
///
/// The app avoids the `intl` package for these few labels, so the month
/// abbreviations live here as the single source of truth. Covers only the
/// formats the UI actually renders (month + year, day + month).
abstract final class BrDates {
  BrDates._();

  /// Lowercase three-letter month abbreviations, index 0 == January.
  static const List<String> _monthsAbbrev = [
    'jan', 'fev', 'mar', 'abr', 'mai', 'jun',
    'jul', 'ago', 'set', 'out', 'nov', 'dez',
  ];

  /// e.g. `Mar 2026` — capitalized month abbreviation + full year.
  static String monthYear(DateTime date) {
    final m = _monthsAbbrev[date.month - 1];
    return '${m[0].toUpperCase()}${m.substring(1)} ${date.year}';
  }

  /// e.g. `12 MAR` — day + uppercase month abbreviation.
  static String dayMonth(DateTime date) =>
      '${date.day} ${_monthsAbbrev[date.month - 1].toUpperCase()}';

  /// Coarse pt-BR relative time used by the reviews list (e.g. `há 3 dias`,
  /// `há 1 semana`). [now] is injectable so the output is testable.
  static String relative(DateTime date, {DateTime? now}) {
    final reference = now ?? DateTime.now();
    final days = reference.difference(date).inDays;

    if (days <= 0) return 'hoje';
    if (days == 1) return 'há 1 dia';
    if (days < 7) return 'há $days dias';
    if (days < 14) return 'há 1 semana';
    if (days < 30) return 'há ${days ~/ 7} semanas';
    if (days < 60) return 'há 1 mês';
    if (days < 365) return 'há ${days ~/ 30} meses';
    if (days < 730) return 'há 1 ano';
    return 'há ${days ~/ 365} anos';
  }
}
