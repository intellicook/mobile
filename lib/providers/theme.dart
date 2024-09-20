import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme.g.dart';

@riverpod
class Theme extends _$Theme {
  @override
  ThemeState build() {
    return const ThemeState(ThemeMode.system);
  }

  void set(ThemeMode mode) {
    state = ThemeState(mode);
  }
}

class ThemeState {
  const ThemeState(this.mode);

  final ThemeMode mode;
}
