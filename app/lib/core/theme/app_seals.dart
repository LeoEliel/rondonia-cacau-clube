import 'package:flutter/material.dart';

import 'app_colors.dart';

/// The quality seals shown on products and producers.
enum QualitySeal { cacauFino, origemRO, organico, agrofloresta, comercioJusto }

/// Background + foreground colors and label/icon for a [QualitySeal], taken
/// from the seal color map in `design_tokens.md` §6. Used by the seal-badge
/// component (built in a later milestone).
class SealStyle {
  const SealStyle({
    required this.label,
    required this.icon,
    required this.background,
    required this.foreground,
  });

  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;
}

/// Maps each seal to its presentation. Seal-specific background tints that are
/// not part of the core palette are defined inline here, per the design map.
const Map<QualitySeal, SealStyle> kSealStyles = {
  QualitySeal.cacauFino: SealStyle(
    label: 'Cacau Fino',
    icon: Icons.workspace_premium_outlined,
    background: AppColors.amberTint, // #FBEFD2
    foreground: AppColors.amberDeep, // #C0741A
  ),
  QualitySeal.origemRO: SealStyle(
    label: 'Origem RO',
    icon: Icons.place_outlined,
    background: Color(0xFFF0E2CF),
    foreground: AppColors.choco700, // #5A3522
  ),
  QualitySeal.organico: SealStyle(
    label: 'Orgânico',
    icon: Icons.eco_outlined,
    background: AppColors.greenTint, // #E6F0DF
    foreground: AppColors.greenDeep, // #356637
  ),
  QualitySeal.agrofloresta: SealStyle(
    label: 'Agrofloresta',
    icon: Icons.forest_outlined,
    background: Color(0xFFE7EFE0),
    foreground: AppColors.greenDeep, // #356637
  ),
  QualitySeal.comercioJusto: SealStyle(
    label: 'Comércio Justo',
    icon: Icons.handshake_outlined,
    background: Color(0xFFF3E6D6),
    foreground: AppColors.caramel, // #B5703A
  ),
};
