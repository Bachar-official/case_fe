import 'dart:io';
import 'dart:typed_data';

import 'package:case_fe/feature/new_app_screen/new_app_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewAppStateHolder extends StateNotifier<NewAppState> {
  NewAppStateHolder() : super(const NewAppState.initial());

  NewAppState get appState => state;

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void setPackage(String package) {
    state = state.copyWith(package: package);
  }

  void setVersion(String version) {
    state = state.copyWith(version: version);
  }

  void setIcon(File? icon) {
    if (icon == null) {
      state = state.copyWith(nullIcon: true, icon: icon);
    } else {
      state = state.copyWith(icon: icon);
    }
  }

  void setWebIcon(Uint8List? webIcon) {
    if (webIcon == null) {
      state = state.copyWith(nullIcon: true, webIcon: webIcon);
    } else {
      state = state.copyWith(webIcon: webIcon);
    }
  }

  void setDescription(String description) {
    state = state.copyWith(description: description);
  }
}
