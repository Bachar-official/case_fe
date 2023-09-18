import 'package:case_fe/domain/entity/arch.dart';

class APK {
  final int size;
  final Arch arch;

  const APK({required this.arch, required this.size});

  APK.fromJson(Map<String, dynamic> json)
      : size = json['size'],
        arch = getArchFromString(json['arch']);
}
