import '../enum/enum.dart';
import 'app_permission.dart';

/// What the signed-in account may do, as reported by `get_my_access`.
/// The server enforces the same rules; this only shapes the UI.
class UserAccess {
  const UserAccess({
    required this.role,
    required this.isAdmin,
    required this.permissions,
  });

  final UserRole role;
  final bool isAdmin;
  final Set<AppPermission> permissions;

  static const none = UserAccess(
    role: UserRole.unknown,
    isAdmin: false,
    permissions: {},
  );

  bool can(AppPermission permission) =>
      isAdmin || permissions.contains(permission);

  /// Staff accounts are managed by admins only (never a grantable permission).
  bool get canManageStaff => isAdmin;

  bool get hasAnyAccess => isAdmin || permissions.isNotEmpty;

  factory UserAccess.fromJson(Map<String, dynamic> json) {
    final raw = json['permissions'];
    final codes = raw is List ? raw.map((e) => e.toString()) : <String>[];
    return UserAccess(
      role: (json['role'] as String?).toUserRole(),
      isAdmin: json['is_admin'] == true,
      permissions: codes.map(AppPermission.fromCode).whereType<AppPermission>().toSet(),
    );
  }

  /// Used only while the server has not been migrated yet (no get_my_access):
  /// reproduces the old role-based menus.
  factory UserAccess.legacyFromRole(UserRole? role) {
    return switch (role) {
      UserRole.admin || UserRole.doctor => UserAccess(
        role: role!,
        isAdmin: true,
        permissions: AppPermission.values.toSet(),
      ),
      UserRole.staff => const UserAccess(
        role: UserRole.staff,
        isAdmin: false,
        permissions: {
          AppPermission.bookings,
          AppPermission.queue,
          AppPermission.announcements,
          AppPermission.statistics,
        },
      ),
      _ => none,
    };
  }
}
