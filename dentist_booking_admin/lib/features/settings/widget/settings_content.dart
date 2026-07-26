import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';

import '../../../core/model/clinic_config_model.dart';
import 'clinic_settings_tab.dart';
import 'working_hours_tab.dart';

class SettingsContent extends StatefulWidget {
  const SettingsContent({
    super.key,
    required this.settings,
  });

  final ClinicConfigModel settings;

  @override
  State<SettingsContent> createState() => _SettingsContentState();
}

class _SettingsContentState extends State<SettingsContent>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 950,
        ),
        child: Column(
          children: [
            TabBar(
              controller: tabController,
              labelColor: Theme.of(context).colorScheme.primary,
              tabs: [
                Tab(text: LocaleKeys.ClinicSettings.trnsltd),
                Tab(text: LocaleKeys.WorkingHours.trnsltd),
              ],
            ),

            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  ClinicSettingsTab(
                    // settings: widget.settings.settings,
                  ),
                  WorkingHoursTab(
                    // hours: widget.settings.workingHours,;
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
