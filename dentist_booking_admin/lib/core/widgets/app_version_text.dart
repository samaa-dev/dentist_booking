import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersionText extends StatelessWidget {
  const AppVersionText({super.key});

  Future<String> _getVersionApp() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return 'v${packageInfo.version}';
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.outline.withOpacity(0.5);
    final textTheme = Theme.of(context).textTheme;

    return FutureBuilder<String>(
      future: _getVersionApp(),
      builder: (context, snapshot) {
        final version = snapshot.data ?? "v0.0.0";

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.verified,
              size: 11,
              color: color,
            ),
            SizedBox(width: 4),
            Text(
              version,
              style: textTheme.labelSmall!.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 10,
                letterSpacing: 0.3,
                color: color,
              ),
            ),
          ],
        );
      },
    );
  }
}
