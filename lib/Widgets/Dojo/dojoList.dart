import 'package:flutter/material.dart';
import 'package:verb_client/Domain/Entities/dojo.dart';
import 'package:verb_client/Domain/Entities/dojoSummary.dart';
import 'package:verb_client/Widgets/Verb/verbSessionView.dart';

import '../styles.dart';

class DojoList extends StatelessWidget {
  final List<DojoSummary> dojoSummaries;

  DojoList(this.dojoSummaries);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: dojoSummaries == null ? 0 : dojoSummaries.length,
        itemBuilder: (BuildContext context, int position) {
          return Card(
              child: ListTile(
            title: Text(dojoSummaries[position].name,
                style: Styles.generalTextSyle),
            subtitle: Text(getDojoSubtitle(dojoSummaries[position])),
            onTap: () {
              MaterialPageRoute route = MaterialPageRoute(
                  builder: (_) => VerbSessionView(
                      Dojo(dojoSummaries[position].id,
                          dojoSummaries[position].name),
                      dojoSummaries[position].dbSessionSummaryId));
              Navigator.push(context, route);
            },
          ));
        });
  }

  String getDojoSubtitle(DojoSummary dojo) {
    if (dojo.score == null) {
      return '';
    }

    String lastScore = dojo.score.correctlyAnswered.toString() +
        ' / ' +
        dojo.score.numberOfVerbs.toString();

    return lastScore + ' on ' + dojo.lastPractise;
  }
}
