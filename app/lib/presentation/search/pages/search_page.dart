import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/coming_soon_view.dart';
import '../controllers/search_controller.dart';

/// Search & Filters tab. Placeholder body for Milestone 1.
class SearchPage extends GetView<SearchTabController> {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.search)),
      body: const ComingSoonView(
        icon: Icons.search,
        title: AppStrings.search,
      ),
    );
  }
}
