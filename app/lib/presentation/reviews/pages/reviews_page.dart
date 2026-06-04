import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/br_dates.dart';
import '../../../core/widgets/app_message_view.dart';
import '../../../domain/entities/review.dart';
import '../controllers/reviews_controller.dart';
import '../widgets/star_row.dart';

/// Product Reviews screen (design `08 _ Avaliações`).
///
/// Aggregate summary with a star-distribution histogram, an inline rating
/// selector + "Escrever avaliação" action that opens a write sheet, and the
/// list of reviews (author initials, relative time, stars and text).
class ReviewsPage extends GetView<ReviewsController> {
  const ReviewsPage({super.key});

  static const double _pad = AppSpacing.pad;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: Get.back,
        ),
        title: const Text('Avaliações'),
        centerTitle: true,
      ),
      body: Obx(() {
        switch (controller.status) {
          case ReviewsStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case ReviewsStatus.error:
            return AppMessageView(
              icon: Icons.cloud_off_rounded,
              title: 'Não foi possível carregar',
              message: controller.errorMessage,
              actionLabel: 'Tentar novamente',
              onAction: controller.load,
            );
          case ReviewsStatus.loaded:
            return _ReviewsView(controller: controller);
        }
      }),
    );
  }
}

class _ReviewsView extends StatelessWidget {
  const _ReviewsView({required this.controller});

  final ReviewsController controller;

  @override
  Widget build(BuildContext context) {
    final reviews = controller.reviews;
    final cs = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        ReviewsPage._pad,
        AppSpacing.lg,
        ReviewsPage._pad,
        AppSpacing.xxl,
      ),
      children: [
        _SummaryCard(controller: controller),
        const SizedBox(height: AppSpacing.lg),
        _WriteCard(controller: controller),
        const SizedBox(height: AppSpacing.sect),
        if (reviews.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xl),
            child: Text(
              'Seja o primeiro a avaliar este produto.',
              style: AppTypography.body(cs.onSurfaceVariant),
            ),
          )
        else
          for (var i = 0; i < reviews.length; i++) ...[
            _ReviewTile(review: reviews[i]),
            if (i != reviews.length - 1)
              Divider(height: AppSpacing.sect, color: cs.outlineVariant),
          ],
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.controller});

  final ReviewsController controller;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: AppRadii.brLg,
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                controller.averageRating.toStringAsFixed(1),
                style: AppTypography.display(cs.onSurface),
              ),
              StarRow(
                rating: controller.averageRating.round(),
                size: 16,
              ),
              const SizedBox(height: 4),
              Text(
                '${controller.totalCount} avaliações',
                style: AppTypography.meta(cs.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.xl),
          Expanded(child: _Histogram(controller: controller)),
        ],
      ),
    );
  }
}

class _Histogram extends StatelessWidget {
  const _Histogram({required this.controller});

  final ReviewsController controller;

  @override
  Widget build(BuildContext context) {
    final distribution = controller.distribution;
    final total = controller.loadedCount;
    return Column(
      children: [
        for (var star = 5; star >= 1; star--)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: _HistogramRow(
              star: star,
              fraction: total == 0 ? 0 : (distribution[star] ?? 0) / total,
            ),
          ),
      ],
    );
  }
}

class _HistogramRow extends StatelessWidget {
  const _HistogramRow({required this.star, required this.fraction});

  final int star;
  final double fraction;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Text('$star', style: AppTypography.meta(cs.onSurfaceVariant)),
        const SizedBox(width: 4),
        const Icon(Icons.star_rounded, size: 12, color: AppColors.amber),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: ClipRRect(
            borderRadius: AppRadii.brPill,
            child: LinearProgressIndicator(
              value: fraction,
              minHeight: 6,
              backgroundColor: cs.surfaceContainerHighest,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.amber),
            ),
          ),
        ),
      ],
    );
  }
}

class _WriteCard extends StatelessWidget {
  const _WriteCard({required this.controller});

  final ReviewsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.amberTint,
        borderRadius: AppRadii.brLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Como foi sua experiência?',
            style: AppTypography.section(AppColors.text),
          ),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: Obx(() => StarRow(
                  rating: controller.draftRating.value,
                  size: 34,
                  onTap: controller.setDraftRating,
                )),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _openWriteSheet(context, controller),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.amber,
                foregroundColor: AppColors.surface,
                padding:
                    const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                shape: const RoundedRectangleBorder(
                    borderRadius: AppRadii.brPill),
              ),
              icon: const Icon(Icons.edit_rounded, size: 18),
              label: const Text('Escrever avaliação'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Opens the bottom sheet where the user picks a rating (synced with the inline
/// selector) and writes the review text.
Future<void> _openWriteSheet(
  BuildContext context,
  ReviewsController controller,
) async {
  final textController = TextEditingController();
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.lg)),
    ),
    builder: (sheetContext) => Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.pad,
        right: AppSpacing.pad,
        top: AppSpacing.xl,
        bottom: MediaQuery.of(sheetContext).viewInsets.bottom + AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sua avaliação', style: AppTypography.section(AppColors.text)),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: Obx(() => StarRow(
                  rating: controller.draftRating.value,
                  size: 34,
                  onTap: controller.setDraftRating,
                )),
          ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: textController,
            minLines: 3,
            maxLines: 5,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              hintText: 'Conte como foi o produto…',
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: Obx(() => ElevatedButton(
                  onPressed: controller.submitting.value
                      ? null
                      : () async {
                          final error =
                              await controller.submit(textController.text);
                          if (!sheetContext.mounted) return;
                          if (error == null) {
                            Navigator.of(sheetContext).pop();
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(const SnackBar(
                                content: Text('Avaliação publicada. Obrigado!'),
                              ));
                          } else {
                            ScaffoldMessenger.of(sheetContext)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                  SnackBar(content: Text(error)));
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.amber,
                    foregroundColor: AppColors.surface,
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                    shape: const RoundedRectangleBorder(
                        borderRadius: AppRadii.brPill),
                  ),
                  child: controller.submitting.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(AppColors.surface),
                          ),
                        )
                      : const Text('Enviar avaliação'),
                )),
          ),
        ],
      ),
    ),
  );
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.review});

  final Review review;

  @override
  Widget build(BuildContext context) {
    final name = review.userName ?? 'Anônimo';
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ReviewAvatar(name: name),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTypography.bodyBold(cs.onSurface)),
                  Text(
                    BrDates.relative(review.createdAt),
                    style: AppTypography.meta(cs.outline),
                  ),
                ],
              ),
            ),
            StarRow(rating: review.rating, size: 14),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(review.text, style: AppTypography.body(cs.onSurfaceVariant)),
      ],
    );
  }
}

class _ReviewAvatar extends StatelessWidget {
  const _ReviewAvatar({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final initials = name
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0].toUpperCase())
        .join();
    return Container(
      width: 38,
      height: 38,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.greenTint,
        shape: BoxShape.circle,
      ),
      child: Text(initials, style: AppTypography.meta(AppColors.greenDeep)),
    );
  }
}
