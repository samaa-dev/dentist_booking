import 'package:flutter/material.dart';

import '../../../../../core/widgets/footer_view.dart';

class LoadingSignIn extends StatelessWidget {
  const LoadingSignIn({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final size = MediaQuery.of(context).size;

    /// Responsive width
    double cardWidth = size.width * 0.30;
    if (cardWidth < 450) cardWidth = 450;
    if (cardWidth > 600) cardWidth = 600;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: cardWidth,
              height: cardWidth,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 28),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 15,
                    color: colorScheme.primary.withOpacity(0.3),
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: SizedBox(
                  child: CircularProgressIndicator(
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),

          FooterView(),
        ],
      ),
    );
  }
}
