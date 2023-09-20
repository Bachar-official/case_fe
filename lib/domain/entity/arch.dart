enum Arch { x86_64, armv7, armv8, common }

Arch getArchFromString(String arch) {
  return Arch.values.firstWhere((ar) => ar.name == arch.toLowerCase(),
      orElse: () => Arch.common);
}

Arch getArchFromAbi(String abi) {
  switch (abi) {
    case 'x86_64':
      return Arch.x86_64;
    case 'arm64-v8a':
      return Arch.armv8;
    case 'armeabi-v7a':
      return Arch.armv7;
    default:
      return Arch.common;
  }
}

String getStringFromArch(Arch? arch) {
  return arch == null ? Arch.common.name : arch.name;
}

String getArchDescription(Arch? arch) {
  switch (arch) {
    case null:
      return 'Не выбрано';
    case Arch.common:
      return 'Универсальная';
    case Arch.armv7:
      return 'ARM v7';
    case Arch.armv8:
      return 'ARM v8';
    case Arch.x86_64:
      return 'x86_64';
  }
}
