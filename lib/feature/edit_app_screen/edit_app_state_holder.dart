import 'dart:io';
import 'dart:typed_data';

import 'package:case_fe/feature/edit_app_screen/edit_app_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditAppStateHolder extends StateNotifier<EditAppState> {
  EditAppStateHolder() : super(const EditAppState.initial());

  EditAppState get editState => state;

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void setVersion(String version) {
    state = state.copyWith(version: version);
  }

  void setDescription(String description) {
    state = state.copyWith(description: description);
  }

  void setIcon(File? icon) {
    if (icon != null) {
      state = state.copyWith(icon: icon);
    } else {
      state = state.copyWith(icon: null, nullIcon: true);
    }
  }

  void setWebIcon(Uint8List? bytes) {
    if (bytes != null) {
      state = state.copyWith(webIcon: bytes);
    } else {
      state = state.copyWith(webIcon: null, nullIcon: true);
    }
  }
}
