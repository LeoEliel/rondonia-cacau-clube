/// A purchasable Cocoa Club package from a store offering.
///
/// A backend-agnostic view of a store package (RevenueCat `Package`, or a mocked
/// tier package on web/demo) so the domain, use cases and UI never import the
/// purchases SDK — the [PurchasesRepository] maps the SDK type into this.
class PurchasePackage {
  const PurchasePackage({
    required this.id,
    required this.title,
    required this.priceString,
    this.description,
  });

  /// Stable package identifier (e.g. RevenueCat's `identifier`, or `premium`
  /// for the mocked tier package). Used to select which package to purchase.
  final String id;

  /// Human-readable title shown on the CTA (e.g. "Clube Premium · Mensal").
  final String title;

  /// Localized, store-formatted price string (e.g. "R$ 9,90/mês"). Empty when
  /// the price isn't known (mock/web fallback).
  final String priceString;

  /// Optional supporting line for the package.
  final String? description;
}
