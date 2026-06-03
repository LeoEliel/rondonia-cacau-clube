import 'package:flutter/material.dart';

import '../../domain/entities/enums.dart';
import 'app_colors.dart';

/// Background + foreground colors, label and icon for a [QualitySeal], taken
/// from the seal color map in `design_tokens.md` §6. The presentation layer
/// keys off the single domain [QualitySeal] enum, so seal identity lives in the
/// domain while its *styling* lives here.
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
