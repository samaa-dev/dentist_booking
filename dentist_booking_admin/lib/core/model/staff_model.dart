import 'package:freezed_annotation/freezed_annotation.dart';

import '../enum/enum.dart';

part 'staff_model.freezed.dart';
part 'staff_model.g.dart';

@freezed
class StaffModel with _$StaffModel {
  const factory StaffModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'full_name') required String fullName,
    required String email,
    String? phone,

    /// matching enums
    required StaffPosition position,
    @JsonKey(name: 'shift_type') required ShiftType shiftType,
    @JsonKey(name: 'account_status') required AccountStatus status,

    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _StaffModel;

  /// ⬅️ fromJson
  factory StaffModel.fromJson(Map<String, dynamic> json) =>
      _$StaffModelFromJson(json);
}
