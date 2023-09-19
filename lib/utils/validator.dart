class Validator {
  static String? validatePackage(String? input) {
    if (input == null || input.isEmpty) {
      return "Поле обязательно для заполнения";
    }

    final regExp = RegExp(r'^[a-z]+\.[a-z]+\.[a-z]+$');

    if (!regExp.hasMatch(input)) {
      return "Неправильный формат строки";
    }

    return null;
  }

  static String? validateVersion(String? input) {
    if (input == null || input.isEmpty) {
      return "Поле обязательно для заполнения";
    }

    final regExp = RegExp(r'^\d+\.\d+\.\d+$');

    if (!regExp.hasMatch(input)) {
      return "Неправильный формат строки";
    }

    return null;
  }

  static String? validateEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Поле обязательно для заполнения';
    }
    return null;
  }
}
