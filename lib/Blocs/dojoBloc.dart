import 'dart:async';

import 'package:verb_client/DataServices/dojoDataService.dart';
import 'package:verb_client/Domain/Entities/dojoSummary.dart';
import 'package:verb_client/Domain/Entities/sessionSummary.dart';
import 'package:verb_client/Persistence/sessionSummaryDB.dart';

class DojoBloc {
  static final DojoBloc _instance = DojoBloc._internal();

  final _controller = StreamController<List<DojoSummary>>.broadcast();
  final _summaryController = StreamController<SessionSummary>();
  final SessionSummaryDB _db = SessionSummaryDB();
  final DojoDataService dojoSvc = DojoDataService();

  Stream<List<DojoSummary>> get dojoSummaryStream => _controller.stream;

  List<DojoSummary> summariesCache;

  factory DojoBloc() {
    return _instance;
  }

  DojoBloc._internal();

  Future<SessionSummary> storeSummary(sessionSummary) async {
    await _db.storeSummary(sessionSummary);

    await getSummaries();

    _summaryController.sink.add(sessionSummary);

    return sessionSummary;
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

    summariesCache = dojoSummaries;

    _controller.sink.add(dojoSummaries);

    return dojoSummaries;
  }

  void dispose() {
    _controller.close();
    _summaryController.close();
  }
}
