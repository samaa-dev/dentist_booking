import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'theme_cubit.freezed.dart';
part 'theme_state.dart';

enum AppMode { light, dark }

enum AppTheme {
  deepPurple(seedColor: Colors.deepPurple),
  teal(seedColor: Colors.teal),
  orange(seedColor: Colors.orange),
  pink(seedColor: Colors.pink),
  blue(seedColor: Colors.blue);

  final Color seedColor;

  const AppTheme({required this.seedColor});
}

class ThemeCubit extends HydratedCubit<ThemeState> {
  ThemeCubit()
    : super(
        const ThemeState(
          mode: AppMode.light,
          theme: AppTheme.blue,
        ),
      );

  void toggleMode() {
    emit(
      state.copyWith(
        mode: state.mode == AppMode.dark ? AppMode.light : AppMode.dark,
      ),
    );
  }

  void setTheme(AppTheme theme) {
    emit(state.copyWith(theme: theme));
  }

  void setMode(AppMode mode) {
    emit(state.copyWith(mode: mode));
  }

  @override
  ThemeState fromJson(Map<String, dynamic> json) {
    return ThemeState(
      mode: AppMode.values[json['mode'] as int],
      theme: AppTheme.values[json['theme'] as int],
    );
  }

  @override
  Map<String, dynamic> toJson(ThemeState state) {
    return {
      'mode': state.mode.index,
      'theme': state.theme.index,
    };
  }
}

extension ThemeStateX on ThemeState {
  ThemeMode get themeMode =>
      mode == AppMode.dark ? ThemeMode.dark : ThemeMode.light;

  Color get seedColor {
    return theme.seedColor;
  }
}
