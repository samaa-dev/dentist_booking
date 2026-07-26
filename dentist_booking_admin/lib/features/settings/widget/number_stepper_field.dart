import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberStepperField extends StatefulWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const NumberStepperField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<NumberStepperField> createState() => _NumberStepperFieldState();
}

class _NumberStepperFieldState extends State<NumberStepperField> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.value.toString());
  }

  void _updateValue(int newValue) {
    if (newValue < 0) return;
    controller.text = newValue.toString();
    widget.onChanged(newValue);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ---------------- Minus Button ----------------
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              final int val = int.parse(controller.text);
              _updateValue(val - 1);
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.8),
                borderRadius: BorderRadius.circular(36),
              ),
              child: Icon(Icons.remove, size: 18, color: colorScheme.onPrimary),
            ),
          ),

          const SizedBox(width: 10),

          // ---------------- Text Field (Expanded) ----------------
          Expanded(
            child: Center(
              child: TextField(
                controller: controller,
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge!.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  if (value.isEmpty) return;
                  _updateValue(int.parse(value));
                },
              ),
            ),
          ),

          const SizedBox(width: 10),

          // ---------------- Plus Button ----------------
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              final int val = int.parse(controller.text);
              _updateValue(val + 1);
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.8),
                borderRadius: BorderRadius.circular(36),
              ),
              child: Icon(Icons.add, size: 18, color: colorScheme.onPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
