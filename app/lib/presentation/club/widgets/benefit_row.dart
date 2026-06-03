import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';

/// A single "✓ benefit" line used in the Gratuito and Clube tier cards.
class BenefitRow extends StatelessWidget {
  const BenefitRow({
    super.key,
    required this.label,
    required this.checkColor,
    required this.textStyle,
  });

  final String label;
  final Color checkColor;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check, size: 18, color: checkColor),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(label, style: textStyle)),
        ],
      ),
    );
  }
}
