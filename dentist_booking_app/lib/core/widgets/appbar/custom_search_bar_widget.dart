import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class CustomSearchBarWidget extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final Function(String) onSearch;
  final Widget? searchTrailinsg;
  final List<String>? hintTextList;

  const CustomSearchBarWidget({
    super.key,
    required this.hintText,
    required this.controller,
    required this.onSearch,
    this.searchTrailinsg,
    this.hintTextList,
  });

  @override
  State<CustomSearchBarWidget> createState() => _CustomSearchBarWidgetState();
}

class _CustomSearchBarWidgetState extends State<CustomSearchBarWidget> {
  Timer? _debounce;
  final FocusNode focusNode = FocusNode();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleTextChanged);
    _hasText = widget.controller.text.isNotEmpty;
  }

  void _handleTextChanged() {
    final hasText = widget.controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    focusNode.dispose();
    widget.controller.removeListener(_handleTextChanged);
    super.dispose();
  }

  void _onTextChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onSearch(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: Row(
          children: [
            Icon(
              HugeIcons.strokeRoundedSearch01,
              color: colorScheme.outline,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                focusNode: focusNode,
                controller: widget.controller,
                onChanged: _onTextChanged,
                textInputAction: TextInputAction.search,
                textCapitalization: TextCapitalization.none,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.outline,
                    fontWeight: FontWeight.bold,
                  ),

                  border: InputBorder.none,
                  isDense: true,
                ),
                onTapOutside: (_) => focusNode.unfocus(),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: _hasText
                  ? IconButton(
                      key: const ValueKey('clear_button'),
                      icon: Icon(
                        HugeIcons.strokeRoundedCancel01,
                        color: colorScheme.outline,
                        size: 20,
                      ),
                      onPressed: () {
                        widget.controller.clear();
                        widget.onSearch('');
                        focusNode.unfocus();
                      },
                      // padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      // splashRadius: 20,::
                    )
                  : const SizedBox.shrink(key: ValueKey('empty')),
            ),
            if (widget.searchTrailinsg != null) ...[
              widget.searchTrailinsg!,
              const SizedBox(width: 5),
            ],
          ],
        ),
      ),
    );
  }
}
