import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final List<Map<String, dynamic>> services = [
      {"icon": HugeIcons.strokeRoundedDentalTooth},
      {"icon": HugeIcons.strokeRoundedAbacus},
      {"icon": HugeIcons.strokeRoundedAbacus},
      {"icon": HugeIcons.strokeRoundedDentalCare},
      {"icon": HugeIcons.strokeRoundedAbacus},
      {"icon": HugeIcons.strokeRoundedAbacus},
      {"icon": HugeIcons.strokeRoundedAbacus},
    ];

    return SizedBox(
      height: 70,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: services.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final item = services[index];

          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 400 + (index * 120)),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value.clamp(0.0, 1.0),
                child: Opacity(
                  opacity: value.clamp(0.0, 1.0),
                  child: child,
                ),
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.10),
                border: Border.all(
                  color: colorScheme.primary.withOpacity(0.18),
                  width: 1,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                item["icon"],
                color: colorScheme.primary,
                size: 28,
              ),
            ),
          );
        },
      ),
    );
  }
}
