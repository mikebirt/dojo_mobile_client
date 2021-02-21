class VerbHelper {
  bool isHelpAvailable(String correctText, String enteredText) {
    if (enteredText == "") {
      return true;
    } else {
      if (correctText.toLowerCase().startsWith("he/she")) {
        var correctVerbConjugation = correctText.substring(7);

        var heOption = "He " + correctVerbConjugation;
        var sheOption = "She " + correctVerbConjugation;

        return (heOption.toLowerCase().startsWith(enteredText.toLowerCase()) &&
                heOption.toLowerCase() != enteredText.toLowerCase()) ||
            (sheOption.toLowerCase().startsWith(enteredText.toLowerCase()) &&
                sheOption.toLowerCase() != enteredText.toLowerCase());
      } else {
        return correctText
                .toLowerCase()
                .startsWith(enteredText.toLowerCase()) &&
            correctText.toLowerCase() != enteredText.toLowerCase();
      }
    }
  }

  String getHelp(String correctText, String enteredText) {
    if (isHelpAvailable(correctText, enteredText)) {
      if (correctText.toLowerCase().startsWith("he/she")) {
        var correctVerbConjugation = correctText.substring(7);
        String option;

        if (enteredText == "" || enteredText.toLowerCase().startsWith("s")) {
          option = "She " + correctVerbConjugation;
        } else {
          option = "He " + correctVerbConjugation;
        }

        var addition =
            option.substring(enteredText.length, enteredText.length + 1);
        return enteredText + addition;
      } else {
        var addition =
            correctText.substring(enteredText.length, enteredText.length + 1);
        return enteredText + addition;
      }
    }

    return enteredText;
  }
}
