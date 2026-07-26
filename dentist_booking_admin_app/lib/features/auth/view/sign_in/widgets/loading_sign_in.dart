import 'package:flutter/material.dart';

import '../../../../../core/widgets/footer_view.dart';

class LoadingSignIn extends StatelessWidget {
  const LoadingSignIn({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 160,
                height: 160,
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
                  child: CircularProgressIndicator(
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const FooterView(),
            ],
          ),
        ),
      ),
    );
  }
}
