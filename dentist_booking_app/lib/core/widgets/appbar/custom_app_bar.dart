import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import 'app_bar.dart';
import 'custom_search_bar_widget.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.action,
    this.leading,
    this.titleAppBar,
    this.searchController,
    this.onSearch,
    this.isShowSearchBar = false,
    this.isCollectionSearchBar = false,
    this.hintText = '',
    this.searchBarTrailing,
    this.onSearchBarTrailingPressed,
    this.elevation = 1.0,
    this.subTitle,
    this.isShowLeading = false,
  });

  final double? elevation;
  final TitleAppBar? titleAppBar;
  final List<Widget>? action;
  final Widget? leading;
  final bool isCollectionSearchBar;
  final bool isShowSearchBar;
  final TextEditingController? searchController;
  final Function(String query)? onSearch;
  final String hintText;
  final Widget? searchBarTrailing;
  final VoidCallback? onSearchBarTrailingPressed;
  final Widget? subTitle;
  final bool isShowLeading;

  factory CustomAppBar.search({
    required String hintText,
    TitleAppBar? titleAppBar,
    bool isCollectionSearchBar = false,
    bool isShowSearchBar = true,
    List<Widget>? action,
    required TextEditingController searchController,
    required Function(String query) onSearch,
    Widget? searchBarTrailing,
    Widget? subTitle,
    bool isShowLeading = false,
  }) {
    return CustomSearchBar(
      titleApp:
          titleAppBar ??
          TitleAppBar(
            text: 'Search',
            icon: HugeIcons.strokeRoundedSearchCircle,
          ),
      hint: hintText,
      isShowSearch: false,
      isCollectionSearch: true,
      onSearchCallback: onSearch,
      searchBarController: searchController,
      actions: action,
      searchTrailing: searchBarTrailing,
      subTitleWidget: subTitle,
      isShowBackButton: isShowLeading,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      // forceMaterialTransparency: true,
      elevation: elevation,
      title: _buildTitle(context),
      leading: _buildLeading(context),
      bottom: _buildBottom(),
      // actions: action,
    );
  }

  Widget _buildTitle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (!isShowSearchBar || isCollectionSearchBar) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: titleAppBar != null
            ? [
                Icon(
                  titleAppBar!.icon,
                  color: colorScheme.primary,
                  size: 23,
                ),
                const SizedBox(width: 8),
                Text(
                  titleAppBar!.text,
                  style: textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]
            : [
                Icon(
                  HugeIcons.strokeRoundedBlockGame,
                  color: colorScheme.primary,
                  size: 26,
                ),
                const SizedBox(width: 8),
                Text.rich(
                  TextSpan(
                    text: 'Studio',
                    style: textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: ' Badilk',
                        style: textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget? _buildLeading(BuildContext context) {
    final ltr = Directionality.of(context) == TextDirection.ltr;

    return (isShowSearchBar && !isCollectionSearchBar) ||
            (!(isShowSearchBar && !isCollectionSearchBar) && isShowLeading)
        // ||
        // (isShowSearchBar && isCollectionSearchBar && leading != null)
        ? leading ??
              IconButton(
                icon: ltr
                    ? const Icon(
                        HugeIcons.strokeRoundedArrowLeft01,
                      )
                    : const Icon(
                        HugeIcons.strokeRoundedArrowRight01,
                      ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
        //             bool isCollectionSearchBar = false,
        // bool isShowSearchBar = true,
        : null;
  }

  PreferredSizeWidget? _buildBottom() {
    if (isShowSearchBar || isCollectionSearchBar) {
      return PreferredSize(
        preferredSize: const Size.fromHeight(95),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: CustomSearchBarWidget(
                      hintText: hintText,
                      controller: searchController!,
                      onSearch: onSearch!,
                      searchTrailinsg: searchBarTrailing,
                    ),
                  ),
                  if (isCollectionSearchBar && action != null) ...action!,
                ],
              ),
            ),

            if (subTitle != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: subTitle!,
              )
            else
              const SizedBox(height: 5),
            if (subTitle != null) const SizedBox(height: 5),
          ],
        ),
      );
    }
    return null;
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(
      isShowSearchBar
          ? 65
          : isCollectionSearchBar
          ? subTitle != null
                ? 145
                : 120
          : 56,
    );
  }
}
