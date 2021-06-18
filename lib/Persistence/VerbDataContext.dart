import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:verb_client/Domain/Entities/dojo.dart';
import 'package:verb_client/Domain/Entities/verb.dart';
import 'package:verb_client/Domain/Entities/dojoVerb.dart';
import 'package:verb_client/Domain/Entities/verbConjugation.dart';

class VerbDataContext {
  Database _db;
  final int _version = 1;

  static final VerbDataContext _instance = VerbDataContext._internal();

  factory VerbDataContext() {
    return _instance;
  }

  VerbDataContext._internal();

  Future<List<Dojo>> getDojos() async {
    await openDb();

    List<Map> dojoMaps = await _db.rawQuery('SELECT * FROM Dojo');
    List<Dojo> dojos = [];

    dojoMaps.forEach((element) {
      dojos.add(new Dojo(element['Id'], element['Name']));
    });

    return dojos;
  }

  Future<List<Verb>> getVerbs() async {
    await openDb();

    List<Map> verbMaps = await _db.rawQuery('SELECT * FROM Verb');
    List<Verb> verbs = [];

    verbMaps.forEach((element) {
      verbs.add(new Verb(element['Id'], element['TypeId'], element['Italian'],
          element['English']));
    });

    return verbs;
  }

  Future<List<DojoVerb>> getDojoVerbs() async {
    await openDb();

    List<Map> dojoVerbMaps = await _db.rawQuery('SELECT * FROM DojoVerb');
    List<DojoVerb> dojoVerbs = [];

    dojoVerbMaps.forEach((element) {
      dojoVerbs.add(
          new DojoVerb(element['Id'], element['DojoId'], element['VerbId']));
    });

    return dojoVerbs;
  }

  Future<List<VerbConjugation>> getVerbConjugations() async {
    await openDb();

    List<Map> dojoVerbMaps =
        await _db.rawQuery('SELECT * FROM VerbConjugation');
    List<VerbConjugation> verbConjugations = [];

    dojoVerbMaps.forEach((element) {
      verbConjugations.add(new VerbConjugation(
          element['Id'],
          element['ConjugationId'],
          element['VerbId'],
          element['Italian'],
          element['English']));
    });

    return verbConjugations;
  }

  Future<Database> openDb() async {
    if (_db == null) {
      print('creating DB...');

      Sqflite.getDebugModeOn();

      // Get a location using getDatabasesPath
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'verb.db');

      // Delete the database
      // await deleteDatabase(path);

      _db = await openDatabase(path,
          version: _version, onCreate: _onCreateVerbDB);
    }

    return _db;
  }

  Future<void> _onCreateVerbDB(Database db, int version) async {
    await _createDbSchema(db);
    await _populateDB(db);
  }

  Future<void> _createDbSchema(Database db) async {
    await db.execute(
        "CREATE TABLE Conjugation (Id INTEGER PRIMARY KEY, Object TEXT)");

    await db.execute("CREATE TABLE Dojo (Id INTEGER PRIMARY KEY, Name TEXT)");

    await db.execute(
        "CREATE TABLE DojoVerb (Id INTEGER PRIMARY KEY, DojoId INTEGER, VerbId INTEGER)");

    await db.execute(
        "CREATE TABLE Verb (Id INTEGER PRIMARY KEY, TypeId INTEGER, Italian TEXT, English TEXT)");

    await db.execute(
        "CREATE TABLE VerbConjugation (Id INTEGER PRIMARY KEY, ConjugationId INTEGER, VerbId INTEGER, Italian TEXT, English TEXT)");

    await db.execute(
        "CREATE TABLE VerbType (Id INTEGER PRIMARY KEY, Name TEXT, IsRegular INTEGER)");
  }

  Future<void> _populateDB(Database db) async {
    List<String> inserts = [
      // verbTypeInserts
      'INSERT INTO [VerbType] ([Name], [IsRegular]) VALUES ("-are", 1)',
      'INSERT INTO [VerbType] ([Name], [IsRegular]) VALUES ("-ere", 1)',
      'INSERT INTO [VerbType] ([Name], [IsRegular]) VALUES ("-ire-isco", 1)',
      'INSERT INTO [VerbType] ([Name], [IsRegular]) VALUES ("-ire-o", 1)',
      'INSERT INTO [VerbType] ([Name], [IsRegular]) VALUES ("Irregular", 0)',

      // conjugationTypeInserts
      'INSERT INTO [Conjugation] ([Object]) VALUES ("I")',
      'INSERT INTO [Conjugation] ([Object]) VALUES ("You")',
      'INSERT INTO [Conjugation] ([Object]) VALUES ("He/She")',
      'INSERT INTO [Conjugation] ([Object]) VALUES ("We")',
      'INSERT INTO [Conjugation] ([Object]) VALUES ("They")',
      'INSERT INTO [Conjugation] ([Object]) VALUES ("You(p)")',

      // verbInserts
      'INSERT INTO [Verb] ([TypeId], [Italian], [English]) VALUES (1, "Guardare", "Watch")',
      'INSERT INTO [Verb] ([TypeId], [Italian], [English]) VALUES (1, "Pensare", "Think")',
      'INSERT INTO [Verb] ([TypeId], [Italian], [English]) VALUES (1, "Parlare", "Talk")',
      'INSERT INTO [Verb] ([TypeId], [Italian], [English]) VALUES (1, "Imparare", "Learn")',
      'INSERT INTO [Verb] ([TypeId], [Italian], [English]) VALUES (2, "Ricevere", "Receive")',
      'INSERT INTO [Verb] ([TypeId], [Italian], [English]) VALUES (2, "Correre", "Run")',
      'INSERT INTO [Verb] ([TypeId], [Italian], [English]) VALUES (2, "Tenere", "Keep")',
      'INSERT INTO [Verb] ([TypeId], [Italian], [English]) VALUES (2, "Vendere", "Sell")',
      'INSERT INTO [Verb] ([TypeId], [Italian], [English]) VALUES (3, "Costruire", "Build")',
      'INSERT INTO [Verb] ([TypeId], [Italian], [English]) VALUES (3, "Colpire", "Hit")',
      'INSERT INTO [Verb] ([TypeId], [Italian], [English]) VALUES (3, "Finire", "To Finish")',
      'INSERT INTO [Verb] ([TypeId], [Italian], [English]) VALUES (3, "Pulire", "Clean")',
      'INSERT INTO [Verb] ([TypeId], [Italian], [English]) VALUES (4, "Riempire", "Fill")',
      'INSERT INTO [Verb] ([TypeId], [Italian], [English]) VALUES (4, "Dormire", "Sleep")',
      'INSERT INTO [Verb] ([TypeId], [Italian], [English]) VALUES (4, "Partire", "Leave")',
      'INSERT INTO [Verb] ([TypeId], [Italian], [English]) VALUES (5, "Fare", "Do")',
      'INSERT INTO [Verb] ([TypeId], [Italian], [English]) VALUES (5, "Venire", "Come")',
      'INSERT INTO [Verb] ([TypeId], [Italian], [English]) VALUES (5, "Dire", "Say")',
      'INSERT INTO [Verb] ([TypeId], [Italian], [English]) VALUES (5, "Vedere", "See")',
      'INSERT INTO [Verb] ([TypeId], [Italian], [English]) VALUES (5, "Andare", "Go")',

      // irregularConjugationInserts
      'INSERT INTO [VerbConjugation] (ConjugationId, VerbId, Italian, English) VALUES (1, 16, "Faccio", "I Do")',
      'INSERT INTO [VerbConjugation] (ConjugationId, VerbId, Italian, English) VALUES (2, 16, "Fai", "You Do")',
      'INSERT INTO [VerbConjugation] (ConjugationId, VerbId, Italian, English) VALUES (3, 16, "Fa", "He/She Does")',
      'INSERT INTO [VerbConjugation] (ConjugationId, VerbId, Italian, English) VALUES (4, 16, "Facciamo", "We Do")',
      'INSERT INTO [VerbConjugation] (ConjugationId, VerbId, Italian, English) VALUES (5, 16, "Fanno", "They Do")',
      'INSERT INTO [VerbConjugation] (ConjugationId, VerbId, Italian, English) VALUES (6, 16, "Fate", "You(p) Do")',
      'INSERT INTO [VerbConjugation] (ConjugationId, VerbId, Italian, English) VALUES (1, 17, "Vengo", "I Come")',
      'INSERT INTO [VerbConjugation] (ConjugationId, VerbId, Italian, English) VALUES (2, 17, "Vieni", "You Come")',
      'INSERT INTO [VerbConjugation] (ConjugationId, VerbId, Italian, English) VALUES (3, 17, "Viene", "He/She Comes")',
      'INSERT INTO [VerbConjugation] (ConjugationId, VerbId, Italian, English) VALUES (4, 17, "Veniamo", "We Come")',
      'INSERT INTO [VerbConjugation] (ConjugationId, VerbId, Italian, English) VALUES (5, 17, "Vengono", "They Come")',
      'INSERT INTO [VerbConjugation] (ConjugationId, VerbId, Italian, English) VALUES (6, 17, "Venite", "You (p) Come")',
      'INSERT INTO [VerbConjugation] (ConjugationId, VerbId, Italian, English) VALUES (1, 18, "Dico", "I Say")',
      'INSERT INTO [VerbConjugation] (ConjugationId, VerbId, Italian, English) VALUES (2, 18, "Dici", "You Say")',
      'INSERT INTO [VerbConjugation] (ConjugationId, VerbId, Italian, English) VALUES (3, 18, "Dice", "He/She Says")',
      'INSERT INTO [VerbConjugation] (ConjugationId, VerbId, Italian, English) VALUES (4, 18, "Diciamo", "We Say")',
      'INSERT INTO [VerbConjugation] (ConjugationId, VerbId, Italian, English) VALUES (5, 18, "Dicono", "They Say")',
      'INSERT INTO [VerbConjugation] (ConjugationId, VerbId, Italian, English) VALUES (6, 18, "Dite", "You (p) Say")',
      'INSERT INTO [VerbConjugation] (ConjugationId, VerbId, Italian, English) VALUES (1, 19, "Vedo", "I See")',
      'INSERT INTO [VerbConjugation] (ConjugationId, VerbId, Italian, English) VALUES (2, 19, "Vedi", "You See")',
      'INSERT INTO [VerbConjugation] (ConjugationId, VerbId, Italian, English) VALUES (3, 19, "Vede", "He/See Sees")',
      'INSERT INTO [VerbConjugation] (ConjugationId, VerbId, Italian, English) VALUES (4, 19, "Vediamo", "We See")',
      'INSERT INTO [VerbConjugation] (ConjugationId, VerbId, Italian, English) VALUES (5, 19, "Vedono", "They See")',
      'INSERT INTO [VerbConjugation] (ConjugationId, VerbId, Italian, English) VALUES (6, 19, "Vedete", "You (p) See")',
      'INSERT INTO [VerbConjugation] (ConjugationId, VerbId, Italian, English) VALUES (1, 20, "Vado", "I Go")',
      'INSERT INTO [VerbConjugation] (ConjugationId, VerbId, Italian, English) VALUES (2, 20, "Vai", "You Go")',
      'INSERT INTO [VerbConjugation] (ConjugationId, VerbId, Italian, English) VALUES (3, 20, "Va", "He/She Goes")',
      'INSERT INTO [VerbConjugation] (ConjugationId, VerbId, Italian, English) VALUES (4, 20, "Andiamo", "We Go")',
      'INSERT INTO [VerbConjugation] (ConjugationId, VerbId, Italian, English) VALUES (5, 20, "Vanno", "They Go")',
      'INSERT INTO [VerbConjugation] (ConjugationId, VerbId, Italian, English) VALUES (6, 20, "Andate", "You (p) Go")',

      // dojoInserts
      'INSERT INTO [Dojo] ([Name]) VALUES ("Regular ARE")',
      'INSERT INTO [Dojo] ([Name]) VALUES ("Regular ERE")',
      'INSERT INTO [Dojo] ([Name]) VALUES ("Regular IRE type 1")',
      'INSERT INTO [Dojo] ([Name]) VALUES ("Regular IRE type 2")',
      'INSERT INTO [Dojo] ([Name]) VALUES ("Regular Full")',
      'INSERT INTO [Dojo] ([Name]) VALUES ("Irregular Full")',
      'INSERT INTO [Dojo] ([Name]) VALUES ("All Mixed")',

      // dojoVerbsInserts
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (1, 1)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (1, 2)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (1, 3)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (1, 4)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (2, 5)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (2, 6)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (2, 7)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (2, 8)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (3, 9)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (3, 10)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (3, 11)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (3, 12)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (4, 13)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (4, 14)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (4, 15)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (5, 1)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (5, 2)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (5, 3)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (5, 3)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (5, 5)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (5, 6)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (5, 7)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (5, 8)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (5, 9)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (5, 10)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (5, 11)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (5, 12)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (5, 13)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (5, 14)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (5, 15)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (6, 16)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (6, 17)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (6, 18)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (6, 19)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (6, 20)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (7, 1)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (7, 2)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (7, 3)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (7, 3)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (7, 5)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (7, 6)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (7, 7)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (7, 8)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (7, 9)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (7, 10)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (7, 11)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (7, 12)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (7, 13)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (7, 14)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (7, 15)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (7, 16)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (7, 17)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (7, 18)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (7, 19)',
      'INSERT INTO [DojoVerb] ([DojoId],[VerbId]) VALUES (7, 20)'
    ];

    inserts.forEach((element) async {
      await db.execute(element);
    });
  }
}
