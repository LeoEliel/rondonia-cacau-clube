import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/coming_soon_view.dart';
import '../controllers/club_controller.dart';

/// Cocoa Club (subscription) tab. Placeholder body for Milestone 1.
class ClubPage extends GetView<ClubController> {
  const ClubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.club)),
      body: const ComingSoonView(
        icon: Icons.workspace_premium_outlined,
        title: AppStrings.club,
      ),
    );
  }
}
