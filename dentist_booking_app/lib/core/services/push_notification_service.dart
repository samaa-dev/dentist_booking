import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../firebase_options.dart';

/// Top-level handler for background FCM messages (must be a top-level function).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Background display is handled by the system when `notification` payload is set.
  // Keep this handler registered so the plugin can resume cleanly.
  debugPrint('FCM background: ${message.messageId}');
}

/// Opens queue tracking when the user taps a queue push notification.
class PushNavigationIntent {
  const PushNavigationIntent({this.ticketCode, this.bookingId});

  final String? ticketCode;
  final String? bookingId;
}

class PushNotificationService {
  PushNotificationService({required SupabaseClient client}) : _client = client;

  static const _androidChannel = AndroidNotificationChannel(
    'queue_updates',
    'تحديثات الدور',
    description: 'إشعارات حجز الموعد وتقدّم الدور',
    importance: Importance.high,
  );

  final SupabaseClient _client;
  late final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  final _navController = StreamController<PushNavigationIntent>.broadcast();
  StreamSubscription<String>? _tokenRefreshSub;
  String? _currentToken;
  bool _initialized = false;

  Stream<PushNavigationIntent> get navigationIntents => _navController.stream;

  Future<void> initialize() async {
    if (_initialized) return;
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return;
    }

    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    _messaging = FirebaseMessaging.instance;

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await _local
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);

    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/app_icon'),
    );

    await _local.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        _emitNavigationFromPayload(response.payload);
      },
    );

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen(_showForegroundNotification);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpen);

    final initial = await _messaging.getInitialMessage();
    if (initial != null) {
      _handleMessageOpen(initial);
    }

    _tokenRefreshSub = _messaging.onTokenRefresh.listen((token) async {
      _currentToken = token;
      if (_client.auth.currentUser != null) {
        await _upsertToken(token);
      }
    });

    _initialized = true;
  }

  Future<void> requestPermissionAndRegister() async {
    if (!_initialized) await initialize();
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    if (_client.auth.currentUser == null) return;

    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint('Push permission denied');
      return;
    }

    final token = await _messaging.getToken();
    if (token == null || token.isEmpty) return;

    _currentToken = token;
    await _upsertToken(token);
  }

  Future<void> unregisterCurrentToken() async {
    if (!_initialized) return;

    final token = _currentToken ?? await _messaging.getToken();
    if (token == null || token.isEmpty) return;

    try {
      await _client.rpc('delete_device_token', params: {'p_token': token});
    } catch (e) {
      debugPrint('delete_device_token failed: $e');
    }

    try {
      await _messaging.deleteToken();
    } catch (_) {}

    _currentToken = null;
  }

  Future<void> _upsertToken(String token) async {
    try {
      await _client.rpc(
        'upsert_device_token',
        params: {
          'p_token': token,
          'p_platform': 'android',
        },
      );
    } catch (e) {
      debugPrint('upsert_device_token failed: $e');
    }
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    final data = message.data;
    final title = notification?.title ?? data['title'] as String? ?? 'عيادة الوفاء';
    final body = notification?.body ?? data['body'] as String? ?? '';
    final collapseKey =
        data['collapse_key'] as String? ?? data['booking_id'] as String? ?? 'queue';

    final payload = jsonEncode({
      'ticket_code': data['ticket_code'],
      'booking_id': data['booking_id'],
      'kind': data['kind'],
    });

    await _local.show(
      collapseKey.hashCode,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          tag: collapseKey,
          groupKey: collapseKey,
        ),
      ),
      payload: payload,
    );
  }

  void _handleMessageOpen(RemoteMessage message) {
    final data = message.data;
    _navController.add(
      PushNavigationIntent(
        ticketCode: data['ticket_code'] as String?,
        bookingId: data['booking_id'] as String?,
      ),
    );
  }

  void _emitNavigationFromPayload(String? payload) {
    if (payload == null || payload.isEmpty) return;
    try {
      final map = jsonDecode(payload) as Map<String, dynamic>;
      _navController.add(
        PushNavigationIntent(
          ticketCode: map['ticket_code'] as String?,
          bookingId: map['booking_id'] as String?,
        ),
      );
    } catch (e) {
      debugPrint('Invalid notification payload: $e');
    }
  }

  Future<void> dispose() async {
    await _tokenRefreshSub?.cancel();
    await _navController.close();
  }
}
