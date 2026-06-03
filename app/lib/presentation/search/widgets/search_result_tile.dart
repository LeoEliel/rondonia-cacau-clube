import 'package:flutter/material.dart';

import '../../../core/constants/category_labels.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/rating_label.dart';
import '../../../domain/entities/product.dart';

/// Horizontal search result row: square photo, category overline, product name,
/// origin municipality + rating, and a chevron. Tapping opens Product Detail.
class SearchResultTile extends StatelessWidget {
  const SearchResultTile({
    super.key,
    required this.product,
    required this.municipality,
    this.onTap,
  });

  final Product product;
  final String municipality;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadii.brLg,
          boxShadow: AppElevation.e1,
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            SizedBox(
              width: 92,
              height: 92,
              child: _Thumb(product: product),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      product.byproductCategory.label.toUpperCase(),
                      style: AppTypography.overline(AppColors.amberDeep),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.productName(AppColors.text),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.place_outlined,
                            size: 14, color: AppColors.text3),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            municipality,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.meta(AppColors.text2),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        RatingLabel(product.rating, size: 14),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: AppSpacing.sm),
              child: Icon(Icons.chevron_right_rounded, color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final url = product.coverPhotoUrl;
    final placeholder = Container(color: AppColors.choco600);
    if (url == null || url.isEmpty) return placeholder;
    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : Container(color: AppColors.choco600),
      errorBuilder: (context, error, stack) => placeholder,
    );
  }
}
