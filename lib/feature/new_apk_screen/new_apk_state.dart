import 'dart:typed_data';

import 'package:case_fe/domain/entity/arch.dart';
import 'package:flutter/material.dart';

@immutable
class NewApkState {
  final Arch arch;
  final String package;
  final Uint8List? apk;
  final bool isLoading;

  const NewApkState(
      {required this.apk,
      required this.arch,
      required this.package,
      required this.isLoading});

  const NewApkState.initial()
      : arch = Arch.common,
        package = '',
        isLoading = false,
        apk = null;

  NewApkState copyWith(
          {Arch? arch,
          String? package,
          bool? isLoading,
          Uint8List? apk,
          bool nullApk = false}) =>
      NewApkState(
          apk: nullApk ? null : apk ?? this.apk,
          arch: arch ?? this.arch,
          package: package ?? this.package,
          isLoading: isLoading ?? this.isLoading);
}
