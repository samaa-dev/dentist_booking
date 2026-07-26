import 'package:flutter/material.dart';

class CustomBadg extends StatelessWidget {
  const CustomBadg({
    super.key,
    required this.label,
    required this.bgcolor,
    required this.textColor,
  });

  final String label;
  final Color bgcolor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: bgcolor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
