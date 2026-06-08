import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../storage/hive_storage.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(_load());

  static ThemeMode _load() {
    final val =
        HiveStorage.app.get(HiveKeys.themeMode, defaultValue: 'system') as String;
    return switch (val) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  void cycle() {
    final next = switch (state) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };
    HiveStorage.app.put(HiveKeys.themeMode, next.name);
    emit(next);
  }

  IconData get icon => switch (state) {
        ThemeMode.light => Icons.light_mode_rounded,
        ThemeMode.dark => Icons.dark_mode_rounded,
        ThemeMode.system => Icons.brightness_auto_rounded,
      };

  String get label => switch (state) {
        ThemeMode.light => 'Light',
        ThemeMode.dark => 'Dark',
        ThemeMode.system => 'Auto',
      };
}
