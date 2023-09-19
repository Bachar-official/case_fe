import 'package:case_fe/domain/entity/arch.dart';
import 'package:case_fe/feature/new_apk_screen/new_apk_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewApkStateHolder extends StateNotifier<NewApkState> {
  NewApkStateHolder() : super(const NewApkState.initial());

  NewApkState get apkState => state;

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setPackage(String package) {
    state = state.copyWith(package: package);
  }

  void setArch(Arch arch) {
    state = state.copyWith(arch: arch);
  }

  void setApk(String? apk) {
    if (apk == null) {
      state = state.copyWith(nullApk: true, apk: null);
    } else {
      state = state.copyWith(apk: apk);
    }
  }
}
