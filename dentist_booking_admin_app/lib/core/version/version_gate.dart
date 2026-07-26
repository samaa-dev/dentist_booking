import 'package:dentist_booking_admin_app/core/version/app_version_utils.dart';
import 'package:dentist_booking_admin_app/core/version/update_required_screen.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VersionGate extends StatefulWidget {
  const VersionGate({
    super.key,
    required this.appType,
    required this.child,
    this.showStoreButton = true,
  });

  final AppVersionTarget appType;
  final Widget child;
  final bool showStoreButton;

  @override
  State<VersionGate> createState() => _VersionGateState();
}

class _VersionGateState extends State<VersionGate> {
  bool _checking = true;
  bool _outdated = false;
  String _current = '0.0.0';
  String _minimum = '0.0.0';

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final current = info.version;
      final resp = await Supabase.instance.client.rpc('get_min_app_versions');
      String? minimum;
      if (resp is Map) {
        minimum = resp[widget.appType.jsonKey]?.toString();
      }
      final outdated = isVersionOutdated(current: current, minimum: minimum);
      if (!mounted) return;
      setState(() {
        _current = current;
        _minimum = minimum?.trim().isNotEmpty == true ? minimum!.trim() : '0.0.0';
        _outdated = outdated;
        _checking = false;
      });
    } catch (e) {
      debugPrint('VersionGate fail-open: $e');
      if (!mounted) return;
      setState(() {
        _checking = false;
        _outdated = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_outdated) {
      return UpdateRequiredScreen(
        currentVersion: _current,
        minimumVersion: _minimum,
        showStoreButton: widget.showStoreButton,
      );
    }
    return widget.child;
  }
}
