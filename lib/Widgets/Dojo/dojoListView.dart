import 'package:flutter/material.dart';

import 'dojoList.dart';

class DojoListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verb Dojo")),
      body: DojoList(),
    );
  }
}
