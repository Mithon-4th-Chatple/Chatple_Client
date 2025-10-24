class ScheduleItem {
  final String date; // e.g., '10/24'
  final String title; // e.g., '4-1. 주제선정 및 리서치...'
  final int dotColor; // ARGB hex like 0xFFFF7878

  const ScheduleItem({
    required this.date,
    required this.title,
    required this.dotColor,
  });
}
