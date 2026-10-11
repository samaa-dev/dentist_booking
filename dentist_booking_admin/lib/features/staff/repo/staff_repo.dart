import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/model/staff_member.dart';
import '../../../core/util/session_guard.dart';

/// Error code from the server, mapped to a message by the UI.
class StaffActionException implements Exception {
  const StaffActionException(this.code);
  final String code;

  @override
  String toString() => 'StaffActionException($code)';
}

class StaffRepo {
  StaffRepo({required SupabaseClient client}) : _client = client;

  final SupabaseClient _client;

  Future<List<StaffMember>> getStaff() async {
    try {
      final rows = await _client.rpc('get_staff_members') as List;
      return rows
          .map((e) => StaffMember.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (e) {
      throw _mapError(e);
    }
  }

  /// Creates the login (email + password) and the staff profile in one step.
  Future<void> createStaff(StaffDraft draft) async {
    await _invokeManageStaff({
      'action': 'create',
      'email': draft.email,
      'password': draft.password,
      'full_name': draft.fullName,
      'phone': draft.phone,
      'position': draft.position.code,
      'permissions': draft.permissions.map((p) => p.code).toList(),
    });
  }

  Future<void> updateStaff(String id, StaffDraft draft) async {
    try {
      await _client.rpc(
        'update_staff_member',
        params: {
          'p_id': id,
          'p_full_name': draft.fullName,
          'p_phone': draft.phone,
          'p_position': draft.position.code,
          'p_permissions': draft.permissions.map((p) => p.code).toList(),
        },
      );
    } catch (e) {
      throw _mapError(e);
    }
  }

  Future<void> setActive(String id, {required bool active}) async {
    try {
      await _client.rpc(
        'set_staff_active',
        params: {'p_id': id, 'p_active': active},
      );
    } catch (e) {
      throw _mapError(e);
    }
  }

  Future<void> setPassword(String userId, String password) async {
    await _invokeManageStaff({
      'action': 'set_password',
      'user_id': userId,
      'password': password,
    });
  }

  Future<void> deleteStaff(String id) async {
    try {
      await _client.rpc('delete_staff', params: {'p_id': id});
    } catch (e) {
      throw _mapError(e);
    }
  }

  Future<void> _invokeManageStaff(Map<String, dynamic> body) async {
    try {
      final res = await _client.functions.invoke('manage-staff', body: body);
      final data = res.data is String ? jsonDecode(res.data) : res.data;
      if (data is Map && data['status'] == 'success') return;
      throw StaffActionException(
        (data is Map ? data['error'] : null)?.toString() ?? 'unknown',
      );
    } on FunctionException catch (e) {
      final details = e.details;
      final data = details is String ? _tryDecode(details) : details;
      throw StaffActionException(
        (data is Map ? data['error'] : null)?.toString() ?? 'unknown',
      );
    } on StaffActionException {
      rethrow;
    } catch (e) {
      throw _mapError(e);
    }
  }

  Object _mapError(Object e) {
    final sessionError = SessionGuard.asSessionExpired(e);
    if (sessionError != null) return sessionError;
    debugPrint('Staff action failed: $e');
    if (e is PostgrestException) {
      if (e.code == '42501') return const StaffActionException('forbidden');
      if (e.message.contains('staff_not_found')) {
        return const StaffActionException('staff_not_found');
      }
    }
    return const StaffActionException('unknown');
  }

  static Object? _tryDecode(String s) {
    try {
      return jsonDecode(s);
    } catch (_) {
      return null;
    }
  }
}
