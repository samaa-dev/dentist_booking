import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    this.maxLines,
    this.hintText = '',
    required this.keyboardType,
    required this.controller,
    this.contentPadding,
    this.border,
    this.prefixIcon,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.prefixText,
    this.validator,
    this.textInputAction = TextInputAction.done,
    this.suffixIcon,
    this.obscureText = false,
    this.labelText = '',
    this.onEditingComplete,
    this.onChanged,
    this.autocorrect = false,
    this.autofocus = false,
    this.onSaved,
    this.onFieldSubmitted,
    this.fillColor,
    this.filled,
    this.readOnly,
    this.focusNode,
  });

  final int? maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String hintText;
  final String labelText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final String? prefixText;
  final Function(String? value)? validator;
  final TextInputAction textInputAction;
  final bool obscureText;
  final Function()? onEditingComplete;
  final Function(String)? onChanged;
  final Function()? onSaved;
  final Function()? onFieldSubmitted;
  final bool autocorrect;
  final bool autofocus;
  final Color? fillColor;
  final bool? filled;
  final bool? readOnly;
  final FocusNode? focusNode;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final contentPadding =
        widget.contentPadding ??
        EdgeInsets.symmetric(
          horizontal: isRtl ? 20 : 20,
          vertical: 18,
        );

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: TextFormField(
        maxLines: widget.maxLines ?? 1,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        style: textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        autofocus: widget.autofocus,
        readOnly: widget.readOnly ?? false,
        textInputAction: widget.textInputAction,
        focusNode: widget.focusNode,

        decoration: InputDecoration(
          // 🔄 تغيير الأيقونات حسب الاتجاه
          prefixIcon: widget.prefixIcon,

          suffixIcon: widget.suffixIcon,
          prefixText: widget.prefixText,

          label: widget.labelText.isNotEmpty
              ? Text(
                  widget.labelText,
                  style: textTheme.bodyMedium!.copyWith(
                    color: colorScheme.onPrimaryContainer.withOpacity(0.6),
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,

          hintText: widget.hintText,
          hintStyle: textTheme.bodyMedium!.copyWith(
            color: colorScheme.onPrimaryContainer.withOpacity(0.6),
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),

          contentPadding: contentPadding,

          filled: widget.filled ?? true,
          fillColor: widget.fillColor ?? colorScheme.primary.withAlpha(25),

          // 🔘 Borders
          enabledBorder:
              widget.enabledBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 1.5,
                ),
              ),

          focusedBorder:
              widget.focusedBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 1.5,
                ),
              ),

          errorBorder:
              widget.errorBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: colorScheme.error,
                  width: 1.5,
                ),
              ),

          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: colorScheme.error,
              width: 1.5,
            ),
          ),
        ),

        validator: (value) => widget.validator?.call(value),

        onFieldSubmitted: (_) => widget.onFieldSubmitted?.call(),

        onEditingComplete: () {
          widget.onEditingComplete?.call();
          FocusManager.instance.primaryFocus?.unfocus();
        },

        onSaved: (value) => widget.onSaved?.call(),

        onChanged: (value) => widget.onChanged?.call(value),

        autocorrect: widget.autocorrect,
      ),
    );
  }
}
