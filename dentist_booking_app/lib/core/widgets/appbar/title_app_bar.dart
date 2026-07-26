import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class TitleAppBar {
  final String text;
  final IconData icon;
  final double? iconSize;

  TitleAppBar({
    required this.text,
    required this.icon,
    this.iconSize,
  });

  factory TitleAppBar.curd({
    required bool isEditMode,
    required String lableAdd,
    required String lableEdit,
  }) {
    return TitleAppBarCurd(
      text: isEditMode ? lableEdit : lableAdd,
      icon: isEditMode
          ? HugeIcons.strokeRoundedPencilEdit01
          : HugeIcons.strokeRoundedAddCircle,
      isEdit: isEditMode,
      lableAdd: lableAdd,
      lableEdit: lableEdit,
    );
  }

  factory TitleAppBar.empty() {
    return TitleAppBarCurd(
      text: "",
      icon: HugeIcons.strokeRoundedAddCircle,
      isEdit: false,
      lableAdd: "",
      lableEdit: "",
    );
  }
}

class TitleAppBarCurd extends TitleAppBar {
  final bool isEdit;
  final String lableEdit;
  final String lableAdd;

  TitleAppBarCurd({
    required super.text,
    required super.icon,
    required this.isEdit,
    required this.lableEdit,
    required this.lableAdd,
  });
}
