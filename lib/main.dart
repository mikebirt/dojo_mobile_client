import 'package:flutter/material.dart';

import 'Widgets/Dojo/dojoListView.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Verb Dojo',
      home: DojoListView(),
    );
  }
}
