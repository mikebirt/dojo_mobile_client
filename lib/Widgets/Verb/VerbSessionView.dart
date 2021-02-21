import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:verb_client/Domain/Entities/dojo.dart';
import 'package:verb_client/Widgets/Verb/verbSession.dart';

class VerbSessionView extends StatelessWidget {
  final Dojo dojo;
  final int dojoDbId;

  VerbSessionView(this.dojo, this.dojoDbId);

  @override
  Widget build(BuildContext context) {
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
        body: VerbSession(dojo, dojoDbId));
  }
}
