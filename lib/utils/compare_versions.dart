int compareVersions({required String version1, required String version2}) {
  final List<int> v1Components = version1.split('.').map(int.parse).toList();
  final List<int> v2Components = version2.split('.').map(int.parse).toList();

  final int minLength = v1Components.length < v2Components.length
      ? v1Components.length
      : v2Components.length;

  for (int i = 0; i < minLength; i++) {
    if (v1Components[i] < v2Components[i]) {
      return -1; // версия 1 меньше
    } else if (v1Components[i] > v2Components[i]) {
      return 1; // версия 1 больше
    }
  }

  // Если все компоненты версий до minLength равны, сравниваем длины версий
  if (v1Components.length < v2Components.length) {
    return -1; // версия 1 меньше
  } else if (v1Components.length > v2Components.length) {
    return 1; // версия 1 больше
  }

  return 0; // версии равны
}
