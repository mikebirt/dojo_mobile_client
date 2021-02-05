import 'package:flutter/material.dart';

import 'package:verb_client/DataServices/dojoDataService.dart';
import 'package:verb_client/Widgets/Verb/VerbSessionView.dart';

import '../styles.dart';

class DojoList extends StatefulWidget {
  @override
  _DojoListState createState() => _DojoListState();
}

class _DojoListState extends State<DojoList> {
  List dojoList;
  DojoDataService dojoSvc;

  @override
  void initState() {
    dojoSvc = DojoDataService();

    loadDojoList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: dojoList == null ? 0 : dojoList.length,
        itemBuilder: (BuildContext context, int position) {
          return Card(
              child: ListTile(
            title: Text(dojoList[position].name, style: Styles.generalTextSyle),
            onTap: () {
              MaterialPageRoute route = MaterialPageRoute(
                  builder: (_) => VerbSessionView(dojoList[position]));
              Navigator.push(context, route);
            },
          ));
        });
  }

  void loadDojoList() async {
    final List dojos = await dojoSvc.getDojos();

    if (dojos != null) {
      setState(() {
        dojoList = dojos;
      });
    }
  }
}
