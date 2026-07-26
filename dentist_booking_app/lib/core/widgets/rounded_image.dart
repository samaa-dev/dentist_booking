import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class RoundedImage extends StatelessWidget {
  const RoundedImage({
    super.key,
    this.border,
    this.padding,
    this.onPressed,
    this.height = 200,
    this.width = double.infinity,
    this.applyImageRadius = true,
    this.imageUrl,
    this.fit = BoxFit.cover,
    this.borderRadius = 14,
    this.isNetworkImage = false,
    this.isViewer = false,
    this.placeholder,
    this.imageFile,
    this.backgroundColor = Colors.transparent,
  });

  final double? width, height;
  final String? imageUrl;
  final bool applyImageRadius;
  final BoxBorder? border;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final bool isNetworkImage;
  final VoidCallback? onPressed;
  final double borderRadius;
  final Widget? placeholder;
  final bool isViewer;
  final File? imageFile;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget buildPlaceholder() => Center(
      child: Container(
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: colorScheme.primary.withOpacity(0.1),
          border: Border.all(
            color: colorScheme.primary.withOpacity(0.1),
            width: 1,
          ),
          shape: BoxShape.circle,
        ),
        child: Icon(
          HugeIcons.strokeRoundedDentalTooth,
          color: colorScheme.primary,
          size: 18,
        ),
      ),
    );

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        padding: padding,
        decoration: BoxDecoration(
          border: border,
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: ClipRRect(
          borderRadius: applyImageRadius
              ? BorderRadius.circular(borderRadius)
              : BorderRadius.zero,
          child: isViewer
              ? buildPlaceholder()
              : imageFile != null
              ? Image.file(imageFile!, fit: fit)
              : isNetworkImage && imageUrl != null
              ? CachedNetworkImage(
                  imageUrl: imageUrl!,
                  fit: fit,
                  placeholder: (context, url) => buildPlaceholder(),
                  errorWidget: (context, url, error) => Center(
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        border: Border.all(
                          color: colorScheme.primary.withOpacity(0.1),
                          width: 1,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        HugeIcons.strokeRoundedDentalTooth,
                        color: colorScheme.primary,
                        size: 18,
                      ),
                    ),
                  ),
                  fadeInDuration: const Duration(milliseconds: 250),
                  fadeOutDuration: const Duration(milliseconds: 150),
                )
              : buildPlaceholder(),
        ),
      ),
    );
  }
}
