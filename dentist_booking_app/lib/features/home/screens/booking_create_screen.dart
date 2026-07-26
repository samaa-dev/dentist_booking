import 'package:dentist_booking_app/core/extensions/os_extensions.dart';
import 'package:dentist_booking_app/core/model/booking_model.dart';
import 'package:dentist_booking_app/features/auth/blocs/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/enum/enum.dart';
import '../../../core/util/info_snackbar.dart';
import '../../../core/util/calendar_date.dart';
import '../../../core/widgets/custom_text_form_field.dart';
import '../../../core/widgets/dialog_title_header.dart';
import '../../../core/widgets/footer_dialog.dart';
import '../../../generated/locale_keys.g.dart';
import '../blocs/booking_create/booking_create_cubit.dart';

class BookingCreateScreen extends StatefulWidget {
  const BookingCreateScreen({super.key});

  @override
  State<BookingCreateScreen> createState() => _BookingCreateScreenState();
}

class _BookingCreateScreenState extends State<BookingCreateScreen> {
  BookingShift _selectedShift = BookingShift.morning;

  // 1. إضافة المتحكمات والمتغيرات الجديدة
  bool _isForAnotherPerson = false;
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DialogTitleHeader(
                  title: LocaleKeys.add_booking.trnsltd,
                  subtitle: LocaleKeys.booking_add_subtitle.trnsltd,
                ),

                _buildTodayDateBanner(context),

                const SizedBox(height: 16),

                Row(
                  children: BookingShift.values.map((shift) {
                    final isSelected = _selectedShift == shift;
                    final label = shift == BookingShift.morning
                        ? LocaleKeys.booking_morning.trnsltd
                        : LocaleKeys.booking_evening.trnsltd;

                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedShift = shift),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            color: isSelected ? colorScheme.primary.withOpacity(0.12) : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              width: 1,
                              color: isSelected
                                  ? colorScheme.primary.withOpacity(.5)
                                  : colorScheme.outlineVariant.withOpacity(.5),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (isSelected) ...[
                                Icon(HugeIcons.strokeRoundedCheckmarkCircle04, size: 18, color: colorScheme.primary),
                                const SizedBox(width: 6),
                              ],
                              Text(
                                label,
                                style: textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? colorScheme.primary : colorScheme.onSurface.withOpacity(.70),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                SwitchListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  title: Text(
                    "الحجز لشخص آخر؟",
                    style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  secondary: Icon(HugeIcons.strokeRoundedUserStatus, color: colorScheme.primary),
                  value: _isForAnotherPerson,
                  onChanged: (val) => setState(() => _isForAnotherPerson = val),
                  activeColor: colorScheme.primary,
                ),

                if (_isForAnotherPerson) ...[
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    hintText: LocaleKeys.full_name.trnsltd,
                    controller: _fullNameController,
                    prefixIcon: const Icon(HugeIcons.strokeRoundedUser, size: 20),
                    validator: (v) => v!.isEmpty ? LocaleKeys.full_name_error.trnsltd : null,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    hintText: LocaleKeys.phone.trnsltd,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    prefixIcon: const Icon(HugeIcons.strokeRoundedSmartPhone01, size: 20),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return LocaleKeys.phone_error.trnsltd;
                      }
                      // التحقق من أن الرقم 10 أرقام ويبدأ بـ 06 أو 05 أو 07
                      final phoneRegex = RegExp(r'^(06|05|07)\d{8}$');
                      if (!phoneRegex.hasMatch(v.trim())) {
                        return LocaleKeys.phone_invalid_format.trnsltd;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    keyboardType: TextInputType.text,
                    hintText: LocaleKeys.address.trnsltd,
                    controller: _addressController,
                    prefixIcon: const Icon(HugeIcons.strokeRoundedLocation01, size: 20),
                  ),
                ],

                const SizedBox(height: 35),
                FooterDialog(
                  title: LocaleKeys.add_button.trnsltd,
                  onConfirm: () => _onConfirm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTodayDateBanner(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final today = DateTime.now();
    final timeStr = '${today.hour.toString().padLeft(2, '0')}:${today.minute.toString().padLeft(2, '0')}';

    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: colorScheme.primary.withAlpha(20),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.primary.withOpacity(.5)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_rounded,
            size: 20,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Text(
            LocaleKeys.booking_for_today.trnsltd,
            style: textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const Spacer(),
          Text(
            '${CalendarDate.getFormatSingleDate(today)}  $timeStr',
            style: textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
    );
  }

  Future<void> _onConfirm() async {
    if (_isForAnotherPerson && !_formKey.currentState!.validate()) return;

    // التحقق من وجود حجز فعال للمستخدم نفسه
    if (!_isForAnotherPerson) {
      final hasActiveBooking = await context.read<BookingCreateCubit>().checkCanBookForSelf();
      if (hasActiveBooking) {
        SnackbarMes.showToastMsg(
          context,
          message: LocaleKeys.already_has_active_booking.trnsltd,
        );
        return;
      }
    }

    final now = DateTime.now();
    // تاريخ اليوم + الساعة والدقيقة الحاليتين (الوقت الفعلي) لربط السماح/المنع بالساعة
    final bookingDate = DateTime(now.year, now.month, now.day, now.hour, now.minute, 0, 0);

    final authState = context.read<AuthCubit>().state;
    String? currentUserId;
    PatientType patientType = PatientType.registered;

    if (authState is Status) {
      currentUserId = context.read<AuthCubit>().currentUser()!.id;
      if (authState.typeLogin == TypeLogin.guest) {
        patientType = PatientType.guest;
      }
    }

    context.read<BookingCreateCubit>().createBooking(
      BookingModel(
        bookingDate: bookingDate,
        // patientId دائماً currentUserId (حتى عند الحجز لشخص آخر)
        // حتى يبقى الحجز مرتبطاً بحساب المستخدم
        patientId: currentUserId,
        // patientType دائماً patientType الحالي (registered أو guest حسب المستخدم)
        // حتى عند الحجز لشخص آخر، يبقى الحجز مرتبطاً بنوع حساب المستخدم
        patientType: patientType,
        shift: _selectedShift,

        // معلومات guest إذا كان الحجز لشخص آخر
        // عند العرض، إذا كان patientName موجوداً، سيتم عرضه بدلاً من اسم المستخدم
        patientName: _isForAnotherPerson ? _fullNameController.text.trim() : null,
        patientPhone: _isForAnotherPerson ? _phoneController.text.trim() : null,
        patientAddress: _isForAnotherPerson ? _addressController.text.trim() : null,

        bookingCreatedBy: currentUserId,
        createdAt: DateTime.now(),
      ),
    );

    Navigator.of(context).pop();
  }
}
