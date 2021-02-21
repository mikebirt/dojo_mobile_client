class VerbValidation {
  static bool test(String targetValue, String testValue) {
    if (targetValue.toLowerCase().startsWith('he/she')) {
      final String withoutObject = targetValue.replaceRange(0, 6, '');

      return 'he' + withoutObject.toLowerCase() == testValue.toLowerCase() ||
          'she' + withoutObject.toLowerCase() == testValue.toLowerCase();
    }

    return targetValue.toLowerCase() == testValue.toLowerCase();
  }
}
