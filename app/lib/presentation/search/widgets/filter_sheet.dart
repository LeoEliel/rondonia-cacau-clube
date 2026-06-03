import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/category_labels.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_seals.dart';
import '../../../domain/entities/enums.dart';
import '../../home/widgets/category_chip.dart';
import '../controllers/search_controller.dart';

/// The "Filtros" bottom sheet (design 04): subproduto, município, selo de
/// qualidade and avaliação mínima sections, a "Limpar" reset, and a sticky
/// "Ver N resultados" button. Filters apply live, so the count updates as
/// chips toggle; the button just dismisses the sheet.
class FilterSheet extends StatelessWidget {
  const FilterSheet({super.key, required this.controller});

  final SearchTabController controller;

  /// Opens the sheet for the given [controller].
  static Future<void> show(SearchTabController controller) {
    return Get.bottomSheet(
      FilterSheet(controller: controller),
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.xl)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.pad,
          AppSpacing.md,
          AppSpacing.pad,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.line2,
                  borderRadius: AppRadii.brPill,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filtros', style: AppTypography.title(AppColors.text)),
                Obx(() => TextButton(
                      onPressed: controller.hasActiveFilters
                          ? controller.clearFilters
                          : null,
                      child: const Text('Limpar'),
                    )),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Section(
                      title: 'Subproduto',
                      child: Obx(() => _Wrap(
                            children: [
                              for (final c in kCatalogCategories)
                                CategoryChip(
                                  label: c.label,
                                  selected: controller.category == c,
                                  onTap: () => controller.selectCategory(c),
                                ),
                            ],
                          )),
                    ),
                    _Section(
                      title: 'Município',
                      child: Obx(() => _Wrap(
                            children: [
                              for (final m in controller.municipalities)
                                CategoryChip(
                                  label: m,
                                  selected: controller.municipality == m,
                                  onTap: () =>
                                      controller.selectMunicipality(m),
                                ),
                            ],
                          )),
                    ),
                    _Section(
                      title: 'Selo de qualidade',
                      child: Obx(() => _Wrap(
                            children: [
                              for (final seal in QualitySeal.values)
                                CategoryChip(
                                  label: kSealStyles[seal]!.label,
                                  selected: controller.seals.contains(seal),
                                  onTap: () => controller.toggleSeal(seal),
                                ),
                            ],
                          )),
                    ),
                    _Section(
                      title: 'Avaliação mínima',
                      child: Obx(() => _Wrap(
                            children: [
                              for (final r
                                  in SearchTabController.ratingOptions)
                                CategoryChip(
                                  label: controller.ratingLabel(r),
                                  selected: controller.minRating == r,
                                  onTap: () => controller.setMinRating(r),
                                ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: Obx(() => FilledButton(
                    onPressed: Get.back,
                    style: FilledButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                    ),
                    child: Text('Ver ${controller.resultCount} resultados'),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: AppTypography.overline(AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }
}

class _Wrap extends StatelessWidget {
  const _Wrap({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.gapSm,
      runSpacing: AppSpacing.gapSm,
      children: children,
    );
  }
}
