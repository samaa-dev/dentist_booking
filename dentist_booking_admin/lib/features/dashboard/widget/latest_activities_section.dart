import 'package:flutter/material.dart';

class LatestActivitiesSection extends StatelessWidget {
  const LatestActivitiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final items = [
      ("تم إضافة حجز جديد", Icons.add, "منذ 5 دقائق"),
      ("تم تعديل حالة الحجز رقم 4", Icons.edit, "منذ 12 دقيقة"),
      ("تم إلغاء الحجز رقم 7", Icons.close, "قبل 30 دقيقة"),
      ("تم نشر إعلان جديد", Icons.campaign, "قبل ساعة"),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: scheme.outline.withOpacity(.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "آخر الأنشطة",
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text("عرض الكل"),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (int i = 0; i < items.length; i++) ...[
            ActivityTile(
              title: items[i].$1,
              icon: items[i].$2,
              time: items[i].$3,
            ),
            if (i != items.length - 1)
              Divider(color: scheme.outline.withOpacity(.15)),
          ],
        ],
      ),
    );
  }
}

class ActivityTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final String time;

  const ActivityTile({
    super.key,
    required this.title,
    required this.icon,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: scheme.primary.withOpacity(.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: scheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: TextStyle(
                    color: scheme.onSurface.withOpacity(.65),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
