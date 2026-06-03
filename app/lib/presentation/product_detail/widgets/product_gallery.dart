import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Swipeable product photo header with a chocolate gradient scrim and floating
/// back / share / favorite controls. Falls back to a cocoa placeholder (with
/// the category name) when a product has no usable photos, matching the catalog
/// card treatment. Page dots are shown when there is more than one photo.
class ProductGallery extends StatefulWidget {
  const ProductGallery({
    super.key,
    required this.photoUrls,
    required this.categoryLabel,
    required this.onBack,
    this.onShare,
    this.onToggleFavorite,
    this.favorite = false,
  });

  final List<String> photoUrls;
  final String categoryLabel;
  final VoidCallback onBack;
  final VoidCallback? onShare;
  final VoidCallback? onToggleFavorite;
  final bool favorite;

  @override
  State<ProductGallery> createState() => _ProductGalleryState();
}

class _ProductGalleryState extends State<ProductGallery> {
  final PageController _pageController = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Always render at least one page so the placeholder shows.
    final pages = widget.photoUrls.isEmpty ? <String?>[null] : widget.photoUrls;

    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 0.92,
          child: PageView.builder(
            controller: _pageController,
            itemCount: pages.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (context, index) =>
                _GalleryImage(url: pages[index], label: widget.categoryLabel),
          ),
        ),

        // Bottom scrim so the dots stay legible over bright photos.
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [
                    AppColors.choco950.withValues(alpha: 0.35),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),

        // Floating controls.
        Positioned(
          top: AppSpacing.sm,
          left: AppSpacing.pad,
          right: AppSpacing.pad,
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                _GalleryButton(icon: Icons.arrow_back, onTap: widget.onBack),
                const Spacer(),
                _GalleryButton(
                  icon: Icons.ios_share,
                  onTap: widget.onShare ?? () {},
                ),
                const SizedBox(width: AppSpacing.md),
                _GalleryButton(
                  icon: widget.favorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  iconColor: widget.favorite ? AppColors.caramel : null,
                  onTap: widget.onToggleFavorite ?? () {},
                ),
              ],
            ),
          ),
        ),

        if (pages.length > 1)
          Positioned(
            bottom: AppSpacing.lg,
            left: 0,
            right: 0,
            child: _PageDots(count: pages.length, active: _page),
          ),
      ],
    );
  }
}

class _GalleryImage extends StatelessWidget {
  const _GalleryImage({required this.url, required this.label});

  final String? url;
  final String label;

  @override
  Widget build(BuildContext context) {
    final placeholder = _Placeholder(label: label);
    if (url == null || url!.isEmpty) return placeholder;
    return Image.network(
      url!,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : const _Placeholder(label: ''),
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
          : Text(
              'foto do produto · ${label.toLowerCase()}',
              style: AppTypography.meta(AppColors.screenBg),
            ),
    );
  }
}

class _GalleryButton extends StatelessWidget {
  const _GalleryButton({required this.icon, required this.onTap, this.iconColor});

  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, size: 20, color: iconColor ?? AppColors.choco900),
        ),
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.count, required this.active});

  final int count;
  final int active;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: i == active ? 18 : 7,
            height: 7,
            decoration: BoxDecoration(
              color: i == active
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(99),
            ),
          ),
      ],
    );
  }
}
