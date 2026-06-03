import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/category_labels.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_message_view.dart';
import '../../../core/widgets/product_card.dart';
import '../../../domain/entities/product.dart';
import '../controllers/home_controller.dart';
import '../widgets/catalog_search_field.dart';
import '../widgets/category_chip.dart';
import '../widgets/hero_featured_card.dart';
import '../widgets/home_app_header.dart';

/// Home / Catalog screen. Header + search entry, "Em destaque" hero, byproduct
/// category chips and a grid of product cards, wired to Firestore via
/// [HomeController]. Handles loading, error and empty states.
class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  static const double _pad = AppSpacing.pad;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          switch (controller.status) {
            case HomeStatus.loading:
              return const _LoadingView();
            case HomeStatus.error:
              return AppMessageView(
                icon: Icons.cloud_off_rounded,
                title: 'Não foi possível carregar',
                message: controller.errorMessage,
                actionLabel: 'Tentar novamente',
                onAction: controller.load,
              );
            case HomeStatus.loaded:
              return RefreshIndicator(
                onRefresh: controller.load,
                child: _CatalogView(controller: controller),
              );
          }
        }),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Carregando catálogo…',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

class _CatalogView extends StatelessWidget {
  const _CatalogView({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final featured = controller.featuredProduct;
    final products = controller.visibleProducts;

    return CustomScrollView(
      slivers: [
        // Header + search + hero
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              HomePage._pad,
              AppSpacing.sm,
              HomePage._pad,
              0,
            ),
            child: Column(
              children: [
                const HomeAppHeader(),
                const SizedBox(height: AppSpacing.lg),
                CatalogSearchField(onTap: controller.goToSearch),
                if (featured != null) ...[
                  const SizedBox(height: AppSpacing.sect),
                  HeroFeaturedCard(
                    kicker: 'Em destaque · Safra 2026',
                    title: 'Mel de cacau,\no ouro da floresta',
                    seal: featured.qualitySeals.isNotEmpty
                        ? featured.qualitySeals.first
                        : null,
                    municipality:
                        controller.featuredProducer?.municipality,
                    onTap: () => _showSoon(context),
                  ),
                ],
              ],
            ),
          ),
        ),

        // Category chips
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sect),
            child: _CategoryChips(controller: controller),
          ),
        ),

        // Section header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              HomePage._pad,
              AppSpacing.xl,
              HomePage._pad,
              AppSpacing.lg,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Destaques', style: theme.textTheme.headlineMedium),
                if (controller.selectedCategory != null)
                  TextButton(
                    onPressed: controller.clearCategory,
                    child: const Text('Ver tudo'),
                  ),
              ],
            ),
          ),
        ),

        // Grid or empty state
        if (products.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
              child: AppMessageView(
                icon: Icons.search_off_rounded,
                title: 'Nada por aqui ainda',
                message: 'Nenhum produto nesta categoria.',
                actionLabel: 'Ver todos',
                onAction: controller.clearCategory,
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: HomePage._pad),
            sliver: SliverGrid(
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppSpacing.gap,
                crossAxisSpacing: AppSpacing.gap,
                childAspectRatio: 0.60,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final Product product = products[index];
                  return ProductCard(
                    product: product,
                    municipality:
                        controller.municipalityFor(product.producerId),
                    onTap: () => _showSoon(context),
                  );
                },
                childCount: products.length,
              ),
            ),
          ),

        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
      ],
    );
  }

  void _showSoon(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Detalhes do produto chegam na próxima etapa.'),
        ),
      );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final selected = controller.selectedCategory;
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: HomePage._pad),
        children: [
          CategoryChip(
            label: 'Todos',
            selected: selected == null,
            onTap: () => controller.selectCategory(null),
          ),
          const SizedBox(width: AppSpacing.gapSm),
          for (final category in kCatalogCategories) ...[
            CategoryChip(
              label: category.label,
              selected: selected == category,
              onTap: () => controller.selectCategory(category),
            ),
            const SizedBox(width: AppSpacing.gapSm),
          ],
        ],
      ),
    );
  }
}
