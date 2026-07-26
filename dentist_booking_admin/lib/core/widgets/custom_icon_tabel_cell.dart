import 'package:flutter/material.dart';

class CustomIconTabelCell extends StatelessWidget {
  const CustomIconTabelCell({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(36),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: color.withOpacity(.12),
          borderRadius: BorderRadius.circular(36),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}
