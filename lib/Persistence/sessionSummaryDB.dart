import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:verb_client/Domain/Entities/sessionSummary.dart';

class SessionSummaryDB {
  static final SessionSummaryDB _instance = SessionSummaryDB._internal();
  DatabaseFactory dbFactory = databaseFactoryIo;
  final store = intMapStoreFactory.store('sessionSummarys');
  Database _database;

  SessionSummaryDB._internal();

  factory SessionSummaryDB() {
    return _instance;
  }

  Future storeSummary(SessionSummary summary) async {
    debugPrint('SessionSummaryDB.storeSummary (' +
        (summary.id == null ? 'null' : summary.id.toString()) +
        ')');
    await initialise();

    final summarys = await getSummarys();

    if (summarys.any((element) => element.dojoId == summary.dojoId)) {
      debugPrint(
          'existing dojo summary found - updating! ' + summary.toString());
      final finder = Finder(filter: Filter.byKey(summary.id));
      await store.update(_database, summary.toMap(), finder: finder);
    } else {
      debugPrint(
          'existing dojo summary NOT found - adding!' + summary.toString());
      await store.add(_database, summary.toMap());
    }
  }

  Future<List<SessionSummary>> getSummarys() async {
    debugPrint('SessionSummaryDB.getSummarys');
    await initialise();

    final summarySnapshots = await store.find(_database);

    return summarySnapshots.map((item) {
      final summary = SessionSummary.fromMap(item.value);
      summary.id = item.key;
      return summary;
    }).toList();
  }

  Future initialise() async {
    debugPrint('SessionSummaryDB.initialise');
    if (_database == null) {
      await _openDb().then((db) {
        _database = db;
      });
    }
  }

  Future<Database> _openDb() async {
    debugPrint('SessionSummaryDB._openDb');
    final docsPath = await getApplicationDocumentsDirectory();
    final dbPath = join(docsPath.path, 'sessionSummarys.db');

    final db = await dbFactory.openDatabase(dbPath);

    return db;
  }
}
