import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/category_labels.dart';
import '../../../core/constants/product_sort_labels.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_seals.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_message_view.dart';
import '../controllers/search_controller.dart';
import '../widgets/filter_sheet.dart';
import '../widgets/search_result_tile.dart';

/// Search & Filters screen (design 04): editable search field, a filters entry
/// with active-filter chips, a results count + sort control, and the result
/// list. Detailed filtering lives in the [FilterSheet]; results stream from the
/// [SearchTabController] via the [GetProducts] use case + client-side refines.
class SearchPage extends GetView<SearchTabController> {
  const SearchPage({super.key});

  static const double _pad = AppSpacing.pad;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(_pad, AppSpacing.md, _pad, 0),
              child: Column(
                children: [
                  _SearchField(controller: controller),
                  const SizedBox(height: AppSpacing.md),
                  _FilterBar(controller: controller),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _ResultsHeader(controller: controller),
            Expanded(child: _ResultsList(controller: controller)),
          ],
        ),
      ),
    );
  }
}

/// Editable search field bound to the controller's text (debounced upstream).
class _SearchField extends StatefulWidget {
  const _SearchField({required this.controller});

  final SearchTabController controller;

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  late final TextEditingController _text =
      TextEditingController(text: widget.controller.text);

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: AppRadii.brPill,
        boxShadow: AppElevation.e1,
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: cs.outline),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: TextField(
              controller: _text,
              onChanged: widget.controller.setText,
              textInputAction: TextInputAction.search,
              style: AppTypography.body(cs.onSurface),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: 'Buscar mel, nibs, produtores…',
                hintStyle: AppTypography.body(cs.outline),
              ),
            ),
          ),
          Obx(() => widget.controller.text.isEmpty
              ? const SizedBox.shrink()
              : GestureDetector(
                  onTap: () {
                    _text.clear();
                    widget.controller.clearText();
                  },
                  child: Icon(Icons.close_rounded,
                      color: cs.outline, size: 20),
                )),
        ],
      ),
    );
  }
}

/// "Filtros" button + the current active-filter chips (each removable).
class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.controller});

  final SearchTabController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Obx(() {
        final chips = <Widget>[
          _FiltersButton(
            count: controller.activeFilterCount,
            onTap: () => FilterSheet.show(controller),
          ),
          if (controller.category != null)
            _ActiveChip(
              label: controller.category!.label,
              onRemove: () => controller.selectCategory(controller.category),
            ),
          for (final seal in controller.seals)
            _ActiveChip(
              label: kSealStyles[seal]!.label,
              onRemove: () => controller.toggleSeal(seal),
            ),
          if (controller.municipality != null)
            _ActiveChip(
              label: controller.municipality!,
              onRemove: () =>
                  controller.selectMunicipality(controller.municipality),
            ),
          if (controller.minRating > 0)
            _ActiveChip(
              label: controller.ratingLabel(controller.minRating),
              onRemove: () => controller.setMinRating(0),
            ),
        ];

        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: SearchPage._pad),
          itemCount: chips.length,
          separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.gapSm),
          itemBuilder: (_, i) => chips[i],
        );
      }),
    );
  }
}

class _FiltersButton extends StatelessWidget {
  const _FiltersButton({required this.count, required this.onTap});

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final active = count > 0;
    final cs = Theme.of(context).colorScheme;
    final idleInk = cs.onSurface;
    return Material(
      color: active ? AppColors.amber : cs.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.brPill,
        side: active
            ? BorderSide.none
            : BorderSide(color: cs.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(Icons.tune_rounded,
                  size: 18,
                  color: active ? Colors.white : idleInk),
              const SizedBox(width: 6),
              Text(
                count > 0 ? 'Filtros ($count)' : 'Filtros',
                style: AppTypography.bodyBold(
                    active ? Colors.white : idleInk),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActiveChip extends StatelessWidget {
  const _ActiveChip({required this.label, required this.onRemove});

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.amberTint,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.brPill),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onRemove,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 10, 0),
          child: Row(
            children: [
              Text(label, style: AppTypography.bodyBold(AppColors.amberDeep)),
              const SizedBox(width: 5),
              const Icon(Icons.close_rounded,
                  size: 16, color: AppColors.amberDeep),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultsHeader extends StatelessWidget {
  const _ResultsHeader({required this.controller});

  final SearchTabController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        SearchPage._pad,
        AppSpacing.sm,
        SearchPage._pad,
        AppSpacing.sm,
      ),
      child: Obx(() {
        final n = controller.resultCount;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$n ${n == 1 ? 'resultado' : 'resultados'}',
              style: AppTypography.bodyBold(
                  Theme.of(context).colorScheme.onSurface),
            ),
            GestureDetector(
              onTap: controller.cycleSort,
              child: Row(
                children: [
                  Text(
                    controller.sort.label,
                    style: AppTypography.meta(AppColors.amberDeep),
                  ),
                  const SizedBox(width: 2),
                  const Icon(Icons.unfold_more_rounded,
                      size: 16, color: AppColors.amberDeep),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _ResultsList extends StatelessWidget {
  const _ResultsList({required this.controller});

  final SearchTabController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (controller.status) {
        case SearchStatus.loading:
          return const Center(child: CircularProgressIndicator());
        case SearchStatus.error:
          return AppMessageView(
            icon: Icons.cloud_off_rounded,
            title: 'Não foi possível buscar',
            message: controller.errorMessage,
            actionLabel: 'Tentar novamente',
            onAction: controller.search,
          );
        case SearchStatus.loaded:
          final results = controller.results;
          if (results.isEmpty) {
            return AppMessageView(
              icon: Icons.search_off_rounded,
              title: 'Nenhum resultado',
              message: 'Tente outra busca ou ajuste os filtros.',
              actionLabel:
                  controller.hasActiveFilters ? 'Limpar filtros' : null,
              onAction:
                  controller.hasActiveFilters ? controller.clearFilters : null,
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              SearchPage._pad,
              AppSpacing.sm,
              SearchPage._pad,
              AppSpacing.xxl,
            ),
            itemCount: results.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.gap),
            itemBuilder: (_, i) {
              final product = results[i];
              return SearchResultTile(
                product: product,
                municipality: controller.municipalityFor(product.producerId),
                onTap: () => Get.toNamed(
                  AppRoutes.productDetail,
                  arguments: product.id,
                  parameters: {'id': product.id},
                ),
              );
            },
          );
      }
    });
  }
}
