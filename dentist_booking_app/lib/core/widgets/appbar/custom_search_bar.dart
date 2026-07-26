import 'package:flutter/material.dart';

import 'app_bar.dart';

class CustomSearchBar extends CustomAppBar {
  const CustomSearchBar({
    super.key,
    required this.hint,
    required this.searchBarController,
    required this.onSearchCallback,
    this.isCollectionSearch = false,
    this.isShowSearch = true,
    this.actions,
    this.titleApp,
    this.searchTrailing,
    this.subTitleWidget,
    required this.isShowBackButton,
  });

  final String hint;
  final TextEditingController searchBarController;
  final void Function(String) onSearchCallback;
  final TitleAppBar? titleApp;
  final bool isCollectionSearch;
  final bool isShowSearch;
  final List<Widget>? actions;
  final Widget? searchTrailing;
  final Widget? subTitleWidget;
  final bool isShowBackButton;

  @override
  List<Widget>? get action => actions;

  @override
  Widget? get searchBarTrailing => searchTrailing;

  @override
  bool get isCollectionSearchBar => isCollectionSearch;

  @override
  TitleAppBar? get titleAppBar => titleApp;

  @override
  bool get isShowSearchBar => isShowSearch;

  @override
  bool get isShowLeading => isShowBackButton;

  @override
  String get hintText => hint;

  @override
  Function(String)? get onSearch => onSearchCallback;

  @override
  TextEditingController? get searchController => searchBarController;

  @override
  Widget? get subTitle => subTitleWidget;

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      hintText: hint,
      titleAppBar: titleApp,
      isCollectionSearchBar: isCollectionSearch,
      isShowSearchBar: isShowSearch,
      searchController: searchBarController,
      onSearch: onSearchCallback,
      action: actions,
      searchBarTrailing: searchTrailing,
      subTitle: subTitleWidget,
      isShowLeading: isShowBackButton,
    );
  }
}
