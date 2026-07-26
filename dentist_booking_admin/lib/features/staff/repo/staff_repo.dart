import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/model/profile_model.dart';
import '../../../core/model/staff_model.dart';

class StaffRepo {
  final SupabaseClient _client;

  StaffRepo({
    required SupabaseClient client,
  }) : _client = client;

  /// 📌 Get all Profile
  Future<List<ProfileModel>> getAllProfiles() async {
    try {
      final response = await _client.rpc('get_all_profile').select();

      return response
          .map<ProfileModel>((e) => ProfileModel.fromJson(e))
          .toList();
    } catch (e) {
      debugPrint("Failed to fetch profile list: $e");
      throw Exception('Failed to fetch profile list: $e');
    }
  }

  /// 📌 Get all staff
  Future<List<StaffModel>> getAllStaff() async {
    try {
      final response = await _client.rpc('get_all_staff').select();

      return response.map<StaffModel>((e) => StaffModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to fetch staff list: $e');
    }
  }

  /// 📌 Get Staff by ID
  Future<StaffModel> getStaffById(String staffId) async {
    try {
      final resp = await _client
          .rpc(
            'get_staff_by_id',
            params: {'p_id': staffId},
          )
          .select()
          .single();

      return StaffModel.fromJson(resp);
    } catch (e) {
      throw Exception('Failed to load staff: $e');
    }
  }

  /// 📌 Create new staff
  Future<StaffModel> createStaff(StaffModel staff) async {
    debugPrint("STATUS BEFORE RPC = ${staff.status.code}");

    try {
      final resp = await _client
          .rpc(
            'create_staff',
            params: {
              'p_user_id': staff.userId,
              'p_full_name': staff.fullName,
              'p_email': staff.email,
              'p_phone': staff.phone,
              'p_position': staff.position.code,
              'p_shift': staff.shiftType.code,
              'p_status': staff.status.code,
            },
          )
          .select()
          .single();

      return StaffModel.fromJson(resp);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to create staff: $e');
    }
  }

  /// 📌 Update staff
  Future<StaffModel> updateStaff(StaffModel staff) async {
    try {
      final resp = await _client
          .rpc(
            'update_staff',
            params: {
              'p_id': staff.id,
              'p_full_name': staff.fullName,
              'p_email': staff.email,
              'p_phone': staff.phone,
              'p_position': staff.position.code,
              'p_shift': staff.shiftType.code,
              'p_status': staff.status.code,
            },
          )
          .select()
          .single();

      return StaffModel.fromJson(resp);
    } catch (e) {
      throw Exception('Failed to update staff: $e');
    }
  }

  /// 📌 Delete staff
  Future<bool> deleteStaff(String id) async {
    try {
      final resp = await _client.rpc(
        'delete_staff',
        params: {'p_id': id},
      );

      return resp == true;
    } catch (e) {
      throw Exception('Failed to delete staff: $e');
    }
  }

  Future<bool> changePassword({
    required String staffId,
    required String newPassword,
  }) async {
    try {
      final res = await _client.functions.invoke(
        'change_staff_password',
        body: {
          'user_id': staffId,
          'new_password': newPassword,
        },
      );

      // res.data قد يكون String أو Map
      Map<String, dynamic> json;

      if (res.data is String) {
        json = jsonDecode(res.data);
      } else {
        json = res.data;
      }

      if (json['status'] == 'success') {
        return true;
      }

      return false;
    } catch (e) {
      throw Exception("Failed to change password: $e");
    }
  }
}
