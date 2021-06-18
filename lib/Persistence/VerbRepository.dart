import 'package:verb_client/Domain/Entities/verbConjugation.dart';
import 'package:verb_client/Domain/Entities/conjugation.dart';
import 'package:verb_client/Domain/Entities/dojo.dart';
import 'package:verb_client/Domain/Entities/dojoVerb.dart';
import 'package:verb_client/Domain/Entities/verb.dart';
import 'package:verb_client/Persistence/VerbDataContext.dart';
import 'package:verb_client/Domain/Enums/verbType.dart';

class VerbRepository {
  final VerbDataContext _dbContext = VerbDataContext();

  Future<List<Dojo>> getDojos() async {
    return await _dbContext.getDojos();
  }

  Future<List<Verb>> getVerbs(int dojoId) async {
    final int irregularVerbType = verbType.irregular.index;
    List<DojoVerb> dojoVerbs = (await _dbContext.getDojoVerbs())
        .where((element) => element.dojoId == dojoId)
        .toList();
    List<VerbConjugation> verbConjugations =
        await _dbContext.getVerbConjugations();

    List<Verb> verbs = await _dbContext.getVerbs();

    verbs = verbs
        .where((verbElement) => dojoVerbs
            .any((dojoVerbElement) => dojoVerbElement.verbId == verbElement.id))
        .toList();

    verbs.forEach((vElement) {
      if (vElement.typeId == irregularVerbType) {
        vElement.conjugations = verbConjugations
            .where((vcElement) => vcElement.verbId == vElement.id)
            .map((e) => Conjugation(e.italian, e.english))
            .toList();
      }
    });

    return verbs;
  }
}
