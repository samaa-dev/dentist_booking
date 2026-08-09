import 'package:dentist_booking_admin_app/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin_app/core/model/profile_model.dart';
import 'package:dentist_booking_admin_app/core/widgets/dialog_title_header.dart';
import 'package:dentist_booking_admin_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../blocs/booking/booking_cubit.dart';

class SelectPatientSheet extends StatefulWidget {
  const SelectPatientSheet({super.key});

  static Future<ProfileModel?> show(BuildContext context) {
    final cubit = context.read<BookingCubit>();
    return showModalBottomSheet<ProfileModel>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: true,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const SelectPatientSheet(),
      ),
    );
  }

  @override
  State<SelectPatientSheet> createState() => _SelectPatientSheetState();
}

class _SelectPatientSheetState extends State<SelectPatientSheet> {
  String _search = '';

  @override
  void initState() {
    super.initState();
    context.read<BookingCubit>().getAllPatients();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final height = MediaQuery.sizeOf(context).height * 0.75;

    return SizedBox(
      height: height,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 16 + bottomInset),
        child: Column(
          children: [
            DialogTitleHeader(
              title: LocaleKeys.select_patient_form_title.trnsltd,
              subtitle: LocaleKeys.select_patient_form_subtitle.trnsltd,
            ),
            const SizedBox(height: 12),
            TextField(
              onChanged: (value) => setState(() => _search = value),
              decoration: InputDecoration(
                hintText: LocaleKeys.search_by_patient_name.trnsltd,
                prefixIcon: const Icon(HugeIcons.strokeRoundedSearch01),
                filled: true,
                fillColor:
                    colorScheme.surfaceContainerHighest.withOpacity(0.4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BlocBuilder<BookingCubit, BookingState>(
                buildWhen: (previous, current) => current.maybeWhen(
                  orElse: () => false,
                  loadingPatients: () => true,
                  loadedPatients: (_) => true,
                  errorPatients: (_) => true,
                ),
                builder: (context, state) {
                  return state.maybeWhen(
                    loadingPatients: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorPatients: (message) => Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(message),
                          const SizedBox(height: 12),
                          FilledButton(
                            onPressed: () =>
                                context.read<BookingCubit>().getAllPatients(),
                            child: Text(LocaleKeys.retry.trnsltd),
                          ),
                        ],
                      ),
                    ),
                    loadedPatients: (patients) {
                      if (patients.isEmpty) {
                        return Center(
                          child: Text(
                            LocaleKeys.no_patients_found.trnsltd,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }

                      final filtered = patients.where((patient) {
                        if (_search.trim().isEmpty) return true;
                        final meta =
                            patient.meta['raw_user_meta_data'] as Map? ?? {};
                        final fullName =
                            (meta['full_name'] ?? meta['name'] ?? '')
                                .toString()
                                .toLowerCase();
                        final phone =
                            (meta['phone'] ?? '').toString().toLowerCase();
                        final query = _search.toLowerCase();
                        return fullName.contains(query) ||
                            phone.contains(query);
                      }).toList();

                      if (filtered.isEmpty) {
                        return Center(
                          child: Text(
                            LocaleKeys.no_patient_found.trnsltd,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          final meta =
                              item.meta['raw_user_meta_data'] as Map? ?? {};
                          final fullName = (meta['full_name'] ??
                                  meta['name'] ??
                                  LocaleKeys.unknown_name.trnsltd)
                              .toString();
                          final phone = (meta['phone'] ??
                                  LocaleKeys.unknown_phone.trnsltd)
                              .toString();

                          return InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => Navigator.pop(context, item),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest
                                    .withOpacity(0.35),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: colorScheme.outline.withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor:
                                        colorScheme.primary.withOpacity(0.15),
                                    child: Icon(
                                      HugeIcons.strokeRoundedUser02,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          fullName,
                                          style: textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          phone,
                                          style: textTheme.bodySmall?.copyWith(
                                            color: colorScheme.onSurface
                                                .withOpacity(0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    context.locale.languageCode == 'ar'
                                        ? HugeIcons.strokeRoundedArrowLeft01
                                        : HugeIcons.strokeRoundedArrowRight01,
                                    color: colorScheme.primary,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    orElse: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
