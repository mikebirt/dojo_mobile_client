import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:verb_client/Blocs/dojoBloc.dart';
import 'package:verb_client/Domain/dojo.dart';
import 'package:verb_client/Domain/dojoSummary.dart';
import 'package:verb_client/Widgets/Dojo/dojoList.dart';

class DojoListView extends StatefulWidget {
  @override
  _DojoListViewState createState() => _DojoListViewState();
}

class _DojoListViewState extends State<DojoListView> {
  List<Dojo> dojoList;
  Future dataLoadFuture;
  DojoBloc dojoBloc;

  @override
  void initState() {
    dojoBloc = DojoBloc();
    dojoBloc.getSummaries();

/*
    dojoBloc.dojoSummaryStream.listen((event) {
      debugPrint('EVENT ON The STREAM!');
    });
*/

    super.initState();
  }

  @override
  void dispose() {
    dojoBloc.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<DojoSummary>>(
        builder: (context, AsyncSnapshot<List<DojoSummary>> snapshot) {
          return Scaffold(
              appBar: AppBar(
                title: Text("Verb Dojo"),
              ),
              body: snapshot.hasData
                  ? DojoList(snapshot.data)
                  : Center(child: CircularProgressIndicator()));
        },
        initialData: [],
        stream: dojoBloc.dojoSummaryStream);
  }
}
