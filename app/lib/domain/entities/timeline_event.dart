/// A single step in a lot's farm-to-product traceability timeline
/// (e.g. Colheita → Fermentação → Secagem → Envase).
class TimelineEvent {
  const TimelineEvent({
    required this.title,
    required this.description,
    required this.date,
  });

  final String title;
  final String description;
  final DateTime date;
}
