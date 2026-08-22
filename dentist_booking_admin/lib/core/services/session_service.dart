import 'dart:async';

import '../util/session_guard.dart';

class SessionService {
  final _controller = StreamController<void>.broadcast();
  bool _handling = false;

  Stream<void> get onExpired => _controller.stream;

  bool handleIfExpired(Object error) {
    if (!SessionGuard.isAuthError(error)) return false;
    expire();
    return true;
  }

  void expire() {
    if (_handling) return;
    _handling = true;
    if (!_controller.isClosed) {
      _controller.add(null);
    }
    Future.delayed(const Duration(seconds: 2), () {
      _handling = false;
    });
  }

  void dispose() {
    _controller.close();
  }
}
