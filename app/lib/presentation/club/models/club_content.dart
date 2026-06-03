import 'package:flutter/material.dart';

/// A single piece of members-only content shown in the "Do Clube" rail.
///
/// Presentation-only mock data: the prototype has no content backend, so these
/// items live in the view layer rather than the domain. The [accent] colors the
/// thumbnail placeholder so the list reads richly without remote images.
@immutable
class ClubContent {
  const ClubContent({
    required this.title,
    required this.category,
    required this.minutes,
    required this.accent,
  });

  final String title;
  final String category;
  final int minutes;
  final Color accent;
}
