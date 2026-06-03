import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/coming_soon_view.dart';
import '../controllers/profile_controller.dart';

/// Profile tab. Placeholder body for Milestone 1.
class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.profile)),
      body: const ComingSoonView(
        icon: Icons.person_outline,
        title: AppStrings.profile,
      ),
    );
  }
}
