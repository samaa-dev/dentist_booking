import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BookingItemShimmer extends StatelessWidget {
  const BookingItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Shimmer.fromColors(
      baseColor: colorScheme.primaryContainer.withOpacity(0.5),
      highlightColor: colorScheme.primary.withOpacity(0.2),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white,
          ),
        ),
        child: Column(
          children: [
            _shimmerLine(width: double.infinity, height: 18),
            const SizedBox(height: 10),
            Row(
              children: [
                _shimmerLine(width: 70, height: 24),
                const SizedBox(width: 12),
                _shimmerLine(width: 60, height: 24),
              ],
            ),
            const SizedBox(height: 10),
            _shimmerLine(width: 160, height: 16),
          ],
        ),
      ),
    );
  }

  Widget _shimmerLine({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
