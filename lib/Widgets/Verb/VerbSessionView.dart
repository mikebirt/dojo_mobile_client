import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:verb_client/DataServices/dojoDataService.dart';
import 'package:verb_client/Domain/dojo.dart';
import 'package:verb_client/Domain/verb.dart';
import 'package:verb_client/Widgets/Verb/verbSession.dart';

class VerbSessionView extends StatefulWidget {
  final Dojo dojo;
  final int dojoDbId;

  VerbSessionView(this.dojo, this.dojoDbId);

  @override
  _VerbSessionViewState createState() => _VerbSessionViewState(dojo, dojoDbId);
}

class _VerbSessionViewState extends State<VerbSessionView> {
  final Dojo dojo;
  final int dojoDbId;
  Future<List<Verb>> verbsFuture;

  _VerbSessionViewState(this.dojo, this.dojoDbId);

  @override
  void initState() {
    final dojoSvc = DojoDataService();
    verbsFuture = dojoSvc.getVerbs(this.dojo.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: verbsFuture,
        builder: (context, AsyncSnapshot<List<Verb>> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("an error has occured"));
          }

          return Scaffold(
              appBar: AppBar(
                title: Text("Dojo: " + dojo.name),
                automaticallyImplyLeading: false,
                leading: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.close)),
              ),
              body: snapshot.hasData
                  ? VerbSession(snapshot.data, dojo, dojoDbId)
                  : Center(child: CircularProgressIndicator()));
        });
  }
}
