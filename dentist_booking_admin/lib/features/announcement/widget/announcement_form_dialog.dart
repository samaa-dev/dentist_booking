import 'dart:io';

import 'package:dentist_booking_admin/core/enum/enum.dart';
import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/core/model/announcement_model.dart';
import 'package:dentist_booking_admin/features/announcement/blocs/announcement/announcement_cubit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/util/util.dart';
import '../../../core/widgets/custom_dropdown.dart';
import '../../../core/widgets/custom_text_form_field.dart';
import '../../../core/widgets/dialog_title_header.dart';
import '../../../core/widgets/footer_dialog.dart';
import '../../../generated/locale_keys.g.dart';

class AnnouncementFormDialog extends StatefulWidget {
  const AnnouncementFormDialog({
    super.key,
    this.announcement,
  });

  final AnnouncementModel? announcement;

  @override
  State<AnnouncementFormDialog> createState() => _AnnouncementFormDialogState();
}

class _AnnouncementFormDialogState extends State<AnnouncementFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _title;
  late TextEditingController _link;
  late TextEditingController _body;
  late List<String> _images;
  late List<File> _newImages;
  final List<String> _removedImages = [];

  String? _status;
  String? _audience;

  @override
  void initState() {
    super.initState();
    final announc = widget.announcement;

    _title = TextEditingController(text: announc?.title ?? "");
    _link = TextEditingController(text: announc?.linkUrl ?? "");
    _body = TextEditingController(text: announc?.body ?? "");

    _images = List<String>.from(widget.announcement?.images ?? []);
    _newImages = [];

    _status =
        announc?.isActive.toAnnouncementStringStatus() ??
        LocaleKeys.status_activeing.trnsltd;

    _audience =
        announc?.audience.toAnnouncementStringAudience() ??
        LocaleKeys.audience_all.trnsltd;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 650,
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DialogTitleHeader(
                title: widget.announcement == null
                    ? LocaleKeys.announcement_form_title.trnsltd
                    : LocaleKeys.edit_announcement.trnsltd,
                subtitle: LocaleKeys.announcement_form_subtitle.trnsltd,
              ),

              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 300,
                          child: Row(
                            children: [
                              Flexible(
                                child: CustomDropdown<String>(
                                  value: _audience,
                                  enableSearch: false,
                                  hintText:
                                      LocaleKeys.announcement_audience.trnsltd,
                                  items: _getAnnouncementAudience(
                                    AnnouncementAudience.values,
                                  ),
                                  onChanged: (v) {
                                    setState(() => _audience = v);
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),

                              Flexible(
                                child: CustomDropdown<String>(
                                  value: _status,
                                  enableSearch: false,
                                  hintText:
                                      LocaleKeys.announcement_status.trnsltd,
                                  items: _getAnnouncementStatus(
                                    AnnouncementStatus.values,
                                  ),
                                  onChanged: (v) {
                                    setState(() => _status = v);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        _buildTextField(
                          context,
                          controller: _title,
                          keyboardType: TextInputType.text,
                          hintText: LocaleKeys.announcement_title.trnsltd,
                          prefixIcon: HugeIcons.strokeRoundedPen01,
                          validator: true,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          context,
                          controller: _link,
                          keyboardType: TextInputType.url,
                          hintText: LocaleKeys.announcement_url.trnsltd,
                          prefixIcon: HugeIcons.strokeRoundedLink02,
                          validator: false,
                        ),
                        const SizedBox(height: 12),

                        _buildTextField(
                          context,
                          controller: _body,
                          keyboardType: TextInputType.multiline,
                          hintText: LocaleKeys.announcement_description.trnsltd,
                          prefixIcon: HugeIcons.strokeRoundedContentWriting,
                          validator: false,
                          maxLines: 6,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 20),
                  Flexible(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OutlinedButton(
                          onPressed: () => _pickImage(context),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            LocaleKeys.upload_images.trnsltd,
                            style: TextStyle().copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        Container(
                          width: double.infinity,
                          height: 220,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: colorScheme.outline.withOpacity(.4),
                              width: 1.5,
                            ),
                          ),
                          child: (_images.isEmpty && _newImages.isEmpty)
                              ? _buildPlaceholder(context)
                              : _buildSingleImage(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              FooterDialog(
                title: widget.announcement == null
                    ? LocaleKeys.add_button.trnsltd
                    : LocaleKeys.save_button.trnsltd,
                onConfirm: () => _onConfirm(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required TextInputType keyboardType,
    required String hintText,
    required IconData prefixIcon,
    int? maxLines,
    bool validator = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 300,
      child: CustomTextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        hintText: hintText,
        prefixIcon: Icon(
          prefixIcon,
          color: colorScheme.onSurface,
        ),
        validator: validator
            ? (v) => (v == null || v.isEmpty)
                  ? LocaleKeys.required_field.trnsltd
                  : null
            : null,
      ),
    );
  }

  _getAnnouncementStatus(List<AnnouncementStatus> values) {
    return values.map((status) {
      return DropdownMenuItem(
        value: status.name,
        child: Text(status.name),
      );
    }).toList();
  }

  _getAnnouncementAudience(List<AnnouncementAudience> values) {
    return values.map((status) {
      return DropdownMenuItem(
        value: status.name,
        child: Text(status.name),
      );
    }).toList();
  }

  Widget _buildPlaceholder(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            size: 40,
            color: colorScheme.outline.withOpacity(.5),
          ),
          const SizedBox(height: 8),
          Text(
            LocaleKeys.no_images_uploaded.trnsltd,
            style: TextStyle(
              color: colorScheme.outline.withOpacity(.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleImage(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    ImageItem? item;

    if (_newImages.isNotEmpty) {
      item = ImageItem.local(_newImages.first);
    } else if (_images.isNotEmpty) {
      item = ImageItem.network(_images.first);
    }

    if (item == null) return _buildPlaceholder(context);

    return Stack(
      children: [
        InkWell(
          onTap: () => SnackbarMes.openImageViewer(
            context: context,
            imageUrls: item!.isNetwork ? [item.url!] : [item.file!.path],
            initialIndex: 0,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: item.isNetwork
                ? Image.network(
                    item.url!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    item.file!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
          ),
        ),

        // زر الحذف
        Positioned(
          right: 0,
          top: 0,
          child: GestureDetector(
            onTap: () {
              setState(() {
                if (item!.isNetwork) {
                  _removedImages.add(item.url!);
                  _images.clear();
                } else {
                  _newImages.clear();
                }
              });
            },
            child: Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: colorScheme.error.withOpacity(.85),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, size: 16, color: colorScheme.onError),
            ),
          ),
        ),
      ],
    );
  }

  void _pickImage(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );

    if (result == null) return;

    final path = result.files.single.path;
    if (path == null) return;

    final f = File(path);

    setState(() {
      // إزالة كل الصور السابقة
      if (_images.isNotEmpty) {
        _removedImages.addAll(_images);
        _images.clear();
      }

      // استبدال الصورة المحلية فقط
      _newImages
        ..clear()
        ..add(f);
    });
  }

  void _onConfirm(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final announcementCubit = context.read<AnnouncementCubit>();

    final model = AnnouncementModel(
      id: widget.announcement?.id ?? "",
      title: _title.text,
      body: _body.text,
      audience: _audience!.toAudienceString(),
      images: _images,
      isActive: _status!.toAnnouncementBool() ? true : false,
      createdAt: widget.announcement?.createdAt ?? DateTime.now(),
      linkUrl: _link.text,
      createdByUserId: "1",
    );

    widget.announcement == null
        ? announcementCubit.createAnnouncement(
            announcement: model,
            newImages: _newImages,
          )
        : announcementCubit.updateAnnouncement(
            announcement: model,
            newImages: _newImages,
            removedImages: _removedImages,
          );
  }
}

class ImageItem {
  final bool isNetwork; // true => URL, false => File
  final String? url;
  final File? file;

  ImageItem.network(this.url) : isNetwork = true, file = null;

  ImageItem.local(this.file) : isNetwork = false, url = null;
}
