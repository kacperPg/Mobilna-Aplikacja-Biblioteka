class MyValidators {
  static String? displayNamevalidator(String? displayName) {
    if (displayName == null || displayName.isEmpty) {
      return 'Nazwa użytkownika nie może być pusta';
    }
    if (displayName.length < 3 || displayName.length > 20) {
      return 'Nazwa użytkownika musi mieć od 3 do 20 znaków';
    }

    return null; 
  }

  static String? emailValidator(String? value) {
    if (value!.isEmpty) {
      return 'Proszę podać adres email';
    }
    if (!RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')
        .hasMatch(value)) {
      return 'Proszę podać poprawny adres email';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value!.isEmpty) {
      return 'Proszę podać hasło';
    }
    if (value.length < 6) {
      return 'Hasło musi zawierać co najmniej 6 znaków';
    }
    return null;
  }

  static String? repeatPasswordValidator({String? value, String? password}) {
    if (value != password) {
      return 'Hasła się nie zgadzają';
    }
    return null;
  }

  static String? uploadProdTexts({String? value, String? toBeReturnedString}) {
    if (value!.isEmpty) {
      return toBeReturnedString;
    }
    return null;
  }
}
