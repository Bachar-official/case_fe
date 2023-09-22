Map<String, dynamic> removeNullMapValues(Map<String, dynamic> map) {
  List<String> keysToRemove = [];

  // Находим ключи с значениями null
  map.forEach((key, value) {
    if (value == null || value == '') {
      keysToRemove.add(key);
    }
  });

  // Удаляем ключи с null значениями
  for (String key in keysToRemove) {
    map.remove(key);
  }

  return map;
}
