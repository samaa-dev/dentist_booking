part of 'theme_cubit.dart';

@freezed
class ThemeState with _$ThemeState {
  const factory ThemeState({
    required AppMode mode,
    required AppTheme theme,
  }) = _ThemeState;

  // factory ThemeState.fromJson(Map<String, dynamic> json) =>
  //     _$ThemeStateFromJson(json);
}
