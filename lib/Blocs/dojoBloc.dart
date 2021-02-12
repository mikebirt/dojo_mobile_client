import 'dart:async';

import 'package:verb_client/DataServices/dojoDataService.dart';
import 'package:verb_client/Domain/dojoSummary.dart';
import 'package:verb_client/Domain/sessionSummary.dart';
import 'package:verb_client/Persistence/sessionSummaryDB.dart';

class DojoBloc {
  static final DojoBloc _instance = DojoBloc._internal();

  final _controller = StreamController<List<DojoSummary>>.broadcast();
  final SessionSummaryDB _db = SessionSummaryDB();
  final DojoDataService dojoSvc = DojoDataService();

  Stream<List<DojoSummary>> get dojoSummaryStream => _controller.stream;

  factory DojoBloc() {
    return _instance;
  }

  DojoBloc._internal();

  Future storeSummary(sessionSummary) async {
    await _db.storeSummary(sessionSummary);

    await getSummaries();

    return;
  }

  Future<List<DojoSummary>> getSummaries() async {
    final List<SessionSummary> previousSessionSummaries =
        await _db.getSummarys();
    final dojoList = await dojoSvc.getDojos();

    List<DojoSummary> dojoSummaries = dojoList.map((dojo) {
      SessionSummary currentSummary;
      if (previousSessionSummaries
          .any((element) => element.dojoId == dojo.id)) {
        currentSummary = previousSessionSummaries
            .singleWhere((element) => element.dojoId == dojo.id);
      }

      return DojoSummary(dojo.id, dojo.name, currentSummary?.score,
          currentSummary?.dojoDate, currentSummary?.id);
    }).toList();

    _controller.sink.add(dojoSummaries);

    return dojoSummaries;
  }

  void dispose() {
    _controller.close();
  }
}
