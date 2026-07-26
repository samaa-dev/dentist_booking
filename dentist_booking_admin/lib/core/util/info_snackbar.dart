import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class SnackbarMes {
  static void showToastMsg(
    BuildContext context, {
    required String message,
  }) {
    showToast(
      message,
      context: context,
      animation: StyledToastAnimation.fade,
      position: const StyledToastPosition(
        align: Alignment.bottomCenter,
        offset: 90.0,
      ),
      reverseAnimation: StyledToastAnimation.fade,
      borderRadius: const BorderRadius.all(Radius.circular(32.0)),
      textStyle: const TextStyle(color: Colors.white, fontSize: 12),
    );
  }

  static void showCustomBottomSheet({
    required BuildContext context,
    required Widget child,
    bool isExpanded = false,
  }) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: true,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(32),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              child,
              // const SizedBox(height: 50),
              isExpanded == true
                  ? const SizedBox.shrink()
                  : const SizedBox(height: 50),
            ],
          ),
        );
      },
    );
  }

  static void goToUrl(BuildContext context, {String? url}) async {
    if (url == null) {
      showToastMsg(context, message: 'Link is not available');
      return;
    }

    await launchUrl(Uri.parse(url));
  }

  static Future<void> launchWhatsApp(
    String phoneNumber, {
    String? message,
  }) async {
    final encodedMessage = Uri.encodeComponent(message ?? '');
    final url = Uri.parse("https://wa.me/$phoneNumber?text=$encodedMessage");

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint("❌ Could not launch WhatsApp");
    }
  }

  static void showCustomDialog(
    BuildContext context, {
    required String title,
    required String content,
    bool barrierDismissible = true,
    required String buttonCancelText,
    required String buttonConfirmText,
    required Function() onCancel,
    required Function() onConfirm,
    bool useRootNavigator = true,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              onPressed: () => onCancel(),
              child: Text(buttonCancelText),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              onPressed: () => onConfirm(),
              child: Text(buttonConfirmText),
            ),
          ],
        );
      },
    );
  }

  static void launchTelegram({
    required BuildContext context,
    required String usernameOrGroupLink,
  }) async {
    late String url;

    if (usernameOrGroupLink.startsWith('https://t.me/')) {
      url = usernameOrGroupLink;
    } else {
      url = 'https://t.me/$usernameOrGroupLink';
      debugPrint('usernameOrGroupLink: $url');
    }

    final uri = Uri.parse(url);
    // if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
    // } else {
    //   if (!context.mounted) return;

    //   showToastMsg(context, message: 'No Telegram installed');
    //   debugPrint('❌ لا يمكن فتح رابط تلغرام: $url');
    // }
  }

  static void showPremiumDialog(BuildContext context) {
    //   showDialog(
    //     context: context,
    //     builder: (_) => AlertDialog(
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(16),
    //       ),
    //       title: Row(
    //         children: [
    //           Icon(
    //             HugeIcons.strokeRoundedStarCircle,
    //             color: Theme.of(context).colorScheme.primary,
    //           ),
    //           const SizedBox(width: 8),
    //           // Text(LocaleKeys.PremiumFeature.trnsltd),
    //         ],
    //       ),
    //       content: Text(LocaleKeys.PremiumFeatureDescription.trnsltd),
    //       actions: [
    //         TextButton(
    //           onPressed: () => Navigator.pop(context),
    //           child: Text(LocaleKeys.Close.trnsltd),
    //         ),
    //       ],
    //     ),
    //   );
  }

  static void openImageViewer({
    required BuildContext context,
    required List<String> imageUrls,
    required int initialIndex,
  }) {
    if (imageUrls.isEmpty) return;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Image Viewer',
      barrierColor: Colors.black.withOpacity(0.8),
      pageBuilder: (context, animation, secondaryAnimation) {
        final colorScheme = Theme.of(context).colorScheme;
        final pageController = PageController(initialPage: initialIndex);
        int currentIndex = initialIndex;

        return StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: TapRegion(
                  onTapOutside: (_) => Navigator.of(context).pop(),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 🖼️ الصور
                      Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: PageView.builder(
                          controller: pageController,
                          itemCount: imageUrls.length,
                          onPageChanged: (index) =>
                              setState(() => currentIndex = index),
                          itemBuilder: (context, index) {
                            final path = imageUrls[index];

                            final isNetwork =
                                path.startsWith('http://') ||
                                path.startsWith('https://');

                            return PhotoView(
                              imageProvider: isNetwork
                                  ? NetworkImage(path)
                                  : FileImage(File(path)),

                              backgroundDecoration: const BoxDecoration(
                                color: Colors.transparent,
                              ),
                              minScale: PhotoViewComputedScale.contained,
                              maxScale: PhotoViewComputedScale.covered * 2.5,
                            );
                          },
                        ),
                      ),

                      // 🔁 أزرار التمرير الجانبية
                      if (imageUrls.length > 1) ...[
                        // ◀️ الزر الأيسر (يختفي عند أول صورة)
                        if (currentIndex > 0)
                          Positioned(
                            left: 16,
                            child: IconButton(
                              iconSize: 28,
                              color: colorScheme.onSurface,
                              style: IconButton.styleFrom(
                                backgroundColor: colorScheme.surface
                                    .withOpacity(0.7),
                                shape: const CircleBorder(),
                              ),
                              icon: const Icon(
                                HugeIcons.strokeRoundedArrowRight01,
                              ),
                              onPressed: () {
                                if (currentIndex > 0) {
                                  pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                            ),
                          ),

                        // ▶️ الزر الأيمن (يختفي عند آخر صورة)
                        if (currentIndex < imageUrls.length - 1)
                          Positioned(
                            right: 16,
                            child: IconButton(
                              iconSize: 28,
                              color: colorScheme.onSurface,
                              style: IconButton.styleFrom(
                                backgroundColor: colorScheme.surface
                                    .withOpacity(0.7),
                                shape: const CircleBorder(),
                              ),
                              icon: const Icon(
                                HugeIcons.strokeRoundedArrowLeft01,
                              ),
                              onPressed: () {
                                if (currentIndex < imageUrls.length - 1) {
                                  pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
