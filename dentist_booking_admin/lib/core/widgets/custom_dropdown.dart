import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import 'custom_text_form_field.dart';

class CustomDropdown<T> extends StatefulWidget {
  const CustomDropdown({
    super.key,
    required this.hintText,
    required this.items,
    required this.onChanged,
    this.validator,
    this.value,
    this.enableSearch = true,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 15),
    this.fullColor,
  });

  final String hintText;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;
  final T? value;
  final bool enableSearch;
  final EdgeInsetsGeometry? contentPadding;

  final Color? fullColor;

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return DropdownButtonFormField2<T>(
      hint: Text(
        widget.hintText,
        style: textTheme.bodyMedium!.copyWith(
          color: colorScheme.onPrimaryContainer.withOpacity(0.6),
          fontWeight: FontWeight.bold,
        ),
      ),

      // customButton: Icon(Icons.add_ic_call),
      isExpanded: true,
      items: widget.items,
      validator: widget.validator,
      value: widget.value,

      iconStyleData: IconStyleData(
        openMenuIcon: const Icon(
          HugeIcons.strokeRoundedArrowUp01,
          size: 18,
        ),
        iconEnabledColor: colorScheme.primary,
        iconDisabledColor: colorScheme.onPrimaryContainer.withOpacity(0.3),
        icon: const Icon(
          HugeIcons.strokeRoundedArrowDown01,
          size: 18,
        ),
      ),

      onMenuStateChange: (isOpen) {
        if (isOpen) {
          _searchController.clear();
          setState(() {});
        } else {}
      },
      onChanged: widget.onChanged,
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: colorScheme.onPrimary,
        ),
      ),

      decoration: InputDecoration(
        isCollapsed: true,
        contentPadding: widget.contentPadding,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          // borderSide: BorderSide(
          //   width: 1.5,
          //   color: colorScheme.onPrimaryContainer.withOpacity(0.15),
          // ),
        ),
        isDense: false,
        filled: true,
        fillColor: widget.fullColor ?? colorScheme.primary.withAlpha(20),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(
            width: 1.5,
            color: colorScheme.error,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(
            width: 1,
            color: colorScheme.onPrimaryContainer.withOpacity(0.15),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(
            width: 1,
            color: colorScheme.onPrimaryContainer.withOpacity(0.15),
          ),
        ),
      ),

      style: textTheme.bodyMedium!.copyWith(
        fontWeight: FontWeight.bold,
        color: colorScheme.onSecondaryContainer,
      ),
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 10, left: 10),
      ),

      dropdownButtonKey: const Key('custom_dropdown_button'),
      dropdownSearchData: widget.enableSearch
          ? DropdownSearchData(
              searchInnerWidgetHeight: 20,
              searchController: _searchController,
              searchInnerWidget: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 50,
                  child: CustomTextFormField(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    hintText: 'Search',
                    border: InputBorder.none,
                    validator: (value) => null,
                    controller: _searchController,
                    keyboardType: TextInputType.text,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close_rounded),
                      padding: EdgeInsets.zero,
                      onPressed: () => {
                        if (_searchController.text.isNotEmpty)
                          {
                            _searchController.clear(),
                            setState(() {}),
                          },
                      },
                    ),
                  ),
                ),
              ),
              searchMatchFn: (item, searchValue) {
                return item.value.toString().toLowerCase().contains(
                      searchValue.toLowerCase(),
                    ) ||
                    (item.child is Text
                        ? (item.child as Text).data?.toLowerCase().contains(
                                searchValue.toLowerCase(),
                              ) ??
                              false
                        : false);
              },
            )
          : null,
    );
  }
}
