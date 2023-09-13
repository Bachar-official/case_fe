enum Arch { x86_64, armv7, armv8, common }

Arch getArchFromString(String arch) {
  return Arch.values.firstWhere((ar) => ar.name == arch.toLowerCase(),
      orElse: () => Arch.common);
}

String getStringFromArch(Arch? arch) {
  return arch == null ? Arch.common.name : arch.name;
}
