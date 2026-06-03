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
}
