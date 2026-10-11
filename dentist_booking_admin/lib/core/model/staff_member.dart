import '../access/app_permission.dart';
import '../enum/enum.dart';

/// A staff account as returned by `get_staff_members`.
class StaffMember {
  const StaffMember({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.position,
    required this.isActive,
    required this.permissions,
    required this.lastSeen,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String fullName;
  final String email;
  final String? phone;
  final StaffPosition position;
  final bool isActive;
  final Set<AppPermission> permissions;
  final DateTime? lastSeen;
  final DateTime createdAt;

  factory StaffMember.fromJson(Map<String, dynamic> json) {
    final rawPermissions = json['permissions'];
    return StaffMember(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      fullName: (json['full_name'] as String?) ?? '',
      email: (json['email'] as String?) ?? '',
      phone: json['phone'] as String?,
      position: StaffPosition.values.firstWhere(
        (p) => p.code == json['position'],
        orElse: () => StaffPosition.receptionist,
      ),
      isActive: json['is_active'] == true,
      permissions: (rawPermissions is List ? rawPermissions : const [])
          .map((e) => AppPermission.fromCode(e.toString()))
          .whereType<AppPermission>()
          .toSet(),
      lastSeen: DateTime.tryParse('${json['last_seen']}')?.toLocal(),
      createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
    );
  }
}

/// Fields the admin fills in when creating or editing a staff account.
class StaffDraft {
  const StaffDraft({
    required this.fullName,
    required this.phone,
    required this.position,
    required this.permissions,
    this.email,
    this.password,
  });

  final String fullName;
  final String phone;
  final StaffPosition position;
  final Set<AppPermission> permissions;

  /// Only used when creating an account.
  final String? email;
  final String? password;
}
