import 'package:flutter/material.dart';

import 'package:verb_client/DataServices/dojoDataService.dart';
import 'package:verb_client/Domain/dojo.dart';

class VerbList extends StatefulWidget {
  final Dojo dojo;

  VerbList(this.dojo);

  @override
  _VerbListState createState() => _VerbListState(dojo);
}

class _VerbListState extends State<VerbList> {
  final Dojo dojo;
  List verbList;
  DojoDataService dojoSvc;

  _VerbListState(this.dojo);

  @override
  void initState() {
    dojoSvc = DojoDataService();

    loadVerbsList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: verbList == null ? 0 : verbList.length,
        itemBuilder: (BuildContext context, int position) {
          return Card(
              child: ListTile(
            title: Text(verbList[position].italian),
            subtitle: Text(verbList[position].english),
          ));
        });
  }

  void loadVerbsList() async {
    final List verbs = await dojoSvc.getVerbs(this.dojo.id);

    if (verbs != null) {
      setState(() {
        verbList = verbs;
      });
    }
  }
}
