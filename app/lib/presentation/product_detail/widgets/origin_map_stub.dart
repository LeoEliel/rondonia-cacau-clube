import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Placeholder for the origin map.
///
/// A real map (google_maps_flutter / flutter_map) is deferred until a Maps API
/// key is provisioned, so this renders a static cartographic-toned panel with a
/// dropped pin labelled with the origin municipality. Swapping in a live map
/// later only touches this widget.
class OriginMapStub extends StatelessWidget {
  const OriginMapStub({super.key, required this.municipality});

  /// e.g. `Ji-Paraná, RO`.
  final String municipality;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadii.brLg,
      child: Container(
        height: 150,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.greenTint, AppColors.surface3],
          ),
        ),
        child: Stack(
          children: [
            // Faint grid to read as a map surface.
            Positioned.fill(
              child: CustomPaint(painter: _GridPainter()),
            ),
            // Center pin + municipality label.
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.place, color: AppColors.amber, size: 34),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: AppRadii.brPill,
                    ),
                    child: Text(
                      municipality,
                      style: AppTypography.meta(AppColors.choco900),
                    ),
                  ),
                ],
              ),
            ),
            // Caption.
            Positioned(
              left: AppSpacing.md,
              bottom: AppSpacing.sm,
              child: Text(
                'mapa · município de origem',
                style: AppTypography.overline(AppColors.text3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Light grid lines to evoke a map without any tiles / API.
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.greenSoft.withValues(alpha: 0.18)
      ..strokeWidth = 1;
    const step = 28.0;
    for (var x = 0.0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
