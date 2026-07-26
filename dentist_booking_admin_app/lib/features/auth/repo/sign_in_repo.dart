import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignInRepo {
  SignInRepo({
    required SupabaseClient? supabase,
  }) : _supabase = supabase ?? Supabase.instance.client;

  final SupabaseClient _supabase;

  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
  User? get currentUser => _supabase.auth.currentUser;
  Session? get currentSession => _supabase.auth.currentSession;

  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      debugPrint('Sign-in successful: ${response.user}');

      final user = response.user;

      if (user != null) {
        return true;
      } else {
        return false;
      }
    } on AuthException catch (e) {
      debugPrint('Sign-in error: ${e.message}');
      return false;
    } catch (e) {
      debugPrint('An unexpected error occurred: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Stream<Map<String, dynamic>> getProfile(String userId) {
    return _supabase
        .from('profiles')
        .stream(primaryKey: ['user_id'])
        .eq('user_id', userId)
        .map((rows) => rows.isNotEmpty ? rows.first : {});
  }

  Future<void> updateLastSeen(String userId) async {
    await _supabase
        .from('profiles')
        .update({
          'last_seen': DateTime.now().toUtc().toIso8601String(),
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('user_id', userId);
  }
}
