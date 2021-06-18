import 'dart:core';
import 'dart:math';
import 'package:verb_client/Domain/Entities/dojo.dart';
import 'package:verb_client/Domain/Entities/verb.dart';
import 'package:verb_client/Persistence/VerbRepository.dart';
import 'package:verb_client/Domain/Enums/verbType.dart';
import 'package:verb_client/Domain/Enums/conjugationType.dart';

class DojoDataService {
  final VerbRepository _repo = VerbRepository();
  final Random _rnd = Random();

  Future<List<Dojo>> getDojos() async {
    return await _repo.getDojos();
  }

  Future<List<Verb>> getVerbs(int dojoId) async {
    List<Verb> verbs = await _repo.getVerbs(dojoId);

    verbs.forEach((element) {
      element = _conjugate(element);
    });

    return verbs;
  }

  Verb _conjugate(Verb theVerb) {
    if (theVerb.typeId == verbType.irregular.index) {
      return _irregularConjugation(theVerb);
    }

    return _regularConjugation(theVerb);
  }

  Verb _regularConjugation(Verb theVerb) {
    final int conjugationTypeId = _rnd.nextInt(conjugationType.YouPlural.index);

    theVerb.italian = _applyItalian(theVerb, conjugationTypeId);
    theVerb.english = _applyEnglish(theVerb, conjugationTypeId);

    return theVerb;
  }

  String _applyEnglish(Verb theVerb, int conjugationTypeId) {
    String result = theVerb.english;

    if (conjugationTypeId == conjugationType.I.index) {
      result = "I " + result;
    }
    if (conjugationTypeId == conjugationType.You.index) {
      result = "You " + result;
    }
    if (conjugationTypeId == conjugationType.HeShe.index) {
      result = "He/She " + result + (result.endsWith("h") ? "es" : "s");
    }
    if (conjugationTypeId == conjugationType.We.index) {
      result = "We " + result;
    }
    if (conjugationTypeId == conjugationType.They.index) {
      result = "They " + result;
    }
    if (conjugationTypeId == conjugationType.YouPlural.index) {
      result = "You " + result;
    }

    return result;
  }

  String _applyItalian(Verb theVerb, int conjugationTypeId) {
    String result = theVerb.italian.substring(0, theVerb.italian.length - 3);

    if (theVerb.typeId == verbType.regular_Are.index) {
      if (conjugationTypeId == conjugationType.I.index) {
        result += "o";
      }
      if (conjugationTypeId == conjugationType.You.index) {
        result += "i";
      }
      if (conjugationTypeId == conjugationType.HeShe.index) {
        result += "e";
      }
      if (conjugationTypeId == conjugationType.We.index) {
        result += "iamo";
      }
      if (conjugationTypeId == conjugationType.They.index) {
        result += "ano";
      }
      if (conjugationTypeId == conjugationType.YouPlural.index) {
        result += "ate";
      }
    } else if (theVerb.typeId == verbType.regular_Ire_IscoType.index) {
      if (conjugationTypeId == conjugationType.I.index) {
        result += "isco";
      }
      if (conjugationTypeId == conjugationType.You.index) {
        result += "isci";
      }
      if (conjugationTypeId == conjugationType.HeShe.index) {
        result += "isce";
      }
      if (conjugationTypeId == conjugationType.We.index) {
        result += "iamo";
      }
      if (conjugationTypeId == conjugationType.They.index) {
        result += "iscono";
      }
      if (conjugationTypeId == conjugationType.YouPlural.index) {
        result += "ite";
      }
    } else if (theVerb.typeId == verbType.regular_Ire_OType.index) {
      if (conjugationTypeId == conjugationType.I.index) {
        result += "o";
      }
      if (conjugationTypeId == conjugationType.You.index) {
        result += "i";
      }
      if (conjugationTypeId == conjugationType.HeShe.index) {
        result += "e";
      }
      if (conjugationTypeId == conjugationType.We.index) {
        result += "iamo";
      }
      if (conjugationTypeId == conjugationType.They.index) {
        result += "ono";
      }
      if (conjugationTypeId == conjugationType.YouPlural.index) {
        result += "ite";
      }
    } else if (theVerb.typeId == verbType.regular_Ere.index) {
      if (conjugationTypeId == conjugationType.I.index) {
        result += "o";
      }
      if (conjugationTypeId == conjugationType.You.index) {
        result += "i";
      }
      if (conjugationTypeId == conjugationType.HeShe.index) {
        result += "e";
      }
      if (conjugationTypeId == conjugationType.We.index) {
        result += "iamo";
      }
      if (conjugationTypeId == conjugationType.They.index) {
        result += "ono";
      }
      if (conjugationTypeId == conjugationType.YouPlural.index) {
        result += "ete";
      }
    }

    return result;
  }

  Verb _irregularConjugation(Verb theVerb) {
    final int conjugationIndex = _rnd.nextInt(theVerb.conjugations.length - 1);

    theVerb.italian = theVerb.conjugations[conjugationIndex].italian;
    theVerb.english = theVerb.conjugations[conjugationIndex].english;

    return theVerb;
  }
}
