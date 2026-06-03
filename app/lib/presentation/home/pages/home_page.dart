import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/controllers/theme_controller.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/coming_soon_view.dart';
import '../controllers/home_controller.dart';

/// Home / Catalog tab. Milestone 1 ships the branded app bar (logo + theme
/// toggle) and a placeholder body; the catalog UI lands next milestone.
class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: AppSpacing.lg,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.sm),
              child: Image.asset(
                AppAssets.logo,
                height: 36,
                width: 36,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                AppStrings.appName,
                style: theme.textTheme.titleLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          Obx(
            () => IconButton(
              tooltip: 'Alternar tema',
              onPressed: themeController.toggle,
              icon: Icon(
                themeController.isDark
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: const ComingSoonView(
        icon: Icons.storefront_outlined,
        title: AppStrings.home,
      ),
    );
  }
}
