import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/category_labels.dart';
import '../../../core/constants/producer_type_labels.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_message_view.dart';
import '../../../core/widgets/rating_label.dart';
import '../../../core/widgets/seal_badge.dart';
import '../../../core/utils/br_dates.dart';
import '../../../domain/entities/origin_lot.dart';
import '../../../domain/entities/producer.dart';
import '../../../domain/entities/product.dart';
import '../../reviews/controllers/reviews_controller.dart';
import '../controllers/product_detail_controller.dart';
import '../widgets/origin_map_stub.dart';
import '../widgets/origin_timeline.dart';
import '../widgets/product_gallery.dart';

/// Product Detail screen (design `05 _ Detalhe do Produto`).
///
/// Photo gallery, name, category, description, seals and aggregate rating,
/// followed by the Rastreabilidade section: producer/cooperative link, lot +
/// harvest facts, the farm-to-product timeline and an origin map. A WhatsApp
/// "Falar com o produtor" CTA closes the page. Showcase only — no price / buy.
class ProductDetailPage extends GetView<ProductDetailController> {
  const ProductDetailPage({super.key});

  static const double _pad = AppSpacing.pad;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        switch (controller.status) {
          case DetailStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case DetailStatus.error:
            return SafeArea(
              child: AppMessageView(
                icon: Icons.cloud_off_rounded,
                title: 'Não foi possível carregar',
                message: controller.errorMessage,
                actionLabel: 'Tentar novamente',
                onAction: controller.load,
              ),
            );
          case DetailStatus.loaded:
            return _DetailView(controller: controller);
        }
      }),
    );
  }
}

class _DetailView extends StatelessWidget {
  const _DetailView({required this.controller});

  final ProductDetailController controller;

  @override
  Widget build(BuildContext context) {
    final product = controller.product!;
    final producer = controller.producer;
    final lot = controller.originLot;

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductGallery(
                photoUrls: product.photoUrls,
                categoryLabel: product.byproductCategory.label,
                onBack: Get.back,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  ProductDetailPage._pad,
                  AppSpacing.xl,
                  ProductDetailPage._pad,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Header(product: product),
                    const SizedBox(height: AppSpacing.lg),
                    if (product.qualitySeals.isNotEmpty) ...[
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          for (final seal in product.qualitySeals)
                            SealBadge(seal),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                    Text(
                      product.description,
                      style: AppTypography.body(AppColors.text2),
                    ),
                    if (controller.hasTraceability) ...[
                      const SizedBox(height: AppSpacing.sect),
                      _TraceabilitySection(producer: producer, lot: lot!),
                    ],
                    const SizedBox(height: AppSpacing.sect),
                    if (producer != null)
                      _WhatsAppButton(
                        onTap: () => _openWhatsApp(context, product, producer),
                      ),
                    const SizedBox(height: AppSpacing.lg),
                    Center(
                      child: Text(
                        'Vitrine de origem · sem venda no app.',
                        style: AppTypography.meta(AppColors.text3),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Opens WhatsApp with a pre-filled message about this product.
  ///
  /// The producer contact number is not yet modelled, so a placeholder
  /// Rondônia (DDD 69) number is used; swap in `producer.whatsapp` once the
  /// field exists. Shows a snackbar if no WhatsApp handler is available.
  Future<void> _openWhatsApp(
    BuildContext context,
    Product product,
    Producer producer,
  ) async {
    const placeholderPhone = '5569999999999';
    final message = 'Olá! Tenho interesse no produto "${product.name}" '
        'de ${producer.name}. Pode me contar mais sobre a origem?';
    final uri = Uri.parse(
      'https://wa.me/$placeholderPhone?text=${Uri.encodeComponent(message)}',
    );

    final launched =
        await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Não foi possível abrir o WhatsApp.')),
        );
    }
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.byproductCategory.label.toUpperCase(),
          style: AppTypography.overline(AppColors.amberDeep),
        ),
        const SizedBox(height: 6),
        Text(product.name, style: AppTypography.title(AppColors.text)),
        const SizedBox(height: AppSpacing.md),
        InkWell(
          onTap: () => Get.toNamed(
            AppRoutes.reviews,
            arguments: ReviewsArgs(
              productId: product.id,
              productName: product.name,
              aggregateRating: product.rating,
              aggregateCount: product.reviewCount,
            ),
          ),
          borderRadius: AppRadii.brSm,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                RatingLabel(product.rating),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '${product.reviewCount} avaliações',
                  style: AppTypography.meta(AppColors.text2),
                ),
                const SizedBox(width: 2),
                const Icon(Icons.chevron_right_rounded,
                    size: 18, color: AppColors.text3),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TraceabilitySection extends StatelessWidget {
  const _TraceabilitySection({required this.producer, required this.lot});

  final Producer? producer;
  final OriginLot lot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.eco_rounded, size: 20, color: AppColors.greenDeep),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Rastreabilidade',
              style: AppTypography.section(AppColors.text),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        if (producer != null) _ProducerLinkCard(producer: producer!),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _FactCard(
                label: 'Lote',
                value: lot.id.replaceAll('lot_prd_', '').toUpperCase(),
                icon: Icons.qr_code_2_rounded,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _FactCard(
                label: 'Colheita',
                value: BrDates.monthYear(lot.harvestDate),
                icon: Icons.calendar_today_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          'Da floresta ao pote',
          style: AppTypography.bodyBold(AppColors.text),
        ),
        const SizedBox(height: AppSpacing.lg),
        Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadii.brLg,
            border: Border.all(color: AppColors.line),
          ),
          child: OriginTimeline(events: lot.timeline),
        ),
        const SizedBox(height: AppSpacing.lg),
        OriginMapStub(municipality: '${lot.municipality}, RO'),
      ],
    );
  }
}

class _ProducerLinkCard extends StatelessWidget {
  const _ProducerLinkCard({required this.producer});

  final Producer producer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.brLg,
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.greenTint,
              shape: BoxShape.circle,
            ),
            child: Icon(
              producer.isCooperative
                  ? Icons.groups_rounded
                  : Icons.person_rounded,
              color: AppColors.greenDeep,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  producer.type.label.toUpperCase(),
                  style: AppTypography.overline(AppColors.text3),
                ),
                const SizedBox(height: 2),
                Text(
                  producer.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodyBold(AppColors.text),
                ),
                Text(
                  '${producer.municipality} · RO',
                  style: AppTypography.meta(AppColors.text2),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          OutlinedButton(
            onPressed: () => Get.toNamed(
              AppRoutes.producer,
              arguments: producer.id,
            ),
            child: const Text('Ver perfil'),
          ),
        ],
      ),
    );
  }
}

class _FactCard extends StatelessWidget {
  const _FactCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.brMd,
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.amberDeep),
              const SizedBox(width: 6),
              Text(
                label.toUpperCase(),
                style: AppTypography.overline(AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: AppTypography.bodyBold(AppColors.text)),
        ],
      ),
    );
  }
}

class _WhatsAppButton extends StatelessWidget {
  const _WhatsAppButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.greenDeep,
          side: const BorderSide(color: AppColors.greenSoft),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.brPill),
        ),
        icon: const Icon(Icons.chat_rounded, size: 20),
        label: const Text('Falar com o produtor'),
      ),
    );
  }
}
