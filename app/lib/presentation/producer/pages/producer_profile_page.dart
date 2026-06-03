import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/producer_type_labels.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_message_view.dart';
import '../../../core/widgets/product_card.dart';
import '../../../core/widgets/rating_label.dart';
import '../../../core/widgets/seal_badge.dart';
import '../../../domain/entities/producer.dart';
import '../controllers/producer_profile_controller.dart';

/// Producer / Cooperative profile screen (design `06 _ Perfil do Produtor`).
///
/// Cover + avatar header, name, type, origin and rating, a follow action with
/// follower / product counts, the "Nossa história" story, certifications &
/// quality seals, a photo gallery and the producer's product grid. Showcase
/// only — products link to their detail page, never a purchase flow.
class ProducerProfilePage extends GetView<ProducerProfileController> {
  const ProducerProfilePage({super.key});

  static const double _pad = AppSpacing.pad;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        switch (controller.status) {
          case ProducerStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case ProducerStatus.error:
            return SafeArea(
              child: AppMessageView(
                icon: Icons.cloud_off_rounded,
                title: 'Não foi possível carregar',
                message: controller.errorMessage,
                actionLabel: 'Tentar novamente',
                onAction: controller.load,
              ),
            );
          case ProducerStatus.loaded:
            return _ProfileView(controller: controller);
        }
      }),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView({required this.controller});

  final ProducerProfileController controller;

  @override
  Widget build(BuildContext context) {
    final producer = controller.producer!;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CoverHeader(producer: producer),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              ProducerProfilePage._pad,
              AppSpacing.lg,
              ProducerProfilePage._pad,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TypeChip(type: producer.type.label, verified: true),
                const SizedBox(height: AppSpacing.md),
                Text(producer.name, style: AppTypography.title(AppColors.text)),
                const SizedBox(height: AppSpacing.md),
                _MetaRow(producer: producer),
                const SizedBox(height: AppSpacing.xl),
                _StatsAndFollow(controller: controller),
                const SizedBox(height: AppSpacing.sect),
                _StorySection(producer: producer),
                const SizedBox(height: AppSpacing.sect),
                _SealsSection(producer: producer),
                if (producer.photoUrls.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sect),
                  _GallerySection(photoUrls: producer.photoUrls),
                ],
                const SizedBox(height: AppSpacing.sect),
                _ProductsSection(controller: controller),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Tinted cover with a back / share control overlay and the round avatar
/// (initials) anchored at the bottom edge.
class _CoverHeader extends StatelessWidget {
  const _CoverHeader({required this.producer});

  final Producer producer;

  static const double _coverHeight = 180;
  static const double _avatarSize = 78;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _coverHeight + _avatarSize / 2,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _Cover(coverUrl: producer.coverPhotoUrl),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    _CircleButton(
                      icon: Icons.arrow_back_rounded,
                      onTap: Get.back,
                    ),
                    const Spacer(),
                    _CircleButton(
                      icon: Icons.ios_share_rounded,
                      onTap: () => _comingSoon(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: _coverHeight - 30,
            child: const _CoverChip(label: 'capa · roça de cacau'),
          ),
          Positioned(
            left: AppSpacing.pad,
            bottom: 0,
            child: _Avatar(
              initials: _initials(producer.name),
              size: _avatarSize,
            ),
          ),
        ],
      ),
    );
  }

  void _comingSoon(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Compartilhar — em breve.')),
      );
  }
}

class _Cover extends StatelessWidget {
  const _Cover({this.coverUrl});

  final String? coverUrl;

  @override
  Widget build(BuildContext context) {
    final gradient = Container(
      height: _CoverHeader._coverHeight,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.greenTint, AppColors.greenSoft],
        ),
      ),
    );
    if (coverUrl == null || coverUrl!.isEmpty) return gradient;

    return SizedBox(
      height: _CoverHeader._coverHeight,
      width: double.infinity,
      child: Image.network(
        coverUrl!,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) =>
            progress == null ? child : gradient,
        errorBuilder: (context, error, stack) => gradient,
      ),
    );
  }
}

class _CoverChip extends StatelessWidget {
  const _CoverChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.9),
          borderRadius: AppRadii.brPill,
        ),
        child: Text(label, style: AppTypography.meta(AppColors.text2)),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initials, required this.size});

  final String initials;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.greenTint,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.surface, width: 4),
      ),
      child: Text(
        initials,
        style: AppTypography.title(AppColors.greenDeep),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: const CircleBorder(),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, size: 20, color: AppColors.choco900),
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.type, required this.verified});

  final String type;
  final bool verified;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.greenTint,
        borderRadius: AppRadii.brPill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (verified) ...[
            const Icon(Icons.verified_rounded,
                size: 14, color: AppColors.greenDeep),
            const SizedBox(width: 5),
          ],
          Text(type, style: AppTypography.seal(AppColors.greenDeep)),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.producer});

  final Producer producer;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.place_outlined, size: 16, color: AppColors.text3),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            '${producer.municipality}, Rondônia',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.meta(AppColors.text2),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        RatingLabel(producer.rating, size: 16),
      ],
    );
  }
}

class _StatsAndFollow extends StatelessWidget {
  const _StatsAndFollow({required this.controller});

  final ProducerProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(() => _Stat(
              value: _milhar(controller.followerCount),
              label: 'Seguidores',
            )),
        const SizedBox(width: AppSpacing.xl),
        _Stat(value: '${controller.productCount}', label: 'Produtos'),
        const Spacer(),
        Obx(() => _FollowButton(
              following: controller.isFollowing,
              onTap: controller.toggleFollow,
            )),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: AppTypography.section(AppColors.text)),
        Text(label, style: AppTypography.meta(AppColors.text2)),
      ],
    );
  }
}

class _FollowButton extends StatelessWidget {
  const _FollowButton({required this.following, required this.onTap});

  final bool following;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (following) {
      return OutlinedButton.icon(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.greenDeep,
          side: const BorderSide(color: AppColors.greenSoft),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.brPill),
        ),
        icon: const Icon(Icons.check_rounded, size: 18),
        label: const Text('Seguindo'),
      );
    }
    return ElevatedButton.icon(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.amber,
        foregroundColor: AppColors.surface,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.brPill),
      ),
      icon: const Icon(Icons.add_rounded, size: 18),
      label: const Text('Seguir'),
    );
  }
}

class _StorySection extends StatelessWidget {
  const _StorySection({required this.producer});

  final Producer producer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Nossa história',
            style: AppTypography.overline(AppColors.amberDeep)),
        const SizedBox(height: AppSpacing.sm),
        Text(
          '“${producer.story}”',
          style: AppTypography.story(AppColors.text2),
        ),
      ],
    );
  }
}

class _SealsSection extends StatelessWidget {
  const _SealsSection({required this.producer});

  final Producer producer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Certificações & selos',
            style: AppTypography.overline(AppColors.amberDeep)),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final seal in producer.qualitySeals) SealBadge(seal),
            for (final cert in producer.certifications)
              _CertChip(label: cert),
          ],
        ),
      ],
    );
  }
}

class _CertChip extends StatelessWidget {
  const _CertChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.brPill,
        border: Border.all(color: AppColors.line2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.workspace_premium_outlined,
              size: 14, color: AppColors.caramel),
          const SizedBox(width: 5),
          Text(label, style: AppTypography.seal(AppColors.text2)),
        ],
      ),
    );
  }
}

class _GallerySection extends StatelessWidget {
  const _GallerySection({required this.photoUrls});

  final List<String> photoUrls;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Galeria', style: AppTypography.overline(AppColors.amberDeep)),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 96,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: photoUrls.length,
            separatorBuilder: (_, _) =>
                const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, i) => _GalleryTile(url: photoUrls[i]),
          ),
        ),
      ],
    );
  }
}

class _GalleryTile extends StatelessWidget {
  const _GalleryTile({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(width: 120, color: AppColors.choco600);
    return ClipRRect(
      borderRadius: AppRadii.brMd,
      child: SizedBox(
        width: 120,
        child: Image.network(
          url,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) =>
              progress == null ? child : placeholder,
          errorBuilder: (context, error, stack) => placeholder,
        ),
      ),
    );
  }
}

class _ProductsSection extends StatelessWidget {
  const _ProductsSection({required this.controller});

  final ProducerProfileController controller;

  @override
  Widget build(BuildContext context) {
    final producer = controller.producer!;
    final products = controller.products;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text('Produtos', style: AppTypography.section(AppColors.text)),
            Text(
              '${products.length} ${products.length == 1 ? 'item' : 'itens'}',
              style: AppTypography.meta(AppColors.amberDeep),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        if (products.isEmpty)
          Text(
            'Nenhum produto cadastrado ainda.',
            style: AppTypography.body(AppColors.text3),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: products.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.gap,
              crossAxisSpacing: AppSpacing.gap,
              childAspectRatio: 0.62,
            ),
            itemBuilder: (context, i) {
              final product = products[i];
              return ProductCard(
                product: product,
                municipality: producer.municipality,
                onTap: () => Get.toNamed(
                  AppRoutes.productDetail,
                  arguments: product.id,
                ),
              );
            },
          ),
      ],
    );
  }
}

/// Thousands separator using the pt-BR dot (e.g. `1240` → `1.240`).
String _milhar(int n) {
  final digits = n.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

/// Avatar initials: up to two letters from the producer name, skipping the
/// organization-type prefix and connector words so e.g. "Cooperativa Cacau do
/// Vale" → "CV".
String _initials(String name) {
  const skip = {
    'cooperativa',
    'associação',
    'sítio',
    'fazenda',
    'família',
    'de',
    'do',
    'da',
    'dos',
    'das',
    'e',
  };
  final words = name
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty && !skip.contains(w.toLowerCase()))
      .toList();
  final source = words.isEmpty ? name.split(RegExp(r'\s+')) : words;
  return source.take(2).map((w) => w[0].toUpperCase()).join();
}
