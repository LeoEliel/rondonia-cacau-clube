import 'package:flutter/material.dart';

import '../../domain/entities/product.dart';
import '../constants/category_labels.dart';
import '../theme/app_colors.dart';
import '../theme/app_elevation.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'rating_label.dart';
import 'seal_badge.dart';

/// Catalog product card: cocoa-toned photo area with the top quality seal and a
/// favorite toggle, then category overline, Lora product name, origin
/// municipality and aggregate rating. No price / buy action (showcase only).
class ProductCard extends StatefulWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.municipality,
    this.onTap,
  });

  final Product product;
  final String municipality;
  final VoidCallback? onTap;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _favorite = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final product = widget.product;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: AppRadii.brLg,
          boxShadow: AppElevation.e1,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1.18,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _ProductImage(product: product),
                  if (product.qualitySeals.isNotEmpty)
                    Positioned(
                      top: AppSpacing.md,
                      left: AppSpacing.md,
                      child: SealBadge(product.qualitySeals.first),
                    ),
                  Positioned(
                    top: AppSpacing.sm,
                    right: AppSpacing.sm,
                    child: _FavoriteButton(
                      active: _favorite,
                      onTap: () => setState(() => _favorite = !_favorite),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.cardPad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.byproductCategory.label.toUpperCase(),
                    style: AppTypography.overline(AppColors.amberDeep),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.place_outlined,
                              size: 16,
                              color: scheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                widget.municipality,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.meta(
                                  scheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      RatingLabel(product.rating, size: 16),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Photo area with a cocoa-colored placeholder while loading / on error
/// (falling back to the category name pill, matching the design mock).
class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final url = product.coverPhotoUrl;
    final placeholder = _Placeholder(label: product.byproductCategory.label);

    if (url == null || url.isEmpty) return placeholder;

    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : _Placeholder(label: ''),
      errorBuilder: (context, error, stack) => placeholder,
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.choco600,
      alignment: Alignment.center,
      child: label.isEmpty
          ? null
          : Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.choco900.withValues(alpha: 0.45),
                borderRadius: AppRadii.brPill,
              ),
              child: Text(
                label.toLowerCase(),
                style: AppTypography.body(AppColors.screenBg),
              ),
            ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.active, required this.onTap});

  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(
            active ? Icons.favorite : Icons.favorite_border,
            size: 20,
            color: active ? AppColors.caramel : AppColors.choco900,
          ),
        ),
      ),
    );
  }
}
