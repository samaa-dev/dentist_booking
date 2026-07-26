import 'package:dentist_booking_admin/core/enum/enum.dart';
import 'package:dentist_booking_admin/core/widgets/custom_icon_tabel_cell.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/model/announcement_model.dart';
import '../../../core/util/util.dart';
import '../../../core/widgets/custom_badg.dart';

class AnnouncementItem extends StatelessWidget {
  const AnnouncementItem({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  final AnnouncementModel item;

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.15),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.outline.withOpacity(.1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة الإعلان
          if (item.images.isNotEmpty)
            InkWell(
              onTap: () => SnackbarMes.openImageViewer(
                context: context,
                imageUrls: item.images,
                initialIndex: 0,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  item.images[0],
                  width: 85,
                  height: 85,

                  fit: BoxFit.cover,

                  // loadingBuilder: (context, child, loadingProgress) {
                  //   return Container(
                  //     decoration: BoxDecoration(
                  //       color: colorScheme.primary.withOpacity(.1),
                  //       borderRadius: BorderRadius.circular(14),
                  //     ),
                  //     width: 85,
                  //     height: 85,
                  //     child: Icon(
                  //       Icons.image_rounded,
                  //       size: 35,
                  //       color: colorScheme.primary,
                  //     ),
                  //   );
                  // },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      width: 85,
                      height: 85,
                      child: Icon(
                        Icons.image_not_supported,
                        size: 35,
                        color: colorScheme.primary,
                      ),
                    );
                  },
                ),
              ),
            )
          else
            Container(
              width: 85,
              height: 85,
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.campaign,
                size: 35,
                color: colorScheme.primary,
              ),
            ),

          const SizedBox(width: 16),

          // النصوص + البادجات
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  item.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium,
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    CustomBadg(
                      label: item.audience.toAnnouncementStringAudience(),
                      bgcolor: item.audience.tobgColorsAnnouncemen(),
                      textColor: item.audience.totxtColorsAnnouncemen(),
                    ),
                    const SizedBox(width: 8),
                    CustomBadg(
                      label: item.isActive.toAnnouncementStringStatus(),
                      bgcolor: item.isActive.tobgColorsAnnouncemen(),
                      textColor: item.isActive.totxtColorsAnnouncemen(),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 🔥 أزرار التعديل والحذف على اليمين
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomIconTabelCell(
                icon: HugeIcons.strokeRoundedEdit03,
                color: colorScheme.primary,
                onTap: () => onEdit(),
              ),
              const SizedBox(height: 8),
              CustomIconTabelCell(
                icon: HugeIcons.strokeRoundedDelete01,
                color: colorScheme.error,
                onTap: () => onDelete(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
