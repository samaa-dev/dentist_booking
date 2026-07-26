import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignInRepo {
  SignInRepo({
    required SupabaseClient? supabase,
    GoogleSignIn? googleSignIn,
  }) : _supabase = supabase ?? Supabase.instance.client,
       _googleSignIn =
           googleSignIn ??
           GoogleSignIn(
             //clientId: '602340007719-6o5vtg22dnadlepgh9likt1g5tvu8pn0.apps.googleusercontent.com',
             clientId: "602340007719-0s30c9t36mk72hkenlombehpkravjjmh.apps.googleusercontent.com",
             serverClientId: '602340007719-6o5vtg22dnadlepgh9likt1g5tvu8pn0.apps.googleusercontent.com',
           );

  final SupabaseClient _supabase;
  final GoogleSignIn _googleSignIn;

  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
  User? get currentUser => _supabase.auth.currentUser;
  Session? get currentSession => _supabase.auth.currentSession;

  Future<bool> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return false; // cancelled
      }
      final googleAuth = await googleUser.authentication;

      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;
      if (accessToken == null || idToken == null) {
        throw const AuthException('Missing tokens');
      }

      await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
      return true;
    } catch (e) {
      debugPrint("Error signing in with Google: $e");
      throw Exception('Error signing in with Google: $e');
    }
  }

  /// تسجيل الدخول كمجهول (دخول الضيف)
  Future<bool> signInAnonymously() async {
    try {
      final AuthResponse res = await _supabase.auth.signInAnonymously();

      if (res.user != null) {
        debugPrint("✅ Anonymous sign-in successful: ${res.user!.id}");
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("❌ Error signing in anonymously: $e");
      throw Exception('Error signing in anonymously: $e');
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
    await _googleSignIn.signOut();
  }

  Stream<Map<String, dynamic>> getProfile(String userId) {
    return _supabase
        .from('profiles')
        .stream(primaryKey: ['user_id'])
        .eq('user_id', userId)
        .map((rows) => rows.isNotEmpty ? rows.first : {});
  }

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        return false;
      }

      final userId = user.id;
      debugPrint("📝 Updating profile for: $userId");

      // 1️⃣ اجلب meta القديمة
      final current = await Supabase.instance.client.from('profiles').select('meta').eq('user_id', userId).single();

      final oldMeta = current['meta'] ?? {};
      final oldRaw = oldMeta['raw_user_meta_data'] ?? {};

      // 2️⃣ دمج البيانات الجديدة مع القديمة
      final newRaw = {
        ...oldRaw,
        ...data,
        "updated_at": DateTime.now().toIso8601String(),
      };

      final newMeta = {
        ...oldMeta,
        "raw_user_meta_data": newRaw,
      };

      await Supabase.instance.client
          .from('profiles')
          .update({
            "meta": newMeta,
            "updated_at": DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId);

      return true;
    } catch (e) {
      debugPrint("Error updating profile: $e");
      return false;
    }
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
