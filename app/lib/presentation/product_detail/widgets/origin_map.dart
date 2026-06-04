import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Origin map for the traceability section.
///
/// Renders Esri World Imagery satellite tiles (no API key / billing) centered on
/// the harvest lot's coordinate with a dropped pin. We use Esri rather than the
/// OpenStreetMap tile server because OSM blocks browser requests (no settable
/// User-Agent on web) under its tile usage policy. Non-interactive on purpose —
/// this is an origin *vitrine*, not a navigable map — so it reads as "here is
/// where it comes from" rather than inviting pan/zoom.
class OriginMap extends StatelessWidget {
  const OriginMap({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.label,
  });

  final double latitude;
  final double longitude;

  /// e.g. `Ji-Paraná, RO` — shown on the pin label.
  final String label;

  @override
  Widget build(BuildContext context) {
    final point = LatLng(latitude, longitude);
    return ClipRRect(
      borderRadius: AppRadii.brLg,
      child: SizedBox(
        height: 150,
        child: Stack(
          children: [
            Positioned.fill(
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: point,
                  initialZoom: 10,
                  // Static vitrine pin — no gestures.
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.none,
                  ),
                ),
                children: [
                  TileLayer(
                    // Esri World Imagery (satellite). Keyless and CORS-enabled
                    // for web; Esri tile order is {z}/{y}/{x}.
                    urlTemplate:
                        'https://server.arcgisonline.com/ArcGIS/rest/services/'
                        'World_Imagery/MapServer/tile/{z}/{y}/{x}',
                    userAgentPackageName: 'br.com.rondoniacacauclube.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: point,
                        width: 40,
                        height: 40,
                        alignment: Alignment.topCenter,
                        child: const Icon(
                          Icons.place,
                          color: AppColors.amber,
                          size: 36,
                          shadows: [
                            Shadow(color: Colors.black26, blurRadius: 4),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Municipality label chip.
            Positioned(
              left: AppSpacing.md,
              bottom: AppSpacing.sm,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadii.brPill,
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 4),
                  ],
                ),
                child: Text(
                  label,
                  style: AppTypography.meta(AppColors.choco900),
                ),
              ),
            ),
            // Tile attribution (Esri terms).
            Positioned(
              right: 6,
              bottom: 4,
              child: Text(
                '© Esri',
                style: AppTypography.meta(Colors.white).copyWith(
                  fontSize: 9,
                  shadows: const [
                    Shadow(color: Colors.black54, blurRadius: 2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
