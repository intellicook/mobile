import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme.g.dart';

@riverpod
class Theme extends _$Theme {
  @override
  Future<ThemeState> build() async {
    return const ThemeState(ThemeMode.system);
  }

  Future<void> set(ThemeMode mode) async {
    state = AsyncData(ThemeState(mode));
  }
}

class ThemeState {
  const ThemeState(this.mode);

  final ThemeMode mode;
}
