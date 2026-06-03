import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/br_dates.dart';
import '../../../domain/entities/timeline_event.dart';

/// "Da floresta ao pote" — the farm-to-product traceability timeline.
///
/// Renders each [TimelineEvent] as a node on an amber rail: a numbered dot
/// connected by a vertical line, with the step title, description and date.
class OriginTimeline extends StatelessWidget {
  const OriginTimeline({super.key, required this.events});

  final List<TimelineEvent> events;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < events.length; i++)
          _TimelineNode(
            index: i + 1,
            event: events[i],
            isLast: i == events.length - 1,
          ),
      ],
    );
  }
}

class _TimelineNode extends StatelessWidget {
  const _TimelineNode({
    required this.index,
    required this.event,
    required this.isLast,
  });

  final int index;
  final TimelineEvent event;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Rail: numbered dot + connecting line.
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.amber,
                  shape: BoxShape.circle,
                ),
                child: Text('$index', style: AppTypography.seal(Colors.white)),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppColors.line2,
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.lg),
          // Content.
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: AppTypography.bodyBold(AppColors.text),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    event.description,
                    style: AppTypography.body(AppColors.text2),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    BrDates.dayMonth(event.date),
                    style: AppTypography.overline(AppColors.amberDeep),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
