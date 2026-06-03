import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// A row of five stars.
///
/// Static when [onTap] is null (a read-only rating display); interactive when
/// [onTap] is provided — tapping the n-th star reports `n` (1–5) back so the
/// caller can drive a draft rating. [rating] is the number of filled stars.
class StarRow extends StatelessWidget {
  const StarRow({
    super.key,
    required this.rating,
    this.size = 20,
    this.onTap,
  });

  /// Number of filled stars (0–5).
  final int rating;
  final double size;

  /// When non-null the row becomes interactive; receives the tapped star (1–5).
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var star = 1; star <= 5; star++)
          _Star(
            filled: star <= rating,
            size: size,
            onTap: onTap == null ? null : () => onTap!(star),
          ),
      ],
    );
  }
}

class _Star extends StatelessWidget {
  const _Star({required this.filled, required this.size, this.onTap});

  final bool filled;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final icon = Icon(
      filled ? Icons.star_rounded : Icons.star_outline_rounded,
      size: size,
      color: filled ? AppColors.amber : AppColors.line2,
    );
    if (onTap == null) return Padding(padding: const EdgeInsets.all(1), child: icon);
    return InkResponse(
      onTap: onTap,
      radius: size * 0.8,
      child: Padding(padding: const EdgeInsets.all(2), child: icon),
    );
  }
}
